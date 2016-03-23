#!/bin/bash
echo Running "$@"
export DYLD_LIBRARY_PATH=/Applications/MATLAB/MATLAB_Runtime/v85/runtime/maci64:/Applications/MATLAB/MATLAB_Runtime/v85/sys/os/maci64:/Applications/MATLAB/MATLAB_Runtime/v85/bin/maci64 
"$@"
