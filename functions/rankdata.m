function res=rankdata(x)
% ranks data to compute ROC
[n,d]=size(x);
res=zeros(n,d);
for i=1:d
    O=1:length(x(:,i));
    [nouse,o]=sort(x(:,i));
    res(o,i)=O(:);
end
