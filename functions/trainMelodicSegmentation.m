function [FLDmodel]=trainMelodicSegmentation(featureIn)
% this codes performs a sample run for the developed melodic segmentation
% algorithm that identifies the notes on phrase boundaries ..

if iscell(featureIn)
    feature_files = cell(size(featureIn));
    features = featureIn;
elseif exist(featureIn, 'dir')
    feature_files = dir(fullfile(featureIn, '*.ptxt'));
    feature_files = fullfile(featureIn, {feature_files.name});
    features = cell(size(feature_files));
    for k = 1:numel(feature_files)
        features{k} = load(feature_files{k},'ascii');
    end
end

PIECEDATA(numel(feature_files))=struct('filename','','fileind',0,'data',[]);
for k = 1:numel(feature_files)
    PIECEDATA(k).filename = feature_files{k};
    PIECEDATA(k).fileind=k;
    PIECEDATA(k).data=features{k};
    % remove the first column (noteIndices)
    PIECEDATA(k).data = PIECEDATA(k).data(:,2:end);
    
    PIECEDATA(k).N=size(PIECEDATA(k).data,1);   
end

% generating the classifier model:
FLDmodel=generateFLDmodel(PIECEDATA);
