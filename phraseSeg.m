function varargout = phraseSeg(varargin)
% PHRASESEG Automatic phrase segmentation on scores of Ottoman-Turkish
% makam music
%   This is a wrapper to call the main steps in automatic phrase
%   segmentation. It allows the user to call the corresponding functions
%   without specifying the location of the usul and note dictionaries. The
%   user simply has to specify the input file/folder for each step and the
%   output file/folders if desired. 
%
%   Example call:
%       phraseSeg('segment', testFolder, FLDmodelFile, outFolder)
%
%   If you are call the standalone binary provided in the package from the
%   terminal, append the run_mcr.sh function and with the Command syntax
%   (http://www.mathworks.com/help/matlab/ref/syntax.html)
%
%       run_mcr.sh phraseSeg segment testFolder FLDmodelFile outFolder
%
% learnBoundStat .................. Learn boundary statistics 
%       Inputs: 
%           noteTableFile
%           [outFile]
%       Outputs:
% extractFeature .................. Feature Extraction
%       Inputs: 
%           (scoreFolder/scoreFile)
%           boundStatFile
%           [outFolder/outFile]
%       Outputs:
% train ........................... Training
%       Inputs: 
%           trainingFolder
%           [outFolder]
%       Outputs:
% segment ......................... Segmentation
%       Inputs:
%           (testFolder/testFile)
%           FLDmodelFile
%           [outFolder/outFile]
%       Outputs:
% evaluate ........................ Evaluation
%       Inputs:
%           [evaluateFolder/evaluateFile]
%           [plotROC]
%       Outputs:
%
% There are also some additional functions:
% test ............................ Test run 
%       It can be used to check whether the wrapper works without any
%       problems.
%       Inputs: 
%           - none -
%       Outputs: 
%           - none (will display success message on completion) -
% getSegments ..................... Get manual segments in SymbTr
%       Inputs: 
%           (scoreFolder/scoreFile)
%           [outFolder/outFile]
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
        'Get manual segments in SymbTr ... "getSegments (scoreFolder/scoreFile) [outFolder/outFile]" \n'...
        'Learn boundary statistics ....... "learnBoundStat noteTableFile [outFile]" \n'...
        'Feature Extraction............... "extractFeature (scoreFolder/scoreFile) boundStatFile [outFolder/outFile]" \n'...
        'Training ........................ "train trainingFolder [outFolder]" \n'...
        'Segmentation .................... "segment (testFolder/testFile) FLDmodelFile [outFolder/outFile]" \n'...
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