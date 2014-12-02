function [segFiles, segments] = extractSegments(in,usulFile,out)
% EXTRACTSEGMENT extracts the segment boundaries given in the score
% Inputs:
%   in: .ptxt feature file associated with a SymbTr file or a folder
%       containing multiple .ptxt files
%   usulFile: the file containing usul information
%   out: the .seg file associated with a SymbTr file or a folder where
%       .seg files will be saved for multiple SymbTr scores
%% I/O
if ~exist('out', 'var')
    out = '';
end
[infiles, segFiles] = parseIO(in, out);

%% segmentation
segments = cell(numel(infiles),1);
for k = 1:numel(infiles)
    [~, segments{k}] = symbtr2nmat(infiles{k},usulFile);
    
    fid=fopen(segFiles{k},'w+t');
    for m=1:length(segments{k})%uzman bolut bilgisinin son sutuna islenmesi
        if strcmp('53',num2str(segments{k}(m).kod))
            fprintf(fid,'%4.4f\r\n',segments{k}(m).beat);
        else
            
        end
    end
    [~] = fclose(fid);
end
end


function [infiles, outfiles] = parseIO(in, out)
% parse input/output

% check whether the specified input is a file or folder
if exist(in, 'dir') % folder
    infiles = dir(fullfile(in, '*.txt'));
    infiles = cellfun(@(x) fullfile(in, x), {infiles.name}, 'unif', false);
elseif exist(in, 'file') % file
    infiles = {in};
else
    error('parseIO:input', 'Input should be a folder or a symbTr file')
end

if isempty(out) % out not defined
    % save 2 same filename w a different extension in the same folder
    outfiles = strrep(infiles,'.txt','.seg');
else % output given
    % check if the out is defined as a folder or file
    [~,~,ext] = fileparts(out);
    if isempty(ext) % folder
        [~, fnames] = cellfun(@fileparts, infiles, 'unif', false);
        outfiles = cellfun(@(x) fullfile(out, [x '.seg']), fnames, ...
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