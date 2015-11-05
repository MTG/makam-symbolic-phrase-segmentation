clear 
clc
close all

addpath(genpath(fullfile('functions')))
%% I/O
% trainFolder = '/Volumes/SHARED/data/turkish_makam_corpus_stats/data/segmentedScores/expert1';
% testFolder = '/Volumes/SHARED/data/SymbTr/txt/';

trainFolder = 'sampleData/train/';
testFolder = 'sampleData/test/';

tmpFolder = fullfile('sampleData/tmp');
trainFeatureFolder = fullfile(tmpFolder, 'trainFeature');
testFeatureFolder = fullfile(tmpFolder, 'testFeature');
testSegmentFolder = fullfile(tmpFolder, 'testSegment');

boundStatFile = fullfile(tmpFolder,'boundStat.mat');
FLDmodelFile = fullfile(tmpFolder,'FLDmodel.mat');

testFile = 'sampleData/test/hicaz--sarki--aksak--beni_canimdan--muzaffer_ilkar.txt';
testFeatureFile = 'sampleData/tmp/testFeature/hicaz--sarki--aksak--beni_canimdan--muzaffer_ilkar.ptxt';
testSegmentFile = 'sampleData/tmp/testSegment/hicaz--sarki--aksak--beni_canimdan--muzaffer_ilkar.autoSeg';

%% training
phraseSeg('trainWrapper', trainFolder, boundStatFile, ...
    trainFeatureFolder, FLDmodelFile)

%% segmentation
phraseSeg('segmentWrapper', boundStatFile, FLDmodelFile, testFile, ...
    testFeatureFile, testSegmentFile)