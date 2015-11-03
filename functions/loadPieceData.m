function piecedata=loadPieceData(feature_file)
% Loads the data related to the SymbTr score (features, name, feature data size)
piecedata.filename = feature_file;
piecedata.data=load(piecedata.filename,'ascii');
piecedata.N=size(piecedata.data,1);
