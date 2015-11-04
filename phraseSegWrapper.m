clear 
clc
close all

addpath(genpath(fullfile('functions')))
%% I/O
trainFolder = fullfile('sampleData', 'train');
testFolder = fullfile('sampleData', 'test');

tmpFolder = fullfile('tmp');
trainFeatureFolder = fullfile(tmpFolder, 'trainFeature');
testFeatureFolder = fullfile(tmpFolder, 'testFeature');
testSegmentFolder = fullfile(tmpFolder, 'testSegment');

boundStatFile = fullfile(tmpFolder,'boundStat.mat');
FLDmodelFile = fullfile(tmpFolder,'FLDmodel.mat');

%% run function
phraseSeg('wrapper', trainFolder, boundStatFile, trainFeatureFolder,...
    FLDmodelFile, testFolder, testFeatureFolder, testSegmentFolder)