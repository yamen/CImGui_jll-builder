# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "CImGui"
version = v"1.81.5"

# Collection of sources required to build CImGui
sources = [
    GitSource("https://github.com/ocornut/imgui.git",
              "7180e9ac661ea1c7b9dca6c89319049bb651c404"),

    GitSource("https://github.com/cimgui/cimgui.git",
              "41b397020ac8dbc36ee9a95adb47769d4c8cc1dd"),

    GitSource("https://github.com/epezent/implot.git",
              "a9d334791563cdaf9bd0bf7f9899a67bcd03179b"),              

    GitSource("https://github.com/cimgui/cimplot.git",
              "3714ad8397ec500d13c843ade297145aca354dcb"),                         

    DirectorySource("./bundled"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir

# we have four source folders (imgui, cimgui, implot, cimplot)
# we want to use cimgui as the build directory
# to do this we need to move files from the other three directories into there
# we also want to flatten imgui and implot into one build

# remove default make config
rm cimgui/CMakeLists.txt

# add include cimgui line to cimplot.h
sed -i '/#ifdef CIMGUI_DEFINE_ENUMS_AND_STRUCTS/ a  #include "cimgui.h"' cimplot/cimplot.h

# ensure implot headers are available under the target build dir
mkdir cimgui/implot
cp implot/*.h cimgui/implot/

# make sure all implot files are alongside imgui files
mv implot/* imgui

# copy all relevant files and dirs over to target compile dir
mv cimplot/cimplot.h cimplot/cimplot.cpp imgui wrapper/helper.c wrapper/helper.h wrapper/CMakeLists.txt cimgui/

# now compile
mkdir -p cimgui/build && cd cimgui/build
cmake .. -DCMAKE_INSTALL_PREFIX=${prefix} -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TARGET_TOOLCHAIN} -DCMAKE_BUILD_TYPE=Release
make -j${nproc}
make install
install_license ../LICENSE ../imgui/LICENSE.txt
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [ Windows(:x86_64) ] # supported_platforms()

# The products that we will ensure are always built
products = [
    LibraryProduct("libimgui-cpp", :libimgui),
    LibraryProduct("libcimgui", :libcimgui),
    LibraryProduct("libcimgui_helper", :libcimgui_helper),
    FileProduct("share/compile_commands.json", :compile_commands)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
