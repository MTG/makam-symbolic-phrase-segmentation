function [makamList,usulList]=createListOfMakamsUsuls(folderName, usulFile)
%Klasordeki makam ve usullerin listesini ve kac parca icerdiklerini cikarir
%Forms list of makams and usuls and the number of pieces, melodic boundaries, etc.

files=dir(fullfile(folderName, '*.txt'));
filepaths = cellfun(@(x) fullfile(folderName, x), {files.name}, 'unif', 0);

% get makam, usul and the number of phrases per file in the dataset
s = regexp({files.name}, '--', 'split');
makams = cellfun(@(x) x{1}, s, 'unif', false);
usuls = cellfun(@(x) x{3}, s, 'unif', false);
numPhrases=cellfun(@(x) countPhrases(x,usulFile), filepaths);

[makams_unique, numFiles_makams_unique, numPhrases_makams_unique] = ...
    getStatsPerClass(makams, numPhrases);
[usuls_unique, numFiles_usuls_unique, numPhrases_usuls_unique] = ...
    getStatsPerClass(usuls, numPhrases);

makamList=struct('name',makams_unique,...
    'numFiles',num2cell(numFiles_makams_unique),...
    'numPhrases',num2cell(numPhrases_makams_unique));
usulList=struct('name',usuls_unique,...
    'numFiles',num2cell(numFiles_usuls_unique),...
    'numPhrases',num2cell(numPhrases_usuls_unique));
end

function [names_unique, numFiles, numPhrases] = getStatsPerClass(...
    names_perFile, numPhrases_perFile)

% unique names
[names_unique, ~, im_u] = unique(names_perFile);

% number of files per name
numFiles = hist(im_u, unique(im_u));

% number of phrases per name; compute it vectorized
num_labels = numel(names_unique);
num_names = numel(names_perFile);
label_mat = zeros(num_labels, num_names);
idx = im_u + cumsum(num_labels*ones(num_names,1)) - num_labels; % unroll
label_mat(idx) = 1;

numPhrases = numPhrases_perFile * label_mat';
end

function numPhrase=countPhrases(fileName,usulFile)
[~, segment] = symbtr2nmat(fileName,usulFile);
[segment]=filterSegmentation(segment);
numPhrase=length(segment)-1;
end