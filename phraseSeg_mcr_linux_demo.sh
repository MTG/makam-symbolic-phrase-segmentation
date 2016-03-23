# run_mcr_linux.sh is a wrapper setting the path for the linux environment
# IMPORTANT: If you are in a mac machine replace run_mcr_linux.sh with run_mcr_mac.sh !
./run_mcr_linux.sh ./phraseSeg trainWrapper ./sampleData/trainFiles.json ./sampleData/boundStat.mat ./sampleData/FLDmodelFile
./run_mcr_linux.sh ./phraseSeg segmentWrapper ./sampleData/boundStat.mat ./sampleData/FLDmodelFile.mat ./sampleData/testFile.json ./sampleData/tmp/seg.json
