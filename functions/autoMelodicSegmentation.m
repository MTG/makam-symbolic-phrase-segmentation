function boundary = autoMelodicSegmentation(feature_filename, FLDmodel)
%Performs automatic melodic segmentation using the FLDmodel
% Inputs: 
%   filename: the ptxt feature filename of the corresponding SymbTr file
%   FLDmodel: the trained classifier model
% Outputs
%   boundary: boundary (first note onset) in beats

piecedata=loadPieceData(feature_filename);

% applying the classifier model:
Ypred=applyFLDmodel(piecedata,FLDmodel);

boundary = [piecedata.data(Ypred,1)];