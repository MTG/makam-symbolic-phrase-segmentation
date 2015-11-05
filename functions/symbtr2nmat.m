function [NM, segment, noteIndex] = symbtr2nmat(filepath, filename, usulFile)
%symbtr2nmat:   Converts SymbTr file to noteMatrix and segmentation matrices
%   filename:   Name and path of the SymbTr file (.txt)
%   NM:         Output in MIDI Toolbox notematrix format
%   bolut:      Segmentation information
%   usulFile:   Path & "usuller.txt" (Includes numerator (Zaman) and
%               denominator (Mertebe) information of all usuls).
%   Addendum:   Now process SymbTr files coming from Mus2, which includes
%               the word "Es" for rests.

u                       = regexp(filename, '--', 'split');
usulName                = u(3);
[~, mertebe]            = findTime_mertebe(usulName, usulFile);
[syn, gecki]            = readSymbTr(filepath);
[syn]                   = computeCums(syn, mertebe);
[syn]                   = removeRests(syn, mertebe);
[NM, segment, noteIndex]= extractInfo(syn, mertebe, gecki);
[segment]               = beatCheck(NM, segment);
end

function [syn, gecki] = readSymbTr(fileName)
% reads the relevant fields in the SymbTr file
fid = fopen(fileName);
C=textscan(fid, '%f %f %s %s %f %f %f %f %f %f %f %s %f', ...
    'delimiter', '\t', 'HeaderLines', 1);
[~] = fclose(fid);
syn = [C{[1 2 5:11]}];

syn(syn(:,8) == 101,8) = 100;
if syn(end,1) ~= 53 % put phrase boundary to the end of the file if it
    % is not already there
    syn(size(syn,1)+1,2) = 53;
    syn(size(syn,1),1) = syn(size(syn,1)-1,1)+1;
end

syn(isnan(syn)) = 0;

gecki = C{12}(syn(:,2) == 54);
end

function [syn] = computeCums(syn, mertebe)
% Kumulatif ms ve beat'leri hesaplayip diziye yazar
% Computes the cumulative ms and beats and writes it to an array
gecMert = mertebe;
syn(:,  10) = 0;
syn(:, 11) = 0;
for k = 2 : size(syn, 1)
    syn(k, 10) = syn(k - 1, 10) + syn(k - 1, 7);
    % Usul degisim noktalarinda pay ve payda yeni usulun zaman ve mertebesini gosteriyor
    if syn(k - 1, 2) ~= 51
        if syn(k - 1, 6) ~= 0
            syn(k, 11) = syn(k - 1, 11) + gecMert * syn(k - 1, 5) / ...
                syn(k - 1, 6);
        else
            syn(k, 11) = syn(k - 1, 11);
        end
    else
        gecMert = syn(k - 1, 6); %syn(k, 5); idi!
        syn(k, 11) = syn(k - 1, 11);
    end
end
end

function [syn] = removeRests(syn, ~)
k = 2;
while k <= size(syn, 1) - 1;
    if (syn(k, 3) < 0) || (syn(k, 4) < 0) % Rest
        if (51 <= syn(k - 1, 2) && syn(k - 1, 2) <= 55)
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
% k. ile (k-1). satirin yerlerini degistirir
syn(size(syn, 1) + 1, :) = syn(k - 1, :);
syn(k - 1, :)            = syn(k, :);
syn(k, :)                = syn(size(syn, 1), :);
syn(size(syn, 1), :)     = [];
end

function [syn] = combineRest(syn, k)
% Bir onceki satir nota veya es ise, bu es'in degerini ona ekle;
% cari satiri iptal et
onc = syn(k - 1, 5) / syn(k - 1, 6);
cri = syn(k, 5) / syn(k, 6);
lns = (onc * syn(k - 1, 8) + cri * syn(k, 8))  / (onc + cri);
syn(k - 1, 5) = onc + cri;
syn(k - 1, 6) = 1;
syn(k - 1, 7) = syn(k - 1, 7) + syn(k, 7);
syn(k - 1, 8) = lns;
syn(k, :) = [];
end

function [NM, segment, noteIndex]= extractInfo(syn, mertebe, gecki)
geckInd = 1;
NM    = [];
segment = struct('kod', 0, 'beat', 0, 'ms', 0, 'noteIndex', 0,'comment', ' ');
bInd  = 0;
nInd  = 0;
noteIndex = [];
for k = 1 : size(syn, 1) - 1
    if syn(k, 2) == 51
        mertebe = syn(k, 6);
    elseif syn(k, 2) == 53 || syn(k, 2) == 54 || syn(k, 2) == 55
        bInd = bInd + 1;
        segment(bInd).kod      = syn(k, 2);
        segment(bInd).noteIndex= syn(k, 1);
        segment(bInd).beat     = round(2 * mertebe * syn(k + 1, 11)) / (2 * mertebe);
        segment(bInd).ms       = round(syn(k + 1, 10) / 500) / 2;
        if segment(bInd).kod == 54
            segment(bInd).comment = gecki(geckInd);
            geckInd = geckInd + 1;
        end
        if k < size(syn, 1) - 1
            if syn(k + 1, 4) == -1
                segment(bInd).ms   = syn(k + 2, 10) / 1000;
                segment(bInd).beat = round(2 * syn(k + 2, 11)) / 2;
            end
        end
    else
        nInd = nInd + 1;
        NM(nInd, 1) = syn(k, 11); %onsetBeat
        if syn(k, 6) ~= 0
            NM(nInd, 2) = mertebe * syn(k, 5) / syn(k, 6) * syn(k, 8) / 100; %beatDur
        else
            if nInd > 0
                NM(nInd, 2) = NM(nInd - 1, 2); %beatDur
            else
                NM(nInd, 2) = 0;
            end
        end
        if syn(k, 4) >= 0
            NM(nInd, 4) = syn(k, 4) * 12 / 53; %midiNo
        else
            NM(nInd, 4) = -1;% Sus
        end
        NM(nInd, 5) = syn(k, 9);
        NM(nInd, 6) = syn(k, 10) / 1000; % OnsetSec
        NM(nInd, 7) = syn(k, 7) * syn(k, 8) / 100000; %durSec
        noteIndex(nInd) = syn(k, 1); % note index
    end
end
bInd = bInd + 1;
segment(bInd).kod  = 53;
segment(bInd).noteIndex= syn(end, 1);
segment(bInd).beat = round(2 * mertebe * syn(end, 11)) / (2 * mertebe);
segment(bInd).ms   = round(syn(end, 10) / 500) / 2;
NM(:, 3) = 1; %Chan
end

function [bolut] = beatCheck(NM, bolut)
% NM'de bulunmayan beat'leri duzeltir
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
