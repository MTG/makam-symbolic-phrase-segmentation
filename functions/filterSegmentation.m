function [newSegment]=filterSegmentation(segment)
% ezgi sinirlari disindaki bolutleme bilgilerini atar
% throws away codes that are not 53 which signify melodic boundary
newSegment=segment;
% eserin basina cumle siniri konma 
% adding a boundary at the first onset
newSegment(1).kod=53;
newSegment(1).beat=0;newSegment(1).sec=0;newSegment(1).comment={''};
m=2;
for k=1:length(segment)
    if(segment(k).kod==53 && ~isnan(segment(k).beat))
        if(k>1)
            if(segment(k-1).beat~=segment(k).beat)
                newSegment(m)=segment(k);
                newSegment(m).beat=round(newSegment(m).beat*16)/16; 
                m=m+1;
            end
        else
            newSegment(m)=segment(k);
            newSegment(m).beat=round(newSegment(m).beat*16)/16;
            m=m+1;
        end
    end
end
newSegment=newSegment(1:m-1);

end