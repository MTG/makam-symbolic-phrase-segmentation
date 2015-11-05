function segmentWrapper(boundStatFile, FLDmodelFile, testIn, ...
    testSegmentIn, testFeatureIn)
%PHRASESEGWRAPPER Summary of this function goes here
%   Detailed explanation goes here

%% Compute features for the main data set and write to ptxt files
disp('- Computing the features for the test scores...')
if exist('testFeatureIn', 'var')
    [~, features] = phraseSeg('extractFeature', testIn, boundStatFile, ...
        testFeatureIn);
else
    [~, features] = phraseSeg('extractFeature', testIn, boundStatFile);
end
%% Perform automatic segmentation using the testing model
disp('- Automatic segmentation on the test scores...')
[~] = phraseSeg('segment', features, FLDmodelFile, ...
    testSegmentIn);

%% completed
disp('- Phrase segmentation complete!')

end
