# run_mcr_mac.sh is a wrapper setting the path for the mac environment
./run_mcr_mac.sh ./phraseSeg.app/Contents/MacOS/phraseSeg trainWrapper ./sampleData/trainFiles.json ./sampleData/boundStat.mat ./sampleData/FLDmodelFile
./run_mcr_mac.sh ./phraseSeg.app/Contents/MacOS/phraseSeg segmentWrapper ./sampleData/boundStat.mat ./sampleData/FLDmodelFile.mat ./sampleData/testFile.json ./sampleData/tmp/seg.json
