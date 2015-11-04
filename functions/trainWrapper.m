function trainWrapper(trainFolder, boundStatFile, trainFeatureFolder,...
    FLDmodelFile)
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

%% completed
disp('- Training completed complete!')

end
