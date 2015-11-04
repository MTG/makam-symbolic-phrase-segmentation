clear 
clc
close all

addpath(genpath(fullfile('functions')))
%% I/O
trainFolder = '/Volumes/SHARED/data/turkish_makam_corpus_stats/data/segmentedScores/expert1';
testFolder = '/Volumes/SHARED/data/SymbTr/txt/';

tmpFolder = fullfile('tmp');
trainFeatureFolder = fullfile(tmpFolder, 'trainFeature');
testFeatureFolder = fullfile(tmpFolder, 'testFeature');
testSegmentFolder = fullfile(tmpFolder, 'testSegment');

boundStatFile = fullfile(tmpFolder,'boundStat.mat');
FLDmodelFile = fullfile(tmpFolder,'FLDmodel.mat');

%% run function
phraseSeg('trainWrapper', trainFolder, boundStatFile, trainFeatureFolder,...
    FLDmodelFile)
