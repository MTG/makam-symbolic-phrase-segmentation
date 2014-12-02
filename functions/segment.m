function [bound_files, bound] = segment(in, FLDmodel, out)
% SEGMENT segments the score according to the training model. 
%   The function reads the feature files (files with .ptxt by defauls) 
%   extracted from the score and automatically returns the estimated 
%   segment boundaries for each SymbTr-score according to the model trained
%   on the manual segmentations in the training scores. By default the 
%   output is written to a file in the same directory with the same name 
%   of the SymbTr-score and an extension of ".autoSeg". The user can 
%   overwrite the file path if the input is a single file or the folder 
%   path if the input is a folder.
%   Inputs:
%       in: .ptxt feature file associated with a SymbTr file or a folder
%           containing multiple .ptxt files
%       FLDmodel: the segmentation model (or the file which the model is
%           saved)
%       out (optional): the .autoSeg file associated with a SymbTr file or 
%           a folder where .autoSeg files will be saved for multiple SymbTr
%           scores
%   Outputs:
%       bound_files: the paths of the files where the automatic
%           segmentation boundaries are stored
%       bound: the segmentation boundaries
%
%   Sertan Senturk, 2 December 2012
%   Universitat Pompeu Fabra
%   email: sertan.senturk@upf.edu 
%% I/O
if exist(FLDmodel, 'file')
    FLDmodel = load(FLDmodel);
end
if ~exist('out', 'var')
    out = '';
end
[infiles, bound_files] = parseIO(in, out);

%% segmentation
bound = cell(numel(infiles),1);
for k = 1:numel(infiles)
    bound{k} = segmentFile(infiles{k}, FLDmodel);
    dlmwrite(bound_files{k},bound{k},'delimiter','\t','precision',...
        '%.4f');
end
end

function boundary = segmentFile(file, FLDmodel)
%SEGMENT Summary of this function goes here
%   Detailed explanation goes here
iniDir = pwd;

% Perform automatic segmentation using the trained model
boundary = autoMelodicSegmentation(file, FLDmodel);

cd(iniDir)
end

function [infiles, outfiles] = parseIO(in, out)
% parse input/output

% check whether the specified input is a file or folder
if exist(in, 'dir') % folder
    infiles = dir(fullfile(in, '*.ptxt'));
    infiles = cellfun(@(x) fullfile(in, x), {infiles.name}, 'unif', false);
elseif exist(in, 'file') % file
    infiles = {in};
else
    error('parseIO:input', 'Input should be a folder or a symbTr file')
end

if isempty(out) % out not defined
    % save 2 same filename w a different extension in the same folder
    outfiles = strrep(infiles,'.ptxt','.autoSeg');
else % output given
    % check if the out is defined as a folder or file
    [~,~,ext] = fileparts(out);
    if isempty(ext) % folder
        [~, fnames] = cellfun(@fileparts, infiles, 'unif', false);
        outfiles = cellfun(@(x) fullfile(out, [x '.autoSeg']), fnames, ...
            'unif', 0);
    else % file
        if exist(in, 'dir')
            error('parseIO:outType', ['If the input is specified as a '...
                'folder the output should be a folder as well.'])
        end
        outfiles = out;
    end
    if ~exist(fileparts(outfiles{1}), 'dir') % make sure the folder exist
        status = mkdir(fileparts(outfiles{1}));
        if ~status
            error('learnBoundStat:outFile', ['The folder to save the stats '...
                'cannot be created. Check the write permisions.'])
        end
    end
end
if ischar(outfiles) % single file
    outfiles = {outfiles};
end
end