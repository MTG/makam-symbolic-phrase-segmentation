function [PD,PFA,AUC,Fmeasures,THs]=ComputeROC(Lini,y,N)
% function [PD,PFA,AUC,Fmeasures,THs]=ComputeROC(L,y,N)
% 
%     Computes the receiver operating characteristics curve as well as the 
%     area under the curve based on the scaler measure provided for recog-
%     nition in L for point labels identified in y.
% 
%     It is assumed that the base class is associated with low values of L.
% 

if (nargin<3)
    N=500;
end

CL=unique(y);
I1=find(y==CL(1));
I2=find(y~=CL(1));
L=rankdata(Lini);
THs=((2*N+1):-2:-1)/(2*N)*(max(L)-min(L))+min(L);
PD=zeros(1,length(THs));
PFA=zeros(1,length(THs));
Fmeasures=zeros(1,length(THs));
for i=1:length(THs)
    PD(i)=mean(L(I2)>=THs(i));
    PFA(i)=mean(L(I1)>=THs(i));
    cPrec=sum(L(I2)>=THs(i))/sum(L>=THs(i));
    Fmeasures(i)=2*cPrec*PD(i)/(cPrec+PD(i));
end
ii=2:length(THs);
AUC=0.5*sum((PFA(ii)-PFA(ii-1)).*(PD(ii)+PD(ii-1)));



