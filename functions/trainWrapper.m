function trainWrapper(trainIn, boundStatFile, FLDmodelFile, trainFeatureIn)
%PHRASESEGWRAPPER Summary of this function goes here
%   Detailed explanation goes here

%% compute melodic boundary distributions
disp('- Computing boundary stats...')
[~, boundStat] = phraseSeg('learnBoundStat', trainIn, boundStatFile);

%% Compute features for training data set and write to ptxt files
disp('- Computing the features for the training scores...')
if exist('testFeatureIn', 'var')
    [~, features] = phraseSeg('extractFeature', trainIn, boundStat, ...
        trainFeatureIn);
else
    [~, features] = phraseSeg('extractFeature', trainIn, boundStat);
end
%% Training
disp('- Training the model from manual segmentations in the training set...')
[~] = phraseSeg('train', features, FLDmodelFile);

%% completed
disp('- Training complete!')

end
