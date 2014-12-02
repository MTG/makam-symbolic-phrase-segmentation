#!/bin/bash
echo Running "$@"
export LD_LIBRARY_PATH=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v82/bin/glnxa64 
export XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Compiler_Runtime/v82/X11/app-defaults 
"$@"