function varargout = phraseSeg(varargin)
% PHRASESEG Automatic phrase segmentation on scores of Ottoman-Turkish
% makam music
%   This function 
%
% Test run ........................ test
%       Inputs: none
%       Outputs: none
% Get manual segments in SymbTr: .. getSegments (scoreFolder/scoreFile) [outFolder/outFile]
%       Inputs:
%       Outputs:
% Learn boundary statistics ....... learnBoundStat noteTableFile [outFile
%       Inputs:
%       Outputs:
% Feature Extraction............... extractFeature (scoreFolder/scoreFile) boundStat_file [outFolder/outFile]
%       Inputs:
%       Outputs:
% Training ........................ train trainingFolder [outFolder]
%       Inputs:
%       Outputs:
% Segmentation .................... segment (testFolder/testFile) FLDmodel_file [outFolder/outFile]
%       Inputs:
%       Outputs:
% Evaluation ...................... evaluate [evaluateFolder/evaluateFile] [plotROC]
%       Inputs:
%       Outputs:
%    
%   Sertan Senturk, 2 December 2012
%   Universitat Pompeu Fabra
%   email: sertan.senturk@upf.edu 
inputErr = false;

%% I/O
p = fileparts(mfilename('fullpath'));

% dictionary files. We check the path structure in MATLAB and the binary 
% compiled by MATLAB runtime compiler
usulFile_src={fullfile(p,'files','usuller.txt'), ... % path in MATLAB
    fullfile(p,'..','files','usuller.txt')}; % path in MCR
noteTableFile_src={fullfile(p,'files','noteTable.txt'), ... % path in MATLAB
    fullfile(p,'..','files','noteTable.txt')}; % path in MCR
usulFile = usulFile_src{cellfun(@(x) ~isempty(dir(x)), usulFile_src)};
noteTableFile = noteTableFile_src{cellfun(@(x) ~isempty(dir(x)), ...
    noteTableFile_src)};

%% run the specified function
switch varargin{1}
    case 'test'
        if nargin > 1; inputErr = true; else test(); end
    case 'getSegments' % extract segments in a SymbTrFile
        switch nargin
            case {2, 3}
                [file, varargout{2}] = getSegments(varargin{2},...
                    usulFile, varargin{3});
            otherwise
                inputErr = true;
        end
    case 'learnBoundStat' % learn boundary statistics
        switch nargin
            case 2 % output file not specified
                [file, varargout{2}]=learnBoundStat(varargin{2},...
                    noteTableFile, usulFile);
            case 3 % output file specified
                [file, varargout{2}]=learnBoundStat(varargin{2},...
                    noteTableFile, usulFile, varargin{3});
            otherwise
                inputErr = true;
        end
    case 'extractFeature' % compute score features
        switch nargin
            case 3 % output file not specified
                [file, varargout{2}] = extractFeature(varargin{2:3}, ...
                    usulFile);
            case 4 % output file specified
                [file, varargout{2}] = extractFeature(varargin{2:3}, ...
                    usulFile, varargin{4});
            otherwise
                inputErr = true;
        end
    case 'train' % training
        switch nargin
            case {2, 3}
                [file,varargout{2}]=train(varargin{2:end});
            otherwise
                inputErr = true;
        end
    case 'segment' % segmentation according to the trained model
        switch nargin
            case {3,4}
                [file, varargout{2}] = segment(varargin{2:end});
            otherwise
                inputErr = true;
        end
    case 'evaluate' % evaluation
        switch nargin
            case {2, 3, 4}
                [file,varargout{2}]=evaluate(varargin{2:end});
            otherwise
                inputErr = true;
        end
    otherwise
        inputErr = true;
end

%% error handling
if inputErr
    errstr = ['Wrong inputs! Usage: \n' ...
        'Test run ........................ "test" \n'...
        'Get manual segments in SymbTr: .. "getSegments (scoreFolder/scoreFile) [outFolder/outFile]" \n'...
        'Learn boundary statistics ....... "learnBoundStat noteTableFile [outFile]" \n'...
        'Feature Extraction............... "extractFeature (scoreFolder/scoreFile) boundStat_file [outFolder/outFile]" \n'...
        'Training ........................ "train trainingFolder [outFolder]" \n'...
        'Segmentation .................... "segment (testFolder/testFile) FLDmodel_file [outFolder/outFile]" \n'...
        'Evaluation ...................... "evaluate [evaluateFolder/evaluateFile] [plotROC] "'];
    error('makamSymPhraseSeg:input', errstr)
end

%% outputs
if ~strcmp(varargin{1}, 'test')
    if iscell(file) % multiple files were processed
        varargout{1} = char(GetFullPath(file(:)));
    else
        varargout{1} = GetFullPath(file);
    end
end
end