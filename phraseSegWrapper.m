clear 
clc
close all

addpath(genpath(fullfile('functions')))
%% training I/O
% trainFolder = '/Volumes/SHARED/data/turkish_makam_corpus_stats/data/segmentedScores/expert1';
trainJson = 'sampleData/trainFiles.json';

tmpFolder = fullfile('sampleData/tmp');
boundStatFile = fullfile(tmpFolder,'boundStat.mat');
FLDmodelFile = fullfile(tmpFolder,'FLDmodel.mat');

%% training
phraseSeg('trainWrapper', trainJson, boundStatFile, FLDmodelFile)

%% testing I/O
% testFolder = '/Volumes/SHARED/data/SymbTr/txt/';
testSegmentFolder = fullfile(tmpFolder, 'testSegment');

testJson = 'sampleData/testFile.json';
testSegmentFile = fullfile(testSegmentFolder, 'hicaz--sarki--aksak--beni_canimdan--muzaffer_ilkar.autoSeg');

%% segmentation
phraseSeg('segmentWrapper', boundStatFile, FLDmodelFile, testJson, ...
    testSegmentFile)
