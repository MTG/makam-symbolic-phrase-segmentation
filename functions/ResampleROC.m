function PD=ResampleROC(PFAini,PDini,PFA)
% Resamples ROC
n=length(PFAini);
m=length(PFA);

Inds=sum(repmat(PFAini(:),1,m)<repmat(PFA(:)',n,1));
PD=zeros(size(PFA));
PD(Inds==0)=PDini(1);
PD(Inds==n)=PDini(n);
ii=find((Inds>0)&(Inds<n));
cl=(PFA(ii)-PFAini(Inds(ii)))./(PFAini(Inds(ii)+1)-PFAini(Inds(ii)));
PD(ii)=(1-cl).*PDini(Inds(ii))+cl.*PDini(Inds(ii)+1);

