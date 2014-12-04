function test()
% TEST Tests the phrase segmentation algorithm
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

%% call the complete process 
[~] = phraseSeg('trainSegment', trainFolder, testFolder, ...
    'trainFeatureFolder', trainFeatureFolder,...
    'testFeatureFolder', testFeatureFolder,...
    'trainSegmentFolder', trainSegmentFolder,...
    'testSegmentFolder', testSegmentFolder,...
    'boundStatFile', boundStatFile,...
    'FLDmodelFile', FLDmodelFile,...
    'evaluationFile', evaluationFile);

%% rm the temporary folder
rmdir(tmpFolder, 's')
end