clear 
clc
close all

addpath(genpath(fullfile('functions')))
%% I/O
% trainFolder = '/Volumes/SHARED/data/turkish_makam_corpus_stats/data/segmentedScores/expert1';
% testFolder = '/Volumes/SHARED/data/SymbTr/txt/';

trainFolder = 'sampleData/train/';

tmpFolder = fullfile('sampleData/tmp');
trainFeatureFolder = fullfile(tmpFolder, 'trainFeature');

boundStatFile = fullfile(tmpFolder,'boundStat.mat');
FLDmodelFile = fullfile(tmpFolder,'FLDmodel.mat');

testFolder = 'sampleData/test/';
testFeatureFolder = fullfile(tmpFolder, 'testFeature');
testSegmentFolder = fullfile(tmpFolder, 'testSegment');

testFile = fullfile(testFolder, 'hicaz--sarki--aksak--beni_canimdan--muzaffer_ilkar.txt');
testFeatureFile = fullfile(testFeatureFolder, 'hicaz--sarki--aksak--beni_canimdan--muzaffer_ilkar.ptxt');
testSegmentFile = fullfile(testSegmentFolder, 'hicaz--sarki--aksak--beni_canimdan--muzaffer_ilkar.autoSeg');

%% training
phraseSeg('trainWrapper', trainFolder, boundStatFile, FLDmodelFile)

%% segmentation
phraseSeg('segmentWrapper', boundStatFile, FLDmodelFile, testFile, ...
    testSegmentFile)