function [feature_files, feature] = extractFeature(in, boundStat, ...
    usulFile, out)
%EXTRACTFEATURE Extracts the features from the scores
%   The function extracts the features from the SymbTr-txt scores for
%   phrase segmentation. It can accept a single SymbTr-score or a folder
%   with multiple scores. By default the output is written to a file in the
%   same directory with the same name of the SymbTr-score and an extension
%   of ".ptxt". The user can overwrite the file path if the input is a
%   single file or the folder path if the input is a folder.
%   Inputs:
%       in: The path of a single SymbTr-txt score or a directory
%           containing multiple SymbTr-scores
%       boundStat: The phrase boundary distributions on the training
%           dataset computed by learnBoundStat. It can be given as a struct
%           or a .mat file where the boundary distribution was saved.
%       usulFile: The usul dictionary file storing the relevant information
%           about the common usuls. On is saved in ./files/usuller.txt
%       out (optional): The path for the saved feature file (if "in" is a
%           single file) or the path of the directory to save the saved
%           feature files (if "in" is a directory)
%   Outputs:
%       feature_files: The paths for the saved feature files
%       feature: the extracted features
%
%   Sertan Senturk, 2 December 2012
%   Universitat Pompeu Fabra
%   email: sertan.senturk@upf.edu
%% I/O
if ~exist('out', 'var')
    out = '';
end

[infiles, feature_files] = parseIO(in, out);

%%
feature = cell(numel(infiles),1);
for k = 1:numel(infiles)
    feature{k} = extractFeatureFile(infiles{k}, boundStat, usulFile);
    dlmwrite(feature_files{k},feature{k},'delimiter','\t','precision',...
        '%.4f');
end
end

function feature = extractFeatureFile(symbTrFile, boundStat, usulFile)
% some functions "cd" to the target folder, convert the file names to
% absolute to avoid path problems

% load boundary stats
if isstruct(boundStat)
    % pass
elseif exist(boundStat, 'file')
    boundStat = load(boundStat);
end
makamHist = boundStat.makamHist;
usulHist = boundStat.usulHist;
midiNo = boundStat.midiNo;

% get the makam and usul from the SymbTr filename
[~, fileName] = fileparts(symbTrFile);
s = regexp(fileName, '--', 'split');
makam=s(1);usul=s(3);

% find the makam and usul indices
makamBool = strcmp({makamHist.name}, makam);
usulBool = strcmp({usulHist.name}, usul);

% compute...
if (any(makamBool) && any(usulBool))
    feature = boundaryFeatures(symbTrFile, makamHist(makamBool), ...
        usulHist(usulBool), usulFile, midiNo);
else
    feature = [];
    warning('extractFeature:missingUsulMakam', [symbTrFile ': makam '...
        'and/or usul could not be found, segmentation is not performed']);
end
end

function [infiles, outfiles] = parseIO(in, out)
% parse input/output

% check whether the specified input is a file or folder
if exist(in, 'dir') % folder
    infiles = dir(fullfile(in, '*.txt'));
    infiles(cellfun(@(x) x(1)=='.', {infiles.name})) = []; % remove hidden files
    infiles = cellfun(@(x) fullfile(in, x), {infiles.name}, 'unif', false);
elseif exist(in, 'file') % file
    infiles = {in};
else
    error('parseIO:input', 'Input should be a folder or a symbTr file')
end

if isempty(out) % out not defined
    % save 2 same filename w a different extension in the same folder
    outfiles = strrep(infiles,'.txt','.ptxt');
else % output given
    % check if the out is defined as a folder or file
    [~,~,ext] = fileparts(out);
    if isempty(ext) % folder
        [~, fnames] = cellfun(@fileparts, infiles, 'unif', false);
        outfiles = cellfun(@(x) fullfile(out, [x '.ptxt']), fnames, ...
            'unif', 0);
    else % file
        if exist(in, 'dir')
            error('parseIO:outType', ['If the input is specified as a '...
                'folder the output should be a folder as well.'])
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