function [outFile, results] = evaluate(trainFolder, outFile, plotROC)
%EVALUATE Evaluates the results obtained by autmatic phrase segmentation
%   This function evaluates the results obtained from the automatic phrase
%   segmentation on the file level and also the dataset level using leave-
%   one-out cross validation. 
%   Inputs:
%       trainFolder: the path to the directory with the scores used for 
%                    training
%       outFile (optional): the path to save the evaluation results 
%                    (Default: (trainFolder)/results.mat)
%       plotRoc: boolean to plot the region of convergence or not
%   Outputs:
%       outFile: the path where evaluation results is saved
%       results: the evaluation results
%
%   Sertan Senturk, 2 December 2012
%   Universitat Pompeu Fabra
%   email: sertan.senturk@upf.edu 

if ~exist('plotRes', 'var')
    plotROC = false;
end
if ~exist('outFile', 'var') || isempty(outFile)
    outFile =  fullfile(trainFolder, 'results.mat');
else
    if ~exist(fileparts(outFile), 'dir') % make sure the folder exist
        status = mkdir(fileparts(outFile));
        if ~status
            error('learnBoundStat:outFile', ['The folder to save the stats '...
                'cannot be created. Check the write permisions.'])
        end
    end
end

% loading the piece data:
[pieceData,~,fileInds]=loadPieceDataInFolder(trainFolder);

% leave-one-out  cross validation
inList=unique(fileInds);
res_temp = cell(length(inList), 1);
FULLCM=zeros(2,2);
for i=1:length(inList)
    Ytrue=pieceData(inList(i)).data(:,end);
    res_temp{i}.Ytrue=Ytrue;
    
    FLDmodel=generateFLDmodel(pieceData(setdiff(inList,inList(i))));
    res_temp{i}.model=FLDmodel;
    
    [Yhat,inp]=applyFLDmodel(pieceData(inList(i)),FLDmodel);
    res_temp{i}.Yhat=Yhat;
    
    % computing the confusion matrix:
    cI0=find(Ytrue==0);
    cI1=find(Ytrue==1);
    CM=[sum(Yhat(cI0)==0) sum(Yhat(cI0)==1); sum(Yhat(cI1)==0) sum(Yhat(cI1)==1)];
    res_temp{i}.CM=CM;
    FULLCM=FULLCM+CM;
    
    res_temp{i}.Sensitivity=CM(2,2)/sum(CM(2,:));
    res_temp{i}.Specificity=CM(1,1)/sum(CM(1,:));
    res_temp{i}.Precision=CM(2,2)/sum(CM(:,2));
    res_temp{i}.Fmeasure=2*res_temp{i}.Sensitivity*...
        res_temp{i}.Precision/...
        (res_temp{i}.Sensitivity+res_temp{i}.Precision);
    
    % computing the ROC:
    [cPD,cPFA,cAUC]=ComputeROC(inp,Ytrue);
    res_temp{i}.PD=cPD;
    res_temp{i}.PFA=cPFA;
    res_temp{i}.AUC=cAUC;
end
results.leave1out = cell2mat(res_temp);

% the overall statistics:
results.overall.Sensitivity=FULLCM(2,2)/sum(FULLCM(2,:));
results.overall.Specificity=FULLCM(1,1)/sum(FULLCM(1,:));
results.overall.Precision=FULLCM(2,2)/sum(FULLCM(:,2));
results.overall.Fmeasure=2*results.overall.Sensitivity*...
    results.overall.Precision/...
    (results.overall.Sensitivity+results.overall.Precision);
results.overall.confusionMat = FULLCM;

% compute the average ROC curve ..
CPFA=[.0001 .001 .01:.01:.99];
APD=zeros(1,length(CPFA));
for i=1:length(inList)
    APD=APD+ResampleROC(results.leave1out(i).PFA,results.leave1out(i).PD,CPFA)/length(inList);
end
results.overall.roc.APD = APD;
results.overall.roc.CPFA = CPFA;
results.overall.roc.average = 0.5*sum(([CPFA 1]-[0 CPFA]).*([APD 1]+[0 APD]));

if plotROC
    figure(1)
    clf
    plot(CPFA,APD)
    axis equal;
    axis([0 1 0 1]);
    title(sprintf('The average ROC curve; AUC is %.4f',results.overall.roc.average));
    xlabel('P_{FA}');
    ylabel('P_{D}');
    grid on
end

% write to file
save(outFile, '-struct', 'results')
end