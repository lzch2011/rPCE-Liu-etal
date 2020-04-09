function model = runUQLab(XTrain,YTrain,XTest,YTest,modelConf)

% run LARS or OMP with UQLab   

echo off
uqlab

nFeature = size(XTrain,2); % number of features/variables
for ii = 1 : nFeature
    IOpts.Marginals(ii).Type = char(modelConf.pdfs(ii));
    if isempty(modelConf.parameters{1,ii})
        IOpts.Marginals(ii).Parameters = modelConf.bounds{1,ii};  % for uniform dis.
    else
        IOpts.Marginals(ii).Parameters = modelConf.parameters{1,ii};
        if ~isempty(modelConf.bounds)
            IOpts.Marginals(ii).Bounds = modelConf.bounds{1,ii};
        end
    end 
end

myInput = uq_createInput(IOpts);

MetaOpts.Type = 'Metamodel';
MetaOpts.TruncOptions.qNorm = modelConf.q;  % 0<q<=1
MetaOpts.TruncOptions.MaxInteraction = 4; 
MetaOpts.Degree = modelConf.vecp;

if strcmpi(modelConf.methodChoice,'rpce')
    MetaOpts.Method = modelConf.rPCE.methodChoice;
    MetaOpts.MetaType = 'PCE';
elseif strcmpi(modelConf.methodChoice,'lra')
    MetaOpts.MetaType = 'LRA';
    MetaOpts.Rank = modelConf.LRA.vecr;
else
    MetaOpts.Method = modelConf.methodChoice;
    MetaOpts.MetaType = 'PCE';
end

MetaOpts.LARS.LarsEarlyStop = modelConf.earlyStop;

MetaOpts.ExpDesign.X = XTrain;
MetaOpts.ExpDesign.Y = YTrain;
modelUQLab = uq_createModel(MetaOpts);

YPCE = uq_evalModel(modelUQLab,XTest);
ERR = sum((YPCE-YTest).^2);
R2 = 1-ERR/var([YTrain;YTest])/length(YTest);

YTrainPC = uq_evalModel(modelUQLab,XTrain);

model.Predict.YTrain = YTrainPC;
model.Predict.YTest = YPCE;
model.Predict.Err = ERR;
model.Predict.R2 = R2;
model.PCE.Coeff = modelUQLab.PCE.Coefficients;
model.PCE.alphaFull = modelUQLab.PCE.Basis.Indices;
if strcmpi(MetaOpts.Method,'lars')
    model.PCE.alphaIndex = modelUQLab.Internal.PCE.LARS.lars_idx;
    model.PCE.loo_scores = modelUQLab.Internal.PCE.LARS.loo_scores;
elseif strcmpi(MetaOpts.Method,'omp')
    model.PCE.alphaIndex = modelUQLab.Internal.PCE.OMP.omp_idx;
    model.PCE.loo_scores = modelUQLab.Internal.PCE.OMP.loo_scores;
end
model.PCE.Q2 = 1 - modelUQLab.Error.LOO;

