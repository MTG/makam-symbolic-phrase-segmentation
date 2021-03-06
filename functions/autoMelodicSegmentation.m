function [boundary, boundary_note_idx] = autoMelodicSegmentation(...
    featureIn, FLDmodel)
%Performs automatic melodic segmentation using the FLDmodel
% Inputs: 
%   filename: the ptxt feature filename of the corresponding SymbTr file
%   FLDmodel: the trained classifier model
% Outputs
%   boundary: boundary (first note onset) in beats

piecedata=loadPieceData(featureIn);

% ignore the first column (note index)
idx = piecedata.data(:, 1:2);
piecedata.data = piecedata.data(:, 2:end);

% applying the classifier model:
Ypred=applyFLDmodel(piecedata,FLDmodel);

boundary = idx(Ypred,2);
boundary_note_idx = idx(Ypred,1);