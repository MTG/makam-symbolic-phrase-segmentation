function [TH,maxF]=SetThresholdF(inp,Y)
% sets the threshold for the model to label a phrase. The value is set by
% maximizing the f1 score on the training set
CL=unique(Y);
M0=(Y==CL(1));
M1=1-M0;
N1=sum(M1);

% line search for the threshold that maximizes the F measure ..
% lTH=mean(inp(I0));
% uTH=mean(inp(I1));
% THs=(1:99)/100*(uTH-lTH)+lTH;
% THs=(1:99)/100*range(inp)+min(inp);
THs=quantile(inp,(1:199)/200);
Fs=zeros(1,length(THs));
for i=1:length(THs)
    PM=(inp>=THs(i));
    cprec=sum(PM&M1)/sum(PM);
    crec=sum(PM&M1)/N1;
    Fs(i)=2*cprec*crec/(cprec+crec);
end
[maxF,maxind]=max(Fs);
TH=THs(maxind);

