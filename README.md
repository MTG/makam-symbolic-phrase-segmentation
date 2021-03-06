[![DOI](https://zenodo.org/badge/27432980.svg)](https://zenodo.org/badge/latestdoi/27432980) [![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-ff69b4.svg)](http://www.gnu.org/licenses/agpl-3.0)

makam-symbolic-phrase-segmentation
==================================

Automatic Phrase Segmentation on symbolic scores for Ottoman-Turkish makam music

Introduction
-----------------------------------------------------------------
This is a fork of the makam and usul driven automatic phrase segmentation algorithm hosted in http://akademik.bahcesehir.edu.tr/~bbozkurt/112E162.html. 

This repository is created with the consent of the members of the project. The aim of this fork is to modularize and package the MATLAB code into a standalone binary usable in other research tools (such as [Dunya](https://github.com/MTG/dunya)). The code is also optimized such that it performs considerably faster than the original code. 

You can access the original code and additional sources such as the expert annotations from the original site. Please cite the paper below, if you are using the code or the data  in your work.

> Barış Bozkurt, M. Kemal Karaosmanoğlu, Bilge Karaçalı, Erdem Ünal. Usul and Makam driven automatic melodic segmentation for Turkish music. Journal of New Music Research. Vol. 43, Iss. 4, 2014

Known Issues
------------------------------------------------------------------
The current release outputs somewhat different results compared to Barış Bozkurt's original code (i.e. several boundary insertions and deletions). We will release the first stable release, as soon as this [issue](https://github.com/MTG/makam-symbolic-phrase-segmentation/issues/8) is fixed.

Binaries 
------------------------------------------------------------------
The compiled binaries for Linux and MacOSX are hosted inside the [releases](https://github.com/MTG/makam-symbolic-phrase-segmentation/releases). The binary for Linux is named "phraseSeg" and the binary for MacOSX is named "phraseSeg.app" zipped under "phraseSeg_mac.zip".

Installation
------------------------------------------------------------------
If you want to use the binary, you need to install [MATLAB Runtime](http://www.mathworks.com/products/compiler/mcr/?refresh=true). Make you download and install the version R2015a (Links for [Linux](http://www.mathworks.com/supportfiles/downloads/R2015a/deployment_files/R2015a/installers/glnxa64/MCR_R2015a_glnxa64_installer.zip) and [Mac OSX](http://www.mathworks.com/supportfiles/downloads/R2015a/deployment_files/R2015a/installers/maci64/MCR_R2015a_maci64_installer.zip)). The binary will not work with other runtime versions!

If you are cloning the git repository, don't forget to [initialize and update the submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules). If you have downloaded the source code, don't forget to download the submodules too!

You can also install the binaries using the installation package given in the releases. Simply run the install included in the package and follow the instructions.

Usage 
------------------------------------------------------------------
**Note:** If you want to get the automatic phrase boundaries using a pre-trained model, we recommend you to use the automatic phrase segmentation in [tomato](https://github.com/sertansenturk/tomato) for it's simpler usage. If not, please proceed below...

You can use the tool either from the MATLAB itself, or by calling the MATLAB binaries provided. Refer to the [phraseSeg_matlab_demo.m](https://github.com/MTG/makam-symbolic-phrase-segmentation/blob/master/phraseSeg_matlab_demo.m) for calling the code from MATLAB. For the binaries there are two demos: [phraseSeg_mcr_linux_demo.sh](https://github.com/MTG/makam-symbolic-phrase-segmentation/blob/master/phraseSeg_mcr_linux_demo.sh) for linux and [phraseSeg_mcr_mac_demo.sh](https://github.com/MTG/makam-symbolic-phrase-segmentation/blob/master/phraseSeg_mcr_mac_demo.sh) for Mac OS X.

For the **mcr_demo.sh**, make sure that the path of the binary downloaded from the release is correctly entered, you have execution permission and the enviroment paths for the MCR are exported correctly:

- The default paths of the binaries in the mcr demos point to the repository's base folder. If you have downloaded the binaries from the release to another location, you have to modify the paths of the binaries manually. Note that you simply have to call the binary as "phraseSeg" in Linux. On the other hand, the executable is in "phraseSeg.app/Contents/MacOS/phraseSeg" in Mac OS X.
- The environment path to set are given in the end of the MCR installation. You can assign the path in [run_mcr.sh](https://github.com/MTG/makam-symbolic-phrase-segmentation/blob/master/run_mcr.sh) and call to binary from via this wrapper script for convenience. The path to set in Linux and in MacOSX is "LD_LIBRARY_PATH" and "DYLD_LIBRARY_PATH", respectively.
- You have to call "chmod +x /path/to/phraseSeg" to make the binary executable.

If you want to work on/observe how each individual step is called refer to [individual_functions_demo.m](https://github.com/MTG/makam-symbolic-phrase-segmentation/blob/master/individual_functions_demo.m).

Training Scores
------------------------------------------------------------------
The training scores can be downloaded from the [makam-symbolic-phrase-segmentation-dataset](https://github.com/MTG/makam-symbolic-phrase-segmentation-dataset/releases/tag/v1.0) repository. The latest release has some minor changes from the original training score dataset such as UTF-8 encoding and duplicate file removal.

The original training scores can be also downloaded from [Barış Bozkurt's project site](http://akademik.bahcesehir.edu.tr/~bbozkurt/112E162.html).

Additional Code
------------------------------------------------------------------
This tool uses [MIDI Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/miditoolbox) internally for computing the features using LBDM and Tenney-Polansky algoritms. 

For json reading/writing, the code uses Sertan Şentürk's [jsonlab](https://github.com/sertansenturk/jsonlab) fork. 

AUTHORS
------------------------------------------------------------------
Maintainer:
- Sertan Şentürk (contact AT sertansenturk DOT com)

Original code:
- Barış Bozkurt
- Kemal Karaosmanoğlu
- Bilge Karaçalı
- Erdem Ünal

Acknowledgements
------------------------------------------------------------------
The original work is supported by the Scientific and Technological Research Council of Turkey, TÜBİTAK, Grant [112E162]. This fork was created within the work partly supported by the European Research Council under the European Union’s Seventh Framework Program, as part of the CompMusic project (ERC grant agreement 267583).
