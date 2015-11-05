function piecedata=loadPieceData(featureIn)
% Loads the data related to the SymbTr score (features, name, feature data size)

if ismatrix(featureIn)
    piecedata.filename = '';
    piecedata.data=featureIn;
else
    piecedata.filename = featureIn;
    piecedata.data=load(piecedata.filename,'ascii');
end

piecedata.N=size(piecedata.data,1);