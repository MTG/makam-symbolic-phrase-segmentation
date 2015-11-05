#!/bin/bash
echo Running "$@"
export LD_LIBRARY_PATH=/usr/local/MATLAB/MATLAB_Runtime/v85/bin/glnxa64  
export XAPPLRESDIR=/usr/local/MATLAB/MATLAB_Runtime/v85/X11/app-defaults 
"$@"
