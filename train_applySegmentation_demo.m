%train_applySegmentation {no inputs}
% Bu fonksiyon bir klasorde(trainDbaFolder) toplanmis verilerden ogrenme 
% gerceklestirir ve diger klasordeki(targetDbaFolder) verilere uygular.
%
% This function performs training of the automatic segmentation from a dba
% in a directory(trainDbaFolder) and then applies automatic segmentation on
% files in another directory (targetDbaFolder)

%--------------------------------
%% get the path of the script as a reference point to function calls, I/O..
addpath(genpath(fullfile('functions')))
p = fileparts(mfilename('fullpath'));

%% Girdiler/Input
% Kendi egitim verilerinizi ve test verilerinizi kullanmak isterseniz,
% asagidaki klasorleri duzeltin
% If you want to use your own training and test sets, change the
% directories below accordingly
trainDbaFolder = fullfile(p, 'sampleData', 'train');
testDbaFolder = fullfile(p, 'sampleData', 'test');

%% Ciktilar/Output
% eger dosyalari baska yerlere kaydetmek istiyorsaniz, asagidaki dosya
% isim degiskenlerini duzeltin
% if you want to save your outputs to different locations, change the
% file/folder variables below accordingly
outTrainFolder = fullfile(p, 'sampleData', 'train_out');
outTestFolder = fullfile(p, 'sampleData', 'test_out');

boundStatFile = fullfile(outTrainFolder,'boundStat.mat');
FLDmodelFile = fullfile(outTrainFolder,'FLDmodel.mat');
evaluationFile = fullfile(outTrainFolder,'results.mat');

%% Egitim verilerinde yazili manuel segmentasyonlari .seg uzantili 
% dosyalara kaydet
% extract the segment boundaries in the training data and save to .seg
% files
disp('- Extracting segment boundaries from SymbTr...')
manualSegFiles=phraseSeg('getSegments',trainDbaFolder,outTrainFolder);

%% Ezgi siniri dagilimlarini hesapla / compute melodic boundary histograms
disp('- Learning boundary stats...')
boundStatFile = phraseSeg('learnBoundStat', trainDbaFolder, boundStatFile);

%% Egitim verileri icin oznitelikleri hesapla ve ptxt dosyalarina yazdir
% Compute features for training data set and write to ptxt files
disp('- Computing the features for the training scores...')
trainFeatureFiles = phraseSeg('extractFeature', trainDbaFolder, ...
    boundStatFile, outTrainFolder);

%% Egitim / Perform learning/training
disp('- Training the model from manual segmentations in the training set...')
FLDmodelFile = phraseSeg('train', outTrainFolder, FLDmodelFile);

%% Egitim verilerinin ozniteliklerini iceren dosyalardan otomatik
% segmentasyon olustur. (.autoSeg ve .seg dosyalari acilip kontrol 
% edilebilir) 
% Perform automatic segmentation using the trained model (.autoSeg and 
% .manSeg files can be compared.) 
disp('- Automatic segmentation on the training scores...')
trainBoundFiles = phraseSeg('segment', outTrainFolder, FLDmodelFile, ...
    outTrainFolder); 

%% Egitim verilerinden elde edilen otomatik segmentasyonlari, manuel 
% isaretlenen segmentasyonlari karsilastir
% Evalution on the training set: compare the automatic and manual
% segmentations on the training set
disp('- Evaluating the automatic segmentations on the training scores...')
[resultsFile, results] = phraseSeg('evaluate', outTrainFolder, ...
    evaluationFile);
fprintf('  ... The average ROC curve; AUC == %.4f\n',...
    results.overall.roc.average)

%% Uygulama verileri icin oznitelikleri hesapla ve ptxt dosyalarina yazdir
%Compute features for the main data set and write to ptxt files
disp('- Computing the features for the test scores...')
test_feature_files = phraseSeg('extractFeature', testDbaFolder, ...
    boundStatFile, outTestFolder);

%% Test verilerinin ozniteliklerini iceren dosyalardan otomatik 
% segmentasyon olustur
% Perform automatic segmentation using the testing model
disp('- Automatic segmentation on the test scores...')
test_bound_files = phraseSeg('segment', outTestFolder, FLDmodelFile, ...
    outTestFolder);

%% tamamlandi
% completed
disp('- Phrase segmentation complete!')
