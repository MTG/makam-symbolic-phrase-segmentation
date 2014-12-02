function [NM, segment] = symbtr2nmat(fileName, usulFile)
%symbtr2nmat:   Converts SymbTr file to noteMatrix and segmentation matrices
%   filename:   Name and path of the SymbTr file (.txt)
%   NM:         Output in MIDI Toolbox notematrix format
%   bolut:      Segmentation information
%   usulFile:   Path & "usuller.txt" (Includes numerator (Zaman) and
%               denominator (Mertebe) information of all usuls).
%   Addendum:   Now process SymbTr files coming from Mus2, which includes
%               the word "Es" for rests.

u               = regexp(fileName, '--', 'split');
usulName        = u(3);
[~, mertebe]	= findTime_mertebe(usulName, usulFile);
[syn, gecki]    = readSymbTr(fileName);
[syn]           = computeCums(syn, mertebe);
[syn]           = removeRests(syn, mertebe);
[NM, segment]   = extractInfo(syn, mertebe, gecki);
[segment]       = beatCheck(NM, segment);
end

function [syn, gecki] = readSymbTr(fileName)
% reads the relevant fields in the SymbTr file
fid = fopen(fileName);
C=textscan(fid, '%f %f %s %s %f %f %f %f %f %f %f %s %f', ...
    'delimiter', '\t', 'HeaderLines', 1);
[~] = fclose(fid);
syn = [C{[2 5:11]}];

syn(syn(:,7) == 101,7) = 100;
if syn(end,1) ~= 53 % put phrase boundary to the end of the file if it
    % is not already there
    syn(size(syn,1)+1,1) = 53;
end

syn(isnan(syn)) = 0;

gecki = C{12}(syn(:,1) == 54);
end

function [syn] = computeCums(syn, mertebe)
% Kumulatif ms ve beat'leri hesaplayip diziye yazar
% Computes the cumulative ms and beats and writes it to an array
gecMert = mertebe;
syn(:,  9) = 0;
syn(:, 10) = 0;
for k = 2 : size(syn, 1)
    syn(k, 9) = syn(k - 1, 9) + syn(k - 1, 6);
    % Usul degisim noktalarinda pay ve payda yeni usulun zaman ve mertebesini gosteriyor
    if syn(k - 1, 1) ~= 51
        if syn(k - 1, 5) ~= 0
            syn(k, 10) = syn(k - 1, 10) + gecMert * syn(k - 1, 4) / syn(k - 1, 5);
        else
            syn(k, 10) = syn(k - 1, 10);
        end
    else
        gecMert = syn(k - 1, 5); %syn(k, 5); idi!
        syn(k, 10) = syn(k - 1, 10);
    end
end
end

function [syn] = removeRests(syn, ~)
k = 2;
while k <= size(syn, 1) - 1;
    if (syn(k, 2) < 0) || (syn(k, 3) < 0) % Rest
        if (51 <= syn(k - 1, 1) && syn(k - 1, 1) <= 55)
            syn = swapLines(syn, k);
            if k > 2
                syn = combineRest(syn, k - 1);
            end
        else
            syn = combineRest(syn, k);
        end
    end
    k = k + 1;
end
end

function [syn] = swapLines(syn, k)
% k. ile (k-1). satirin yerlerini de?i?tirir
syn(size(syn, 1) + 1, :) = syn(k - 1, :);
syn(k - 1, :)            = syn(k, :);
syn(k, :)                = syn(size(syn, 1), :);
syn(size(syn, 1), :)     = [];
end

function [syn] = combineRest(syn, k)
% Bir onceki satir nota veya es ise, bu es'in degerini ona ekle;
% cari satiri iptal et
onc = syn(k - 1, 4) / syn(k - 1, 5);
cri = syn(k, 4) / syn(k, 5);
lns = (onc * syn(k - 1, 7) + cri * syn(k, 7))  / (onc + cri);
syn(k - 1, 4) = onc + cri;
syn(k - 1, 5) = 1;
syn(k - 1, 7) = lns;
syn(k - 1, 6) = syn(k - 1, 6) + syn(k, 6);
syn(k, :) = [];
end

function [NM, bolut]= extractInfo(syn, mertebe, gecki)
geckInd = 1;
NM    = [];
bolut = struct('kod', 0, 'beat', 0, 'ms', 0, 'aciklama', ' ');
bInd  = 0;
nInd  = 0;
for k = 1 : size(syn, 1) - 1
    if syn(k, 1) == 51
        mertebe = syn(k, 5);
    elseif syn(k, 1) == 53 || syn(k, 1) == 54 || syn(k, 1) == 55
        bInd = bInd + 1;
        bolut(bInd).kod      = syn(k, 1);
        bolut(bInd).beat     = round(2 * mertebe * syn(k + 1, 10)) / (2 * mertebe);
        bolut(bInd).ms       = round(syn(k + 1, 9) / 500) / 2;
        if bolut(bInd).kod == 54
            bolut(bInd).aciklama = gecki(geckInd);
            geckInd = geckInd + 1;
        end
        if k < size(syn, 1) - 1
            if syn(k + 1, 3) == -1
                bolut(bInd).ms   = syn(k + 2, 9) / 1000;
                bolut(bInd).beat = round(2 * syn(k + 2, 10)) / 2;
            end
        end
    else
        nInd = nInd + 1;
        NM(nInd, 1) = syn(k, 10); %onsetBeat
        if syn(k, 5) ~= 0
            NM(nInd, 2) = mertebe * syn(k, 4) / syn(k, 5) * syn(k, 7) / 100; %beatDur
        else
            if nInd > 0
                NM(nInd, 2) = NM(nInd - 1, 2); %beatDur
            else
                NM(nInd, 2) = 0;
            end
        end
        if syn(k, 3) >= 0
            NM(nInd, 4) = syn(k, 3) * 12 / 53; %midiNo
        else
            NM(nInd, 4) = -1;% Sus
        end
        NM(nInd, 5) = syn(k, 8);
        NM(nInd, 6) = syn(k, 9) / 1000; % OnsetSec
        NM(nInd, 7) = syn(k, 6) * syn(k, 7) / 100000; %durSec
    end
end
bInd = bInd + 1;
bolut(bInd).kod  = 53;
bolut(bInd).beat = round(2 * mertebe * syn(end, 10)) / (2 * mertebe);
bolut(bInd).ms   = round(syn(end, 9) / 500) / 2;
NM(:, 3) = 1; %Chan
end

function [bolut] = beatCheck(NM, bolut)
% NM'de bulunmayan beat'leri d?zeltir
for k = 1 : length(bolut) - 1
    idx = find(NM >= bolut(k).beat, 1);
    if isempty(idx)
        idx = size(NM, 1);
    else
        while (idx < size(NM, 1) && NM(idx, 4) < 0)
            idx = idx + 1;
        end
    end
    if (idx <= size(NM, 1))
        bolut(k).beat = NM(idx, 1);
    else
        bolut(k).beat = NM(size(NM, 1), 1);
    end
end
end
