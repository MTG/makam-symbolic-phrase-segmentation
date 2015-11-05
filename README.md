makam-symbolic-phrase-segmentation
==================================

Automatic Phrase Segmentation on symbolic scores for Ottoman-Turkish makam music

-----------------------------------------------------------------
This is a fork of the automatic phrase segmentation algorithm hosted in http://akademik.bahcesehir.edu.tr/~bbozkurt/112E162.html. This repository is created with the consent of the members of the project. The aim of this fork is to modularize and package the MATLAB code into a standalone binary usable in other research tools (and mainly in [Dunya](https://github.com/MTG/dunya)). You can access the original code and additional sources such as the expert annotations from the original site.

Please cite the following paper, if you are using the code or the data available in the web page expalined above.

B. Bozkurt, M. K. Karaosmanoglu, B. Karacali, E. Unal, Usul and Makam driven automatic melodic segmentation for Turkish music, submitted to Journal of New Music Research, 2013.

Usage 
------------------------------------------------------------------
You can use the tool either from the MATLAB itself, or by calling the MATLAB binaries provided. Refer to the phraseSeg_matlab_demo.m and phraseSeg_mcr_demo.sh, respectively, for how to call the code.

If you want to work on/observe how each individual step is called refer to individual_functions_demo.m.

Installation
------------------------------------------------------------------
If you want to use the binary, you need to install [MATLAB Runtime](http://www.mathworks.com/products/compiler/mcr/?refresh=true). Make you download and install the version R2015a. The binary will not work with other runtime versions!

If you are cloning the git repository, don't forget to [initialize and update the submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules). 

Additional Material
------------------------------------------------------------------
This tool uses [MIDI Toolbox](https://www.jyu.fi/hum/laitokset/musiikki/en/research/coe/materials/miditoolbox) internally for computing the features using LBDM and Tenney-Polansky algoritms. 

For json reading/writing, the code uses Sertan Senturk's [jsonlab](https://github.com/sertansenturk/jsonlab) fork. 

Contributors
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
