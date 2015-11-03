function [outFile, FLDmodel] = train(trainingFeatureFolder, outFile)
%TRAIN Trains the model for automatic phrase segmentation
%   The function extracts features extracted from the training scores which
%   also holds the information on manual segmentations. 
%   Inputs: 
%       trainingFeatureFolder:  the path to the folder where the features
%               (.ptxt files by default) extracted from the training scores
%               are stored
%       outfile (optional): the path to the folder where the model will be
%               stored (default: "(trainingFeatureFolder)/FLDmodel.mat")
%   Output:
%       outFile: the path to the folder where the model will be stored 
%               (default: "(trainingFeatureFolder)/FLDmodel.mat")
%       FLDmodel: the trained model
%
%   Sertan Senturk, 2 December 2012
%   Universitat Pompeu Fabra
%   email: sertan.senturk@upf.edu 

% I/O
if ~exist(trainingFeatureFolder, 'dir')
    error('train:trainingFolder', 'The training folder does not exist!')
else % make sure the path is absolute
    trainingFeatureFolder = GetFullPath(trainingFeatureFolder);
end
if ~exist('outFile', 'var') || isempty(outFile)
    outFile = fullfile(trainingFeatureFolder, 'FLDmodel.mat');
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
FLDmodel = trainMelodicSegmentation(trainingFeatureFolder);

% save
save(outFile, '-struct', 'FLDmodel');
end