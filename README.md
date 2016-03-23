makam-symbolic-phrase-segmentation
==================================

Automatic Phrase Segmentation on symbolic scores for Ottoman-Turkish makam music

Introduction
-----------------------------------------------------------------
This repository provides the implementation of makam and usul driven automatic phrase
segmentation method proposed in:

> Barış Bozkurt, M. Kemal Karaosmanoğlu, Bilge Karaçalı, Erdem Ünal. Usul and Makam driven automatic melodic segmentation for Turkish music. Journal of New Music Research. Vol. 43, Iss. 4, 2014

Please cite the paper, if you are using the code or the data available in the web page explained below.

This is a fork of the automatic phrase segmentation algorithm hosted in http://akademik.bahcesehir.edu.tr/~bbozkurt/112E162.html. You can access the original code and additional sources such as the expert annotations from the original site.

This repository is created with the consent of the members of the project. The aim of this fork is to modularize and package the MATLAB code into a standalone binary usable in other research tools (such as [Dunya](https://github.com/MTG/dunya)). The code is also optimized such that it performs considerably faster than the original code. 

Binaries 
------------------------------------------------------------------
The compiled binaries for Linux and MacOSX are hosted inside the [releases](https://github.com/MTG/makam-symbolic-phrase-segmentation/releases). The binary for Linux is named "phraseSeg" and the binary for MacOSX is named "phraseSeg.app" zipped under "phraseSeg_mac.zip".

Usage 
------------------------------------------------------------------
You can use the tool either from the MATLAB itself, or by calling the MATLAB binaries provided. Refer to the [phraseSeg_matlab_demo.m](https://github.com/MTG/makam-symbolic-phrase-segmentation/blob/master/phraseSeg_matlab_demo.m) and [phraseSeg_mcr_demo.sh](https://github.com/MTG/makam-symbolic-phrase-segmentation/blob/master/phraseSeg_mcr_demo.sh), respectively, for how to call the code. 

For the **phraseSeg_mcr_demo.sh**, make sure that the path of the binary downloaded from the release is correctly entered.

If you want to work on/observe how each individual step is called refer to [individual_functions_demo.m](https://github.com/MTG/makam-symbolic-phrase-segmentation/blob/master/individual_functions_demo.m).

Installation
------------------------------------------------------------------
If you want to use the binary, you need to install [MATLAB Runtime](http://www.mathworks.com/products/compiler/mcr/?refresh=true). Make you download and install the version R2015a. The binary will not work with other runtime versions!

If you are cloning the git repository, don't forget to [initialize and update the submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules). 

Training Scores
------------------------------------------------------------------
The training scores can be downloaded from the [makam-symbolic-phrase-segmentation-dataset](https://github.com/MTG/makam-symbolic-phrase-segmentation-dataset/releases/tag/v1.0) repository. The latest release has some minor changes from the original training score dataset such as UTF-8 encoding and duplicate file removal.

The original training scores can be also downloaded from [Barış Bozkurt's project site](http://akademik.bahcesehir.edu.tr/~bbozkurt/112E162.html).

Additional Code
------------------------------------------------------------------
This tool uses [MIDI Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/miditoolbox) internally for computing the features using LBDM and Tenney-Polansky algoritms. 

For json reading/writing, the code uses Sertan Şentürk's [jsonlab](https://github.com/sertansenturk/jsonlab) fork. 

Known Issues
------------------------------------------------------------------
The current release outputs slightly different results compared to Barış Bozkurt's original code (i.e. minor boundary insertions and deletions). We will release the first stable release, as soon as this [issue](https://github.com/MTG/makam-symbolic-phrase-segmentation/issues/8) is fixed.

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
The original work is supported by the Scientific and Technological Research Council of Turkey, TÜBITAK, Grant [112E162]. This fork was created within the work partly supported by the European Research Council under the European Union’s Seventh Framework Program, as part of the CompMusic project (ERC grant agreement 267583).
