function wrapper(trainFolder, boundStatFile, trainFeatureFolder,...
    FLDmodelFile, testFolder, testFeatureFolder, testSegmentFolder)
%PHRASESEGWRAPPER Summary of this function goes here
%   Detailed explanation goes here

%% compute melodic boundary distributions
disp('- Computing boundary stats...')
[~] = phraseSeg('learnBoundStat', trainFolder, boundStatFile);

%% Compute features for training data set and write to ptxt files
disp('- Computing the features for the training scores...')
[~] = phraseSeg('extractFeature', trainFolder, boundStatFile, ...
    trainFeatureFolder);

%% Training
disp('- Training the model from manual segmentations in the training set...')
[~] = phraseSeg('train', trainFeatureFolder, FLDmodelFile);

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
