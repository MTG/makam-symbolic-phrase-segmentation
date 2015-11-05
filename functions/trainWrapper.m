function trainWrapper(trainFolder, boundStatFile, trainFeatureFolder,...
    FLDmodelFile)
%PHRASESEGWRAPPER Summary of this function goes here
%   Detailed explanation goes here

%% compute melodic boundary distributions
disp('- Computing boundary stats...')
[~, boundStat] = phraseSeg('learnBoundStat', trainFolder, boundStatFile);

%% Compute features for training data set and write to ptxt files
disp('- Computing the features for the training scores...')
[~, features] = phraseSeg('extractFeature', trainFolder, boundStat, ...
    trainFeatureFolder);

%% Training
disp('- Training the model from manual segmentations in the training set...')
[~] = phraseSeg('train', features, FLDmodelFile);

%% completed
disp('- Training completed complete!')

end
