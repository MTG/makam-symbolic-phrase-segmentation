function [NM, noteIndex]=filterNoteMatrix(NM, noteIndex)
%0 uzunlugundaki satirlari siler/removes lines with zero length

zeroLenRows=NM(:,7)>0;
NM=NM(zeroLenRows,:);
%ayni beat'e konmus ardisik satirlardan ilkini siler
%removes the first of two events that are at the same beat
rows2beKept=[];
for k=1:length(NM(:,1))-1
    %beat bilgisi ayni, NaN iceren satirlar, eksi midino iceren(sus)
    %sat?rlar? d??ar?da b?rak
    %excluding lines with equal consequitive beats, NaN and negative midino
    if(NM(k,1)==NM(k+1,1) || isnan(sum(NM(k,:))) || NM(k,4)<=0)
        %  satiri alma/ exclude the line
        %disp('deleted line: ');disp(NM(k,:));
    else
        rows2beKept=[rows2beKept k];
    end
end
if(isnan(sum(NM(end,:))) || NM(end,4)<=0)
    %excluding last line with NaN and negative midino
else
    rows2beKept=[rows2beKept length(NM(:,1))];
end
NM=NM(rows2beKept,:);
noteIndex=noteIndex(rows2beKept);
end