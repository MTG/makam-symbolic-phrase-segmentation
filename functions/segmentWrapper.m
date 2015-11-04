function segmentWrapper(boundStatFile, FLDmodelFile, testFolder, ...
    testFeatureFolder, testSegmentFolder)
%PHRASESEGWRAPPER Summary of this function goes here
%   Detailed explanation goes here

%% Compute features for the main data set and write to ptxt files
disp('- Computing the features for the test scores...')
[~] = phraseSeg('extractFeature', testFolder, boundStatFile, ...
    testFeatureFolder);

%% Perform automatic segmentation using the testing model
disp('- Automatic segmentation on the test scores...')
[~] = phraseSeg('segment', testFeatureFolder, FLDmodelFile, ...
    testSegmentFolder);

%% completed
disp('- Phrase segmentation complete!')

end