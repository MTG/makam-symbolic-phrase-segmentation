function [testSegments, trainSegments, manualSegments, results,...
    testSegmentFiles, trainSegmentFiles, manualSegmentFiles,...
    testFeatureFiles, trainFeatureFiles, boundStatFile, FLDmodelFile,...
    evaluationFile] = trainSegment(trainFolder, testFolder, varargin)
%TRAINSEGMENT Train a phrase segmentation model from training scores and
%segment testing scores accordingly
% This function performs training of the automatic segmentation from a dba
% in a directory(trainDbaFolder) and then applies automatic segmentation on
% files in another directory (targetDbaFolder)
%
% Bu fonksiyon bir klasorde(trainDbaFolder) toplanmis verilerden ogrenme
% gerceklestirir ve diger klasordeki(targetDbaFolder) verilere uygular.
%
%   Inputs:
%       trainFolder: The path to the folder with the SymbTr-scores with
%                   manual segmentations. 
%       testFolder: The path to the folder with the SymbTr-score to be 
%                   be segmented
%       segSpecs (optional): The optional parameters to specify the paths
%                   to save the outputs of each subprocess. They are:
%               'trainFeatureFolder': the path of the folder to save the 
%                           training score features (default: "trainFolder")
%               'testFeatureFolder': the path of the folder to save the
%                           training score features (default: "testFolder")
%               'trainSegmentFolder': the path of the folder to save the
%                           segmentations of the training scores (both
%                           manual and automatic) (default: "trainFolder")
%               'testSegmentFolder': the path of the folder to save the
%                           segmentations of the training scores
%                           (automatic) (default: "testFolder")
%               'boundStatFile': the path of the .mat file to save the 
%                           segment boundary distributions (default: 
%                           "trainFolder")
%               'FLDmodelFile': the path of the .mat file to save the 
%                           training model (default: "trainFolder")
%               'evaluationFile': the path of the .mat file to save the 
%                           leave-one-out cross validation results 
%                           (default: "trainFolder")
%        
%  Outputs:
%       testSegments: the automatic segmentations per testing SymbTr-score
%       trainSegments: the automatic segmentations per training SymbTr-score
%       manualSegments: the phrase annotations per training SymbTr-score
%       results: leave-one-out cross validation results on the training set
%       testSegmentFiles: the paths of the .autoSeg files storing the
%                   automatic segmentations per testing SymbTr-score
%       trainSegmentFiles: the paths of the .autoSeg files storing the
%                   automatic segmentations per training SymbTr-score
%       manualSegmentFiles: the paths of the .seg files storing the phrase
%                   annotations per training SymbTr-score
%       testFeatureFiles: the paths of the .ptxt files storing the features
%                   per testing SymbTr-score
%       trainFeatureFiles: the paths of the .ptxt files storing the
%                   features per training SymbTr-score
%       boundStatFile: the path of the .mat file storing the phrase boundary
%                   distribution of the annotations in the training 
%                   SymbTr-scores
%       FLDmodelFile: the path of the .mat file storing the training model
%       evaluationFile: the path of the .mat file storing the leave-one-out
%                   cross validation results on the training set
%
%       Example
%       -------
%       %% Input/output, change these values for your own data
%       trainFolder = fullfile(p, '..', 'sampleData', 'train');
%       testFolder = fullfile(p, '..', 'sampleData', 'test');
% 
%       outFolder = fullfile(p, '..', 'tmp');
%       trainFeatureFolder = fullfile(tmp, 'trainFeature');
%       testFeatureFolder = fullfile(tmp, 'testFeature');
%       trainSegmentFolder = fullfile(tmp, 'trainSegment');
%       testSegmentFolder = fullfile(tmp, 'testSegment');
% 
%       boundStatFile = fullfile(tmp,'boundStat.mat');
%       FLDmodelFile = fullfile(tmp,'FLDmodel.mat');
%       evaluationFile = fullfile(tmp,'results.mat');
% 
%       %% call the complete process 
%       [testSegments, trainSegments, manualSegments, results,...
%           testSegmentFiles, trainSegmentFiles, manualSegmentFiles,...
%           testFeatureFiles, trainFeatureFiles, boundStatFile,...
%           FLDmodelFile, evaluationFile] = trainSegment(...
%           trainFolder, testFolder, ...
%           'trainFeatureFolder', trainFeatureFolder,...
%           'testFeatureFolder', testFeatureFolder,...
%           'trainSegmentFolder', trainSegmentFolder,...
%           'testSegmentFolder', testSegmentFolder,...
%           'boundStatFile', boundStatFile,...
%           'FLDmodelFile', FLDmodelFile,...
%           'evaluationFile', evaluationFile);

%  Sertan Senturk, 3 December 2012
%  Universitat Pompeu Fabra
%  email: sertan.senturk@upf.edu 

%% input parsing
[trainFeatureFolder, testFeatureFolder, trainSegmentFolder, ...
    testSegmentFolder, boundStatFile, FLDmodelFile, evaluationFile] = ...
    parseInputs(trainFolder, testFolder, varargin{:});

%% Egitim verilerinde yazili manuel segmentasyonlari .seg uzantili
% dosyalara kaydet
% extract the segment boundaries in the training data and save to .seg
% files
disp('- Extracting segment boundaries from SymbTr...')
[manualSegmentFiles,manualSegments]=phraseSeg('getSegments',trainFolder,...
    trainSegmentFolder);

%% Ezgi siniri dagilimlarini hesapla / compute melodic boundary histograms
disp('- Learning boundary stats...')
boundStatFile = phraseSeg('learnBoundStat',trainFolder,boundStatFile);

%% Egitim verileri icin oznitelikleri hesapla ve ptxt dosyalarina yazdir
% Compute features for training data set and write to ptxt files
disp('- Computing the features for the training scores...')
trainFeatureFiles = phraseSeg('extractFeature', trainFolder, ...
    boundStatFile, trainFeatureFolder);

%% Egitim / Perform learning/training
disp('- Training the model from manual segmentations in the training set...')
FLDmodelFile = phraseSeg('train', trainFeatureFolder, FLDmodelFile);

%% Egitim verilerinin ozniteliklerini iceren dosyalardan otomatik
% segmentasyon olustur. (.autoSeg ve .seg dosyalari acilip kontrol
% edilebilir)
% Perform automatic segmentation using the trained model (.autoSeg and
% .manSeg files can be compared.)
disp('- Automatic segmentation on the training scores...')
[trainSegmentFiles,trainSegments]=phraseSeg('segment',trainFeatureFolder,...
    FLDmodelFile,trainSegmentFolder);

%% Egitim verilerinden elde edilen otomatik segmentasyonlari, manuel
% isaretlenen segmentasyonlari karsilastir
% Evalution on the training set: compare the automatic and manual
% segmentations on the training set
disp('- Evaluating the automatic segmentations on the training scores...')
[evaluationFile, results] = phraseSeg('evaluate', trainFeatureFolder, ...
    evaluationFile);
fprintf('  ... The average ROC curve; AUC == %.4f\n',...
    results.overall.roc.average)

%% Uygulama verileri icin oznitelikleri hesapla ve ptxt dosyalarina yazdir
%Compute features for the main data set and write to ptxt files
disp('- Computing the features for the test scores...')
testFeatureFiles = phraseSeg('extractFeature', testFolder, ...
    boundStatFile, testFeatureFolder);

%% Test verilerinin ozniteliklerini iceren dosyalardan otomatik
% segmentasyon olustur
% Perform automatic segmentation using the testing model
disp('- Automatic segmentation on the test scores...')
[testSegmentFiles,testSegments]=phraseSeg('segment',testFeatureFolder,...
    FLDmodelFile,testSegmentFolder);

%% tamamlandi
% completed
disp('- Phrase segmentation complete!')

end

function [trainFeatureFolder, testFeatureFolder, trainSegmentFolder, ...
    testSegmentFolder, boundStatFile, FLDmodelFile, evaluationFile] = ...
    parseInputs(trainDbaFolder, testDbaFolder, varargin)

p = inputParser;
default_trainFeatureFolder = trainDbaFolder;
default_testFeatureFolder = testDbaFolder;
default_trainSegmentFolder = trainDbaFolder;
default_testSegmentFolder = testDbaFolder;
default_boundStatFile = trainDbaFolder;
default_FLDmodelFile = trainDbaFolder;
default_evaluationFile = trainDbaFolder;

addRequired(p,'trainDbaFolder', @isdir);
addRequired(p,'testDbaFolder', @isdir);
addParameter(p,'trainFeatureFolder',default_trainFeatureFolder,@ischar);
addParameter(p,'testFeatureFolder',default_testFeatureFolder,@ischar);
addParameter(p,'trainSegmentFolder',default_trainSegmentFolder,@ischar);
addParameter(p,'testSegmentFolder',default_testSegmentFolder,@ischar);
addParameter(p,'boundStatFile',default_boundStatFile,...
    @(x) (ischar(x) & ~isdir(x)));
addParameter(p,'FLDmodelFile',default_FLDmodelFile,...
    @(x) (ischar(x) & ~isdir(x)));
addParameter(p,'evaluationFile',default_evaluationFile,...
    @(x) (ischar(x) & ~isdir(x)));

parse(p,trainDbaFolder, testDbaFolder, varargin{:})

trainFeatureFolder =  p.Results.trainFeatureFolder;
testFeatureFolder = p.Results.testFeatureFolder;
trainSegmentFolder = p.Results.trainSegmentFolder;
testSegmentFolder = p.Results.testSegmentFolder;
boundStatFile = p.Results.boundStatFile;
FLDmodelFile = p.Results.FLDmodelFile;
evaluationFile = p.Results.evaluationFile;
end