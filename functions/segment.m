function [bound_files, bound, boundary_noteIdx]=segment(in, FLDmodel, out)
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
[indata, bound_files] = parseIO(in, out);

%% segmentation
bound = cell(numel(indata),1);
boundary_noteIdx = cell(numel(indata),1);
for k = 1:numel(indata)
    [bound{k}, boundary_noteIdx{k}] = autoMelodicSegmentation(indata{k},...
        FLDmodel);
    
    [~] = external.jsonlab.savejson('',struct('boundary_beat', ...
        bound{k}(:)', 'boundary_noteIdx', boundary_noteIdx{k}(:)'), ...
        bound_files{k});
end
end

function [indata, outfiles] = parseIO(in, out)
% parse input/output

% check whether the specified input is a file or folder
if iscell(in)
    indata = in;
elseif exist(in, 'dir') % folder
    indata = dir(fullfile(in, '*.ptxt'));
    indata = cellfun(@(x) fullfile(in, x), {indata.name}, 'unif', false);
elseif exist(in, 'file') % file
    indata = {in};
else
    error('parseIO:input', 'Input should be a folder or a symbTr file')
end

if isempty(out) % out not defined
    % save 2 same filename w a different extension in the same folder
    outfiles = strrep(indata,'.ptxt','.autoSeg');
else % output given
    % check if the out is defined as a folder or file
    [~,~,ext] = fileparts(out);
    if isempty(ext) % folder
        [~, fnames] = cellfun(@fileparts, indata, 'unif', false);
        outfiles = cellfun(@(x) fullfile(out, [x '.autoSeg']), fnames, ...
            'unif', 0);
    else % file
        if iscell(in)
            if numel(in) ~= 1
                error('parseIO:outType', ['If multiple inputs are given'...
                    ', the output should be a folder.'])
            end
        elseif exist(in, 'dir')
            error('parseIO:outType', ['If tho input is specified as a'
                ' folder the output should be be a folder as well.'])
        end
        outfiles = out;
    end
    
    if ischar(outfiles) % single file
        outfiles = {outfiles};
    end
    
    if ~exist(fileparts(outfiles{1}), 'dir') % make sure the folder exist
        status = mkdir(fileparts(outfiles{1}));
        if ~status
            error('learnBoundStat:outFile', ['The folder to save the stats '...
                'cannot be created. Check the write permisions.'])
        end
    end
end
end