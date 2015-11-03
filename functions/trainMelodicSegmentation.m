function [FLDmodel]=trainMelodicSegmentation(DDIR)
% this codes performs a sample run for the developed melodic segmentation
% algorithm that identifies the notes on phrase boundaries ..

% loading the piece data:
feature_files = dir(fullfile(DDIR, '*.ptxt'));
feature_files = fullfile(DDIR, {feature_files.name});

PIECEDATA(numel(feature_files))=struct('filename','','fileind',0,'data',[]);
for k = 1:numel(feature_files)
    PIECEDATA(k).filename = feature_files{k};
    PIECEDATA(k).fileind=k;
    PIECEDATA(k).data=load(PIECEDATA(k).filename,'ascii');
    % remove the first column (noteIndices)
    PIECEDATA(k).data = PIECEDATA(k).data(:,2:end);
    
    PIECEDATA(k).N=size(PIECEDATA(k).data,1);   
end

% generating the classifier model:
FLDmodel=generateFLDmodel(PIECEDATA);
