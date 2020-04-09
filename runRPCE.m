function [rPCEModel_Merge,rPCEModel_LARS,rPCEModel_OMP,selectId,dicR2,dicQ2] = runRPCE(XTrain,YTrain,XOracle,YOracle,modelConf)

[dicAlpha_LARS,dicErr_LARS,dicAlpha_OMP,dicErr_OMP,dicR2,dicQ2] = kFoldVote(XTrain,YTrain,modelConf);

% refine the selection of alpha based on selection frequency and LOOCV
% error
rPCEModel_LARS = rankAlpha(dicAlpha_LARS,dicErr_LARS,XTrain,YTrain,XOracle,YOracle,modelConf);
rPCEModel_OMP = rankAlpha(dicAlpha_OMP,dicErr_OMP,XTrain,YTrain,XOracle,YOracle,modelConf);
dicA = mergeCell(dicAlpha_LARS,dicAlpha_OMP);
dicErr = mergeCell(dicErr_LARS,dicErr_OMP);
rPCEModel_Merge = rankAlpha(dicA,dicErr,XTrain,YTrain,XOracle,YOracle,modelConf); % combination of LARS and OMP

% Compute 1st and 3rd quartile of R2 so that algorithm choose LARS, OMP, or
% combination
Q1_LARS = quantile(dicR2(:,1),0.25); Q3_LARS = quantile(dicR2(:,1),0.75);
Q1_OMP = quantile(dicR2(:,2),0.25); Q3_OMP = quantile(dicR2(:,2),0.75);
if Q1_LARS >= Q3_OMP
    selectId = 'lars';
elseif Q3_LARS <= Q1_OMP
    selectId = 'omp';
else
    selectId = 'merge';
end