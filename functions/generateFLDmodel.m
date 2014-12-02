function FLDmodel=generateFLDmodel(PIECEDATA)
% Generates the model for automatic segmentation using the score features
% and manually annotated phrase boundaries
N=sum([PIECEDATA(:).N]);

d=size(PIECEDATA(1).data,2);

X=zeros(N,d-2);
Y=zeros(N,1);
ind=0;
for i=1:length(PIECEDATA)
    ii=ind+(1:PIECEDATA(i).N);
    X(ii,:)=PIECEDATA(i).data(:,2:(d-1));
    Y(ii,:)=PIECEDATA(i).data(:,end);
    ind=ii(end);
end

I1=find(Y==1); % a label of '1' is assumed to represent the notes on the phrase boundary
I0=setdiff(1:N,I1);

mu1=mean(X(I1,:));
mu0=mean(X(I0,:));
Sigma1=cov(X(I1,:));
Sigma0=cov(X(I0,:));

w=pinv(Sigma1+Sigma0)*(mu1-mu0)';
FLDmodel.w=w;

% now, identify the threshold ..
traininp=X*w;
[TH,F]=SetThresholdF(traininp,Y);
FLDmodel.TH=TH;
FLDmodel.F=F; % this is the "maximal" F-measure observed on the training data

