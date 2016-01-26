clear 
clc
close all

addpath(genpath(fullfile('functions')))

%% training I/O
trainJson = 'sampleData/trainFiles.json';

outFolder = fullfile('sampleData/out');
boundStatFile = fullfile(outFolder,'boundStat.mat');
FLDmodelFile = fullfile(outFolder,'FLDmodel.mat');

%% training
phraseSeg('trainWrapper', trainJson, boundStatFile, FLDmodelFile)

%% testing I/O
% testFolder = '/Volumes/SHARED/data/SymbTr/txt/';
testSegmentFolder = fullfile(outFolder, 'testSegment');

testJson = 'sampleData/testFile.json';
testSegmentFile = fullfile(testSegmentFolder, 'hicaz--sarki--aksak--dil_yaresini--sevki_bey.autoSeg');

%% segmentation
phraseSeg('segmentWrapper', boundStatFile, FLDmodelFile, testJson, ...
    testSegmentFile)
