#!/bin/bash
echo Running "$@"
export LD_LIBRARY_PATH=/usr/local/MATLAB/MATLAB_Runtime/v85/runtime/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v85/sys/os/glnxa64:/usr/local/MATLAB/MATLAB_Runtime/v85/bin/glnxa64
"$@"
