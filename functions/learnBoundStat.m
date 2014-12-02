function [outFile, boundStat] = learnBoundStat(folderName, ...
    noteTableFile, usulFile, outFile)
% LEARNBOUNDSTAT Learn boundary statistics from manual phrase segmentations
%   This function computes the melodic boundary distributions from the data
%   in 'folderName' ('folderName' isimli klasorde bulunan verilerden ezgi
%   sinirlarinin dagilimlarini hesaplar.)
%   Inputs:
%       folderName: The path to the folder with the SymbTr-scores with
%                   manual segmentations. 
%       usulFile:   The dictionary file storing relevant information about
%                   the usuls
%       outFile (optional): The path of the mat file to save the boundary 
%                   distributions (default: "(folderName)/boundStat.mat")
%  Outputs:
%       outFile:    The path of the mat file to save the boundary 
%                   distributions (default: "(folderName)/boundStat.mat")
%       boundStat:  A struct with boundary distibution information
%
%  Sertan Senturk, 2 December 2012
%  Universitat Pompeu Fabra
%  email: sertan.senturk@upf.edu 

%% I/O
if ~exist('noteTableFile', 'var') || (isempty(noteTableFile))
    noteTableFile='./files/noteTable.txt';
end
if ~exist('usulFile', 'var') || (isempty(usulFile))
    usulFile='./files/usuller.txt';
end
if ~exist('outFile', 'var') || isempty(outFile)
    outFile = fullfile(folderName, 'boundStat.mat');
else
    if ~exist(fileparts(outFile), 'dir') % make sure the folder exist
        status = mkdir(fileparts(outFile));
        if ~status
            error('learnBoundStat:outFile', ['The folder to save the '...
                'stats cannot be created. Check the write permisions.'])
        end
    end
end

%% klasordeki makam ve usuller listesi cikar
%create a list of makams and usuls and the number of pieces, phrases, etc.
[makamList,usulList]=createListOfMakamsUsuls(folderName , usulFile);

%nota isimlerinin ve midiNo'larin okunmasi--------
fid = fopen(noteTableFile);
C=textscan(fid, '%s%s%d%d%f%f');
[~] = fclose(fid);
midiNo = C{5};
midiNo=round(midiNo*100);
%-------------------------------------------------

currentDir=pwd;
cd(folderName);
files=dir('*.txt');

[makamHist]=initializeMakamStruct(makamList,midiNo);
[usulHist]=initializeUsulStruct(usulList,usulFile);

for k=1:length(files)
    s = regexp(files(k).name, '--', 'split');
    
    makam=s(1);
    usul=s(3);
    % ---- verinin okundugu adim ----
    %reading note matrix and boundary information from file
    %NM carries the note events in the standard format of MidiToolbox,
    %'bolut' carries the melodic boundaries in beats and milisecs
    [NM, segment] = symbtr2nmat(files(k).name,usulFile);
    [segment]=filterSegmentation(segment);
    [NM]=filterNoteMatrix(NM);
    
    %finding makam and usul index / makam ve usul indeksini bul
    for makamInd=1:length(makamList)
        if(strcmp(makamList(makamInd).name,makam)), break; end
    end
    for usulInd=1:length(usulList)
        if(strcmp(usulList(usulInd).name,usul)), break; end
    end
    
    
    %Parcanin verilerini ilgili makam'in dagilimlarina ekle
    %Adding note counts for the piece to makam-note distributions
    [makamHist]=add2allNotesHist(midiNo,NM,makamHist,makamInd);
    
    %Bolut sinirlarindaki notalarin sayilmasi
    %Counting boundary notes
    oncekiSatirNo=1;
    for m=2:length(segment)
        satirNo=find(NM(:,1)==segment(m).beat);
        if(isempty(satirNo))
            if(m==length(segment))%en sonda bulunan cumle siniri icin denk gelen beat olmayabiliyor, siniri en sona esle
                satirNo=length(NM(:,1))+1;
            else%bolut siniri hic bir satir beat'ine eslenemediyse en yakindakini bul ve sonraki ilk satira esle
                ind=find(NM(:,1) > segment(m).beat);
                if(isempty(ind))
                    satirNo=length(NM(:,1))+1;
                else
                    satirNo=ind(1);
                end
                
            end
        end
        if(oncekiSatirNo>length(NM) || (satirNo-1)>length(NM))
            %disp(['---Bolut degeri sinirlari asiyor : ' files(k).name]);
        else
            %cumlenin ilk nota bilgisi ile histogramlari degistir
            %ilkNotaHist: starting note histogram
            ind=find(midiNo==round(NM(oncekiSatirNo,4)*100));
            makamHist(makamInd).ilkNotaHist.sure(ind)=makamHist(makamInd).ilkNotaHist.sure(ind)+NM(oncekiSatirNo,7);
            makamHist(makamInd).ilkNotaHist.sayi(ind)=makamHist(makamInd).ilkNotaHist.sayi(ind)+1;
            
            %---------------------
            %cumlenin son nota bilgisi ile histogramlari degistir
            %sonNotaHist: ending note histogram
            ind=find(midiNo==round(NM(satirNo-1,4)*100));
            makamHist(makamInd).sonNotaHist.sure(ind)=makamHist(makamInd).sonNotaHist.sure(ind)+NM(satirNo-1,7);
            makamHist(makamInd).sonNotaHist.sayi(ind)=makamHist(makamInd).sonNotaHist.sayi(ind)+1;
            
            %error check
            if(sum(makamHist(makamInd).genelHist.sayi<makamHist(makamInd).ilkNotaHist.sayi)>0 || sum(makamHist(makamInd).genelHist.sayi<makamHist(makamInd).sonNotaHist.sayi)>0)
                disp('--------------------sinirdaki nota sayisi toplam nota sayisini asmis gorunuyor');
            end
            oncekiSatirNo=satirNo;
        end
    end
    %-----------------------------------------------
    
    %Usul'e dair dagilimlara ekleme islemi--------------
    % bolutlerin denk geldigi beat histogrami hesabi
    % Computation of the boundary distribution with respect to usul beats
    for bind = 1 : length(segment)
        if segment(bind).ms ~= 0
            % The shortest note can be 1/64, triole => 3 * 64 = 192
            %                    n = 1 + floor(mod(192 * seg(k), zaman));
            n = 1 + floor(mod(segment(bind).beat*2, usulHist(usulInd).timeMertebe(1)*2));
            usulHist(usulInd).segInUsulHisto(1, n) = usulHist(usulInd).segInUsulHisto(1, n) + 1;
        end
    end
    
end

% outFile=fullfile(folderName,'makamUsulBoundDist.mat');
% save(outFile,'usulHist','makamHist','midiNo');
boundStat = struct('usulHist', usulHist, 'makamHist', makamHist, ...
    'midiNo', midiNo);
cd(currentDir);

% save
save(outFile, '-struct', 'boundStat');
end


function [makamHist]=initializeMakamStruct(makamList,midiNo)

makamHist=makamList;
makamNoteHist=zeros(1,length(midiNo));
for k=1:length(makamList)
    makamHist(k).genelHist.sure=makamNoteHist;
    makamHist(k).genelHist.sayi=makamNoteHist;
    makamHist(k).ilkNotaHist.sure=makamNoteHist;
    makamHist(k).ilkNotaHist.sayi=makamNoteHist;
    makamHist(k).sonNotaHist.sure=makamNoteHist;
    makamHist(k).sonNotaHist.sayi=makamNoteHist;
end
end


function [makamHist]=add2allNotesHist(midiNo,NM,makamHist,makamInd)
for k=1:size(NM,1)
    ind=find(midiNo==round(NM(k,4)*100));
    if(isempty(ind))
        disp(['Note not found:' num2str(round(NM(k,4)*100))]);
    end
    makamHist(makamInd).genelHist.sure(ind)=makamHist(makamInd).genelHist.sure(ind)+NM(k,7);
    makamHist(makamInd).genelHist.sayi(ind)=makamHist(makamInd).genelHist.sayi(ind)+1;
end
end

function [usulHist]=initializeUsulStruct(usulList,usulFile)

usulHist=usulList;
for k=1:length(usulList)
    [time, mertebe] = findTime_mertebe(usulList(k).name, usulFile);
    usulHist(k).timeMertebe=[time mertebe];
    usulHist(k).segInUsulHisto = zeros(1, time*2);%cuzunurluk: yarim vurus/resolution: zaman*2
end
end

