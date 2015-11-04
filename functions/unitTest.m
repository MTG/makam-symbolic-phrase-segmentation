function unitTest()
% UNITTEST Tests the phrase segmentation algorithm
%   This function checks whether the implemented algorithms for automatic
%   phrase segmentation works. It calls "learnBoundStat, extractFeature,
%   train, segment, evaluate" sequentially on a training dataset to learn
%   the model and then calls "extractFeature" and "segment" on the test 
%   dataset to automatically segment the scores into phrases. If all the
%   steps are completed successfully, the function prints "Test passed"
%
%   Sertan Senturk, 2 December 2012
%   Universitat Pompeu Fabra
%   email: sertan.senturk@upf.edu 

%% I/O
p = fileparts(mfilename('fullpath'));
trainFolder = fullfile(p, '..', 'sampleData', 'train');
testFolder = fullfile(p, '..', 'sampleData', 'test');

tmpFolder = fullfile(p, '..', 'tmp');
trainFeatureFolder = fullfile(tmpFolder, 'trainFeature');
testFeatureFolder = fullfile(tmpFolder, 'testFeature');
trainSegmentFolder = fullfile(tmpFolder, 'trainSegment');
testSegmentFolder = fullfile(tmpFolder, 'testSegment');

boundStatFile = fullfile(tmpFolder,'boundStat.mat');
FLDmodelFile = fullfile(tmpFolder,'FLDmodel.mat');
evaluationFile = fullfile(tmpFolder,'results.mat');

%% compute melodic boundary histograms
disp('- Extracting segment boundaries from SymbTr...')
[~]=phraseSeg('getSegments', trainFolder, trainSegmentFolder);

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

%% Perform automatic segmentation using the trained model (.autoSeg and 
% .seg files can be compared.) 
disp('- Automatic segmentation on the training scores...')
[~] = phraseSeg('segment', trainFeatureFolder, FLDmodelFile,...
    trainSegmentFolder);

%% Evalution on the training set: compare the automatic and manual
% segmentations on the training set
disp('- Evaluating the automatic segmentations on the training scores...')
[~, results] = phraseSeg('evaluate', trainFeatureFolder, evaluationFile);
fprintf('  ... The average ROC curve; AUC == %.4f\n',...
    results.overall.roc.average)

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

%% rm the temporary folder
rmdir(tmpFolder, 's')
end
