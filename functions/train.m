function [outFile, FLDmodel] = train(trainingFolder, outFile)
%TRAIN Trains the model for automatic phrase segmentation from the
%extracted score features according to the manual segmentations
%   Detailed explanation goes here

% I/O
iniDir = pwd;
if ~exist(trainingFolder, 'dir')
    error('train:trainingFolder', 'The training folder does not exist!')
else % make sure the path is absolute
    trainingFolder = GetFullPath(trainingFolder);
end
if ~exist('outFile', 'var') || isempty(outFile)
    outFile = fullfile(trainingFolder, 'FLDmodel.mat');
else
    if ~exist(fileparts(outFile), 'dir') % make sure the folder exist
        status = mkdir(fileparts(outFile));
        if ~status
            error('learnBoundStat:outFile', ['The folder to save the stats '...
                'cannot be created. Check the write permisions.'])
        end
    end
end

% Perform learning/training
FLDmodel = trainMelodicSegmentation(trainingFolder);
cd(iniDir)

% save
save(outFile, '-struct', 'FLDmodel');
end