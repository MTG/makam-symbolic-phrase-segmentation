function featureMatrix = boundaryFeatures(symbTrFile, makamHist, ...
    usulHist, usulFile, midiNo)
%symbTrFile dosyasindaki her bir nota icin bolutleme siniflandirmasi
%gerceklestirilebilmesi icin oznitelikleri hesaplar ve ptxt uzantili
%bir dosyaya yazar
%Computation of the features for automatic segmentation. A feature vector
%is computed for each note in the symbTrFile file and the results are 
%written to a ptxt

[NM, segment, noteIndex] = symbtr2nmat(symbTrFile,usulFile);

if(length(NM)<7)
    warning('boundaryFeatures:NM',['Too few data in NM: ' symbTrFile]);
    featureMatrix = [];
    return;
else
    [NM, noteIndex]=filterNoteMatrix(NM, noteIndex);
end
if(length(segment)>2)%eger bolut iceren bir dosya ise
    %check Nan bolut
    for k=1:length(segment)
        if(isnan(segment(k).beat))
            disp('------Bolut bilgisi Nan iceriyor------');
            disp(symbTrFile);return;
        end
    end
end
segInUsulHisto=usulHist.segInUsulHisto/max(usulHist.segInUsulHisto);
time=usulHist.timeMertebe(1);

%Oznitelik/Feature - 1 (pauseFeat)
%suslarin uzunluguna gore sinir olma olasiligini belirlenmesi
%offset to onset duration
offset2onsetDur=NM(2:end,1)-(NM(1:end-1,1)+NM(1:end-1,2));
NMind=find(offset2onsetDur<0, 1);
if ~isempty(NMind)%error check
    %disp(['Hata: nota suresi ile onseti toplayinca bir sonraki onsetten sonraya geliyor, NM index=' num2str(NMind(1))]);
    %disp(symbTrFile);
end
med=median(offset2onsetDur);%scaling the feature with the median value
pauseFeat=[0; (offset2onsetDur-med)/med];
ind= pauseFeat<0; pauseFeat(ind)=0;
pauseFeat(1:3)=0;%baslardaki suslarin sinir olarak tercih edilmesi gereksiz hata yaratacagi icin
%------------------------------------------
%Oznitelik/Feature - 2 (noteBoundProbEnd)
%makama gore notanin ezgi sinirinda(son nota olarak) bulunma olasiliginin hesaplanmasi
noteBoundProbEnd=zeros(length(NM),1);
for k=1:length(NM)-1
    ind=find(midiNo==round(NM(k,4)*100));
    if(isempty(ind) && NM(k,4)>0)%error check
        disp(['----Nota bulunamadi:' NM(k,4)]);
    end
    if(makamHist.genelHist.sayi(ind))
        noteBoundProbEnd(k+1)=makamHist.sonNotaHist.sayi(ind);
    else
        noteBoundProbEnd(k+1)=0;
    end
end
noteBoundProbEnd=noteBoundProbEnd/max(noteBoundProbEnd);
%------------------------------------------
%Oznitelik/Feature - 3 (noteBoundProbBeg)
%makama gore notanin ezgi sinirinda(ilk nota olarak) bulunma olasiliginin hesaplanmasi
noteBoundProbBeg=zeros(length(NM),1);
for k=1:length(NM)-1
    ind=find(midiNo==round(NM(k,4)*100));
    if(isempty(ind) && NM(k,4)>0)
        disp(['----Nota bulunamadi:' NM(k,4)]);
    end
    if(makamHist.genelHist.sayi(ind))
        noteBoundProbBeg(k)=makamHist.ilkNotaHist.sayi(ind);
    else
        noteBoundProbBeg(k)=0;
    end
end
noteBoundProbBeg=noteBoundProbBeg/max(noteBoundProbBeg);
%------------------------------------------
%Oznitelik/Feature - 4 (durRatio)
%sure oranlari hesaplama
durRatio=zeros(length(NM),1);
for k=1:length(NM)-1
    durRatio(k+1)=NM(k,2)/NM(k+1,2);
    %durRatio(k)=NM(k,2);
end
durRatio=durRatio/max(durRatio);
%------------------------------------------
%Oznitelik/Feature - 5 (deltaPitch)
%ardisik delta-pitch hesaplama
deltaPitch=zeros(length(NM),1);
for k=1:length(NM)-1
    deltaPitch(k+1)=abs(NM(k,4)-NM(k+1,4));
    %durRatio(k)=NM(k,2);
end
deltaPitch=deltaPitch/max(deltaPitch);
%tekrar eden notalarda sinir olma olasiligini yukselt, sinir olabiliyor
ind= deltaPitch==0;deltaPitch(ind)=0.4;
%------------------------------------------
%Oznitelik/Feature - [6 7] (boundBeatProbDur boundBeatProbOnset)
%her nota icin suresi boyunca(baslangici haric) ve sonraki notanin baslangicina kadar(dahil) son nota
%olma olasiliginin, degerler arasinda en yuksek deger secilerek karar
%verilmesi: boundBeatProbDur
%notanin ilk vurusunun guclu vurusa denk gelerek ezgi baslangici olma
%olasiligi: boundBeatProbOnset

boundBeatProbDur=zeros(length(NM),1);
boundBeatProbOnset=zeros(length(NM),1);
for k=1:length(NM)-1
    beatStart=NM(k,1);
    boundBeatProbOnset(k)=segInUsulHisto(1+mod(round(beatStart*2),time*2));
    beatNextStart=NM(k+1,1);maxVal=0;
    for b=beatStart+0.5:0.5:beatNextStart
        bmod= 1 + mod(round(b*2), time*2);
        maxVal=max(segInUsulHisto(bmod),maxVal);
    end
    %onNew(k)=beatNextStart;
    boundBeatProbDur(k+1)=maxVal;
end
%------------------------------------------
%Oznitelik/Feature - 8 (lbdm)
%automatic segmentation from Miditoolbox
[lbdm] = boundary_tr(NM);lbdm(1)=0;%LBDM
lbdm=lbdm/max(lbdm);
%------------------------------------------
%Oznitelik/Feature - 9 (tenPolArray)
%automatic segmentation from Miditoolbox
[tenney_polansky] = segmentgestalt_tr(NM);%Tenney and Polansky
tenPolArray=lbdm*0;
for k=1:length(NM)
    if(~isempty(find(tenney_polansky==NM(k,1), 1)))
        tenPolArray(k)=1;
    end
end
%------------------------------------------
%Oznitelik/Feature - 10 (prevDur): sure / duration
prevDur=[0; NM(1:end-1,2)]/max(NM(:,2));%normalisation
%------------------------------------------

%Oznitelik vektorunu olustur / Forming the feature vector


%Ilk sutun beat sonuncusu segmentasyon olup olmadigini belirtiyor
%First column contains the beat info and the last column contains the
%segmentation info. 0: not a boundary, 1: boundary, -1:no info available

if (length(segment)<2)%Bolutlenmemis dosya, son satira -1 yaz
    featureMatrix=[NM(:,1) lbdm tenPolArray prevDur durRatio deltaPitch boundBeatProbOnset boundBeatProbDur noteBoundProbBeg noteBoundProbEnd pauseFeat ones(length(NM),1)*(-1)];
else%Bolutlenmis dosya, son satira sinir notasi(ezginin ilk notasi) icin 1, olmayan icin 0 yaz
    featureMatrix=[NM(:,1) lbdm tenPolArray prevDur durRatio deltaPitch boundBeatProbOnset boundBeatProbDur noteBoundProbBeg noteBoundProbEnd pauseFeat zeros(length(NM),1)];
    
    sonSutunInd=size(featureMatrix,2);
    for k=1:length(segment)%uzman bolut bilgisinin son sutuna islenmesi
        if segment(k).kod == 53
            ind=find(featureMatrix(:,1)==segment(k).beat);
            if(isempty(ind) && k~=length(segment))%bolut beat'e karsilik gelmiyor ise sonrakine esle 
                ind=find((featureMatrix(:,1)-segment(k).beat)>0);
                if(~isempty(ind))
                    featureMatrix(ind(1),sonSutunInd)=1;
                end
            else
                featureMatrix(ind,sonSutunInd)=1;
            end
        end
    end
    %ilk satir ve son satirda kendiliginden sinir var, onlari verilerden cikar
    featureMatrix=featureMatrix(2:end-1,:);
    noteIndex = noteIndex(2:end-1);
end

% add the note indices to the features as the first colum
featureMatrix = [noteIndex(:) featureMatrix];
end
