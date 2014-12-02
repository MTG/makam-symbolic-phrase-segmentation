function [PIECEDATA,DATA,FILEINDs,OUTLIST]=loadPieceDataInFolder(in)
% loads the data related to the SymbTr scores in a folder
if exist(in, 'dir')
    feature_files = dir(fullfile(in, '*.ptxt'));
    feature_files = fullfile(in, {feature_files.name});
elseif exist(in, 'file')
    feature_files = {strrep(in, '.txt', '.ptxt')};
else
    error('loadPieceDat:input', [in  'does not exist!'])
end

PIECEDATA(numel(feature_files))=struct('filename','','fileind',0,'data',[]);
for k = 1:numel(feature_files)
    PIECEDATA(k).filename = feature_files{k};
    PIECEDATA(k).fileind=k;
    PIECEDATA(k).data=load(PIECEDATA(k).filename,'ascii');
    PIECEDATA(k).N=size(PIECEDATA(k).data,1);
end

N=sum([PIECEDATA(:).N]);
FILEINDs=zeros(N,1);
DATA=zeros(N,size(PIECEDATA(1).data,2));
bind=1;
for i=1:length(PIECEDATA)
    eind=bind+size(PIECEDATA(i).data,1)-1;
    FILEINDs(bind:eind)=PIECEDATA(i).fileind;
    DATA(bind:eind,:)=PIECEDATA(i).data;
    bind=eind+1;
end

% first, eliminate the piece data containing NaN features ..
FI=2:(size(DATA,2)-1);
d=length(FI);
OUTLIST=[];
for j=1:d
    OUTLIST=union(OUTLIST,unique(FILEINDs(find(isnan(DATA(:,FI(j)))))));
end
if (length(OUTLIST)>0)
    IIN=find(sum(repmat(FILEINDs,1,length(OUTLIST))-repmat(OUTLIST',N,1)==0,2)==0);
    NIIN=length(IIN);
else
    IIN=1:N;
    NIIN=N;
end

DATA=DATA(IIN,:);
FILEINDs=FILEINDs(IIN);

