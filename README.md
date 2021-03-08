Merge of binary builders for:

- CImGui (https://github.com/JuliaPackaging/Yggdrasil/tree/master/C/CImGui)
- CImPlot (https://github.com/JuliaPackaging/Yggdrasil/tree/master/C/CImPlot)

Including some other changes:

- Updated to 1.81 docking branch (including removing some obselete references)
- Added tables support
- Added cimgui.h reference in cimplot.h
- Kept only Windows support

These are used to build the CImGui_jll package here: https://github.com/yamen/CImGui_jll.jl

That is used in https://github.com/yamen/CImGui.jl and https://github.com/yamen/ImPlot.jl

### Usage

At the moment this requires a local build using BinaryBuilder (confirmed working on WSL with Julia 1.5.3), and optionally deploys to GitHub:

`julia --color=yes build_tarballs.jl --verbose --debug --deploy="yamen/CImGui_jll.jl"`

Just ensure `GITHUB_TOKEN` environment variable is set to personal access token.
