function test()
% %% Tests the phrase segmentation algorithm
% This function checks whether the implemented algorithms for automatic
% phrase segmentation works. It calls "learnBoundStat, extractFeature,
% train, segment, evaluate" sequentially on a training dataset to learn the
% model and then calls "extractFeature" and "segment" on the test dataset
% to automatically segment the scores into phrases. If all the steps
% are completed successfully, the function prints "Test passed"
clc
disp('------------ Testing the Phrase Segmentation Implementation ------------')

%% I/O
p = fileparts(mfilename('fullpath'));
trainFolder = fullfile(p, '..', 'sampleData', 'train');
testFolder = fullfile(p, '..', 'sampleData', 'test');

tmpFolder = fullfile(p, '..', 'tmp');
tmpTrainFolder = fullfile(tmpFolder, 'train');
tmpTestFolder = fullfile(tmpFolder, 'test');

boundStatFile = fullfile(tmpFolder,'boundStat.mat');
FLDmodelFile = fullfile(tmpFolder,'FLDmodel.mat');
evaluationFile = fullfile(tmpFolder,'results.mat');

%% extract the segment boundaries
disp('- Extracting segment boundaries from SymbTr...')
disp('  (Note: this step is not in part of automatic phrase segmentation')
disp('   but useful to compare against the automatic segmentations saved as')
disp('   ".autoSeg".)')
manualSegFiles = phraseSeg('extractSegments', trainFolder, tmpTrainFolder);

%% get the boundary statistics
disp('- Learning boundary stats...')
boundStatFile = phraseSeg('learnBoundStat', trainFolder, boundStatFile);

%% get the features for the symbTr files in the training set
disp('- Computing the features for the training scores...')
trainFeatureFiles = phraseSeg('extractFeature', trainFolder, ...
    boundStatFile, tmpTrainFolder);

%% train the model
disp('- Training the model from manual segmentations in the training set...')
FLDmodelFile = phraseSeg('train', tmpTrainFolder, FLDmodelFile);

%% apply segmentation to the training set
disp('- Automatic segmentation on the training scores...')
trainBoundFiles = phraseSeg('segment', tmpTrainFolder, FLDmodelFile, ...
    tmpTrainFolder);

%% evalute on the training set
disp('- Evaluating the automatic segmentations on the training scores...')
[resultsFile, results] = phraseSeg('evaluate', tmpTrainFolder, ...
    evaluationFile);
fprintf('  ... The average ROC curve; AUC == %.4f\n',...
    results.overall.roc.average)

%% get the features for the symbTr files in the test set
disp('- Computing the features for the test scores...')
test_feature_files = phraseSeg('extractFeature', testFolder, ...
    boundStatFile, tmpTestFolder);

%% segment
disp('- Automatic segmentation on the test scores...')
test_bound_files = phraseSeg('segment', tmpTestFolder, FLDmodelFile, ...
    tmpTestFolder);

%% completed
disp('- Test passed!')
rmdir(tmpFolder, 's')