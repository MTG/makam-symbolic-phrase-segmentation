function [Y,inp]=applyFLDmodel(PIECEDATA,FLDmodel)
%APPLYFLDMODEL Applies the segmentation model to the loaded data of the
%   SymbTr score to be segmented

% ignore the first column (offset)
inp=PIECEDATA.data(:,2:(end-1))*FLDmodel.w; 
Y=(inp>=FLDmodel.TH);




