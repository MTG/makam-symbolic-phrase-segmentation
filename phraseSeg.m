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
%   You can refer to the script train_applySegmentation_demo.m to call each
%   function step-by-step.
%
% Function calls:
% learnBoundStat .................. Learn boundary statistics 
%       Inputs:
%           trainingFolder: The path to the folder with the SymbTr-scores
%           	with manual segmentations. 
%           [boundStatFile] (optional): The path of the mat file to save
%           	the boundary distributions (default: "(folderName)/boundStat.mat")
%  Outputs:
%           boundStatFile: The path of the mat file to save the boundary 
%           	distributions (default: "(folderName)/boundStat.mat")
%           boundStat: A struct with boundary distibution information
%
% extractFeature .................. Feature Extraction
%       Inputs:
%           {scoreFile/scoreFolder}: The path of a single SymbTr-txt score
%           	or a directory containing multiple SymbTr-scores
%           boundStat: The phrase boundary distributions on the training
%               dataset computed by learnBoundStat. It can be given as a
%               struct or as the path to a .mat file where the boundary
%               distribution was saved by running "learnBoundStat".
%           [featureFile/featureFolder] (optional): The path for the saved
%               feature  file (if a "scoreFile" is given as the input) or
%               the path of the directory to save the saved feature files
%               (if "scoreFolder" is given as the input)
%       Outputs:
%           featureFiles: The path(s) for the saved feature files
%           feature: the extracted features
%
% train ........................... Training
%       Inputs: 
%           trainingFeatureFolder:  the path to the folder where the
%               features (.ptxt files by default) extracted from the
%               training scores are stored
%           [modelFile] (optional): the path to the folder where the model
%               will be stored (default: "(trainingFeatureFolder)/FLDmodel.mat")
%       Output:
%           modelFile: the path to the folder where the model will be
%               stored (default: "(trainingFeatureFolder)/FLDmodel.mat")
%           FLDmodel: the trained model
%
% segment ......................... Segmentation
%       Inputs:
%           {testFile/testFolder}: .ptxt feature file associated with a 
%               SymbTr file or a folder containing multiple .ptxt files
%           FLDmodel: the segmentation model or the file path where the
%               model is saved
%           [autoSegFile/autoSegFolder] (optional): the path to save the 
%               .autoSeg file with the automatic segmentations (if the 
%               input is a "scoreFile") or the path to a folder where the
%               .autoSeg files will be saved for multiple SymbTr scores
%       Outputs:
%           autoSegFiles: the paths of the files where the automatic
%               segmentation boundaries are stored
%           autoSegBound: the segmentation boundaries
%
% evaluate ........................ Evaluation
%       Inputs:
%           trainFeatureFolder: the path to the directory with the score 
%               feature files extracted from the scores used for training
%           evalResFile (optional): the path to save the evaluation results 
%               (Default: "(trainFeatureFolder)/results.mat")
%           plotRoc (optional): boolean to plot the region of convergence
%       Outputs:
%           evalResFile: the path where evaluation results is saved
%           results: the evaluation results
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
%           {scoreFile/scoreFolder}: .ptxt feature file associated with a
%           	SymbTr file or a folder containing multiple .ptxt files
%           {segFile/segFolder} (optional): the path to save the .seg file
%               with the segment boundaries (if a "scoreFile" is given as
%               the input) or the path to a folder where the .seg files 
%               will be saved for multiple SymbTr scores
%   Outputs: 
%       segFiles: The files where segment boundaries are saved   
%       segments: The segment boundaries
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
        'Get manual segments in SymbTr ... "getSegments {scoreFile/scoreFolder} {segFile/segFolder}" \n'...
        'Learn boundary statistics ....... "learnBoundStat trainingFolder [boundStatFile]" \n'...
        'Feature Extraction............... "extractFeature {scoreFile/scoreFolder} boundStatFile [featureFile/featureFolder]" \n'...
        'Training ........................ "train trainingFeatureFolder [modelFile]" \n'...
        'Segmentation .................... "segment {testFile/testFolder} FLDmodelFile [autoSegFile/autoSegFolder]" \n'...
        'Evaluation ...................... "evaluate trainFeatureFolder [evalResFile] [plotROC] "\n'...
        '* Variables enclosed in "[]" are optional \n'...
        '* Select either of the variables enclosed in "{/}" \n'...
        '* Refer to the documentation for more details \n'];
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