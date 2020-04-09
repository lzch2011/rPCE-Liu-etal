% Code for paper "Surrogate modeling based on resampled polynomial chaos
% expansions" by Liu et al.
% Matlab-based software UQLab (https://www.uqlab.com) should be downloaded and installed in advance 
% Date: April 8, 2020
% Code only for academic researches

close all;
clear all;

funName = 'Ishigami';  %'BoreHole', 'Ishigami'

nTrainData = 10;  % number of training data
nOracleData = 1e2; % number of data for independent testing

[modelConf.pdfs,modelConf.parameters,modelConf.bounds] = paraList(funName);

modelConf.vecp = 1:10; % maximum value of total degree of polynomials
modelConf.q = 1;
modelConf.earlyStop = 0;
modelConf.signCDF = 0;
if nTrainData <= 10
    modelConf.rPCE.kFold.nFold= [3,5];  % default value 1
elseif nTrainData <= 20
    modelConf.rPCE.kFold.nFold= [3,5,10];  % default value 1
else
    modelConf.rPCE.kFold.nFold= [3,5,10,20];  % default value 1
end
%--------------------------------------%
%  Choose the best resampling scheme
%--------------------------------------%
nTrial = 100;
for iTrial = 1:nTrial
    fprintf('Running the %d-th trial\n',iTrial)
    
    [XTrain,YTrain,XOracle,YOracle] = genData(nTrainData,nOracleData,modelConf,funName);

    model(iTrial).Data.XTrain = XTrain;
    model(iTrial).Data.YTrain = YTrain;
    model(iTrial).Data.XTest = XOracle;
    model(iTrial).Data.YTest = YOracle;
    
    modelConf.codeChoice = 'UQLab'; %'UQLab' or 'C2M'
    modelConf.methodChoice = 'LARS'; %'LARS', 'OMP', or 'rPCE'
    model(iTrial).LARS = dispatchCenter(XTrain,YTrain,XOracle,YOracle,modelConf);
    fprintf('---------------------\n')

    modelConf.codeChoice = 'UQLab'; %'UQLab' or 'C2M'
    modelConf.methodChoice = 'OMP'; %'LARS', 'OMP', or 'rPCE'
    model(iTrial).OMP = dispatchCenter(XTrain,YTrain,XOracle,YOracle,modelConf);
    fprintf('---------------------\n')
    
    modelConf.codeChoice = 'UQLab'; %'UQLab' or 'C2M'
    modelConf.methodChoice = 'rPCE'; %'LARS', 'OMP', or 'rPCE'
    [model(iTrial).rPCE] = dispatchCenter(XTrain,YTrain,XOracle,YOracle,modelConf);
end
save(sprintf('modelPCE_%s_N%d',funName,nTrainData),'model')