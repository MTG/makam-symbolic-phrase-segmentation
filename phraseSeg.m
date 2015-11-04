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
%   If you want call the standalone binary provided in the package from the
%   terminal, append the run_mcr.sh function and with the Command syntax
%   (http://www.mathworks.com/help/matlab/ref/syntax.html)
%
%       run_mcr.sh phraseSeg segment testFolder FLDmodelFile outFolder
%
% learnBoundStat .................. Learn boundary statistics 
%       Inputs: 
%           trainScoresFolder       The folder, which has the annotated
%                                   scores for training
%           [boundStatFile]         The file where the boundary statistics
%                                   are to be saved.
%       Outputs:
%           boundStatFile           The file where the boundary statistics
%                                   are saved. It is the boundStatFile
%                                   input if specified, else it is 
%                                   "trainScoresFolder/boundStat.mat"
% extractFeature .................. Feature Extraction
%       Inputs: 
%           (scoreFolder/scoreFile) The folder with scores or a single
%                                   score to extract features
%           boundStatFile:          The mat file with saved boundary stats
%           [outFolder/outFile]     The folder to save the features or a 
%                                   filename to save the feature of a 
%                                   single score input
%       Outputs:
%           featureFiles            The paths for the saved feature files
%           feature                 the extracted features
% train ........................... Training
%       Inputs: 
%           trainFeatureFolder      The folder, which has the features
%                                   extracted from the trained scores
%           [FLDmodelFile]          The file where the training model is
%                                   to be saved
%       Outputs:
%           FLDmodelFile            The file where the training model is
%                                   saved. It is the FLDmodelFile input
%                                   if specified, else it is
%                                   "trainingFeatureFolder/FLDmodel.mat"
%           FLDmodel                the trained model
% segment ......................... Segmentation
%       Inputs:
%           (testFeatureFolder/     the .ptxt feature file associated with
%              testFeatureFile)     a SymbTr file or a folder containing
%                                   multiple .ptxt files
%           FLDmodelFile            the segmentation model (or the file 
%                                   which the model is saved)
%           [outFolder/outFile]     the .autoSeg file associated with a 
%                                   SymbTr file or a folder where .autoSeg 
%                                   files will be saved for multiple SymbTr
%       Outputs:
%           bound_files             the paths of the files where the
%                                   automatic segmentation boundaries are 
%                                   stored
%           bound                   the segmentation boundaries
% evaluate ........................ Evaluation
%       Inputs:
%           trainFeatureFolder      the path to the directory with the
%                                   score feature files extracted from the 
%                                   scores used for training
%           outFile                 the path to save the evaluation results 
%                   
%           plotRoc                 boolean to plot the region of 
%                                   convergence or not
%       Outputs:
%           outFile                 the path where evaluation results is 
%                                   saved. Default is
%                                   "trainFeatureFolder/results.mat"
%           results:                the evaluation results
% There are also some additional functions:
% test ............................ Test run 
%       It can be used to check whether the code works without any
%       problems.
%       Inputs: 
%           - none -
%       Outputs: 
%           - none (will display success message on completion) -
% getSegments .................. Get the manually annotated segmentations
%       Inputs: 
%           trainScoresFolder       The folder, which has the annotated
%                                   scores
%           [segmentationsFolder]   The folder to save the segment
%                                   boundaries
%       Outputs:
%           annotatedSegmentFiles   The files where the annotated segment
%                                   boundaries are saved. The basefolder is
%                                   the segmentationsFolder if specified 
%                                   else it's the annotatedScoresFolder.
%                                   The filename is the same with the score
%                                   name, with an extension ".seg"
%  
%   Sertan Senturk, 2 December 2013
%   Universitat Pompeu Fabra
%   email: sertan.senturk@upf.edu 
inputErr = false;

%% I/O
p = fileparts(mfilename('fullpath'));
usulFile = fullfile('makamdata','usuls.txt');
noteTableFile = fullfile('makamdata','noteTable.txt');

%% run the specified function
switch varargin{1}
    case 'unitTest'
        if nargin > 1; inputErr = true; else unitTest(); end
    case 'wrapper'
        if nargin ~= 8; inputErr = true; else wrapper(varargin{2:end}); end
    case 'trainWrapper'
        if nargin ~= 6; inputErr = true; else trainWrapper(varargin{2:end}); end
    case 'segmentWrapper'
        if nargin ~= 5; inputErr = true; else trainWrapper(varargin{2:end}); end
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
    errstr = ['Wrong inputs! \n'...
        'Usage: \n'...
        '  Training Wrapper ............ "trainWrapper trainFolder boundStatFile trainFeatureFolder FLDmodelFile" \n'...
        '  Segmentation Wrapper ............ "segmentWrapper boundStatFile FLDmodelFile testFolder testFeatureFolder testSegmentFolder" \n'...
        '  Complete Wrapper ............ "wrapper trainFolder boundStatFile trainFeatureFolder FLDmodelFile testFolder testFeatureFolder testSegmentFolder" \n'...
        'Individual functions: \n'...
        '  Learn boundary statistics ....... "learnBoundStat noteTableFile [outFile]" \n'...
        '  Feature Extraction............... "extractFeature (scoreFolder/scoreFile) boundStatFile [outFolder/outFile]" \n'...
        '  Training ........................ "train trainingFolder [outFolder]" \n'...
        '  Segmentation .................... "segment (testFolder/testFile) FLDmodelFile [outFolder/outFile]" \n'...
        '  Evaluation ...................... "evaluate [evaluateFolder/evaluateFile] [plotROC]" \n'...
        'Extras: \n'...
        '  Test run ........................ "unitTest" \n'...
        '  Get manual segments in SymbTr ... "getSegments (scoreFolder/scoreFile) [outFolder/outFile]" \n'];
    error('makamSymPhraseSeg:input', errstr)
end

%% outputs
if ~ismember(varargin{1}, {'test', 'wrapper'})
    if iscell(file) % multiple files were processed
        varargout{1} = char(GetFullPath(file(:)));
    else
        varargout{1} = GetFullPath(file);
    end
end
end