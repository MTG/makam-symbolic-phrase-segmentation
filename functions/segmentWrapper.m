function segmentWrapper(boundStatFile, FLDmodelFile, testIn, ...
    testFeatureIn, testSegmentIn)
%PHRASESEGWRAPPER Summary of this function goes here
%   Detailed explanation goes here

%% Compute features for the main data set and write to ptxt files
disp('- Computing the features for the test scores...')
[~, features] = phraseSeg('extractFeature', testIn, boundStatFile, ...
    testFeatureIn);

%% Perform automatic segmentation using the testing model
disp('- Automatic segmentation on the test scores...')
[~] = phraseSeg('segment', features, FLDmodelFile, ...
    testSegmentIn);

%% completed
disp('- Phrase segmentation complete!')

end