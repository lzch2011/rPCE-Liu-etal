% predicte unknown inputs by obtained models

close all;
clear all;

funName = 'Ishigami';  
nTrainData = 50;
load(sprintf('modelPCE_%s_N%d',funName,nTrainData))

[modelConf.pdfs,modelConf.parameters,modelConf.bounds] = paraList(funName);

X = geneX_Original(nTrainData,modelConf);

uqlab
nFeature = length(modelConf.pdfs);
for ii = 1 : nFeature
    inputOpts.Marginals(ii).Type = char(modelConf.pdfs(ii));
    
    if isempty(modelConf.parameters{1,ii})
        inputOpts.Marginals(ii).Parameters = modelConf.bounds{1,ii};  % for uniform dis.
    else
        inputOpts.Marginals(ii).Parameters = modelConf.parameters{1,ii};
        if ~isempty(modelConf.bounds)
            inputOpts.Marginals(ii).Bounds = modelConf.bounds{1,ii};
        end
    end 
end
myInput = uq_createInput(inputOpts);
MetaOpts.Input = myInput;
MetaOpts.Type = 'Metamodel';
MetaOpts.MetaType = 'PCE';
MetaOpts.Method = 'Custom';
MetaOpts.PCE.Basis.PolyTypes = {'Legendre','Legendre','Legendre','Legendre'};


meanY_OMP = 0;
meanY_LARS = 0;
meanY_rPCE = 0;
for iModel = 1:length(model)
    MetaOpts.PCE.Basis.Indices = model(iModel).LARS.PCE.alphaFull(model(iModel).LARS.PCE.alphaIndex,:);
    MetaOpts.PCE.Coefficients = model(iModel).LARS.PCE.Coeff(model(iModel).LARS.PCE.alphaIndex);
    myPCE = uq_createModel(MetaOpts);
    Y_LARS = uq_evalModel(X);
    meanY_LARS = meanY_LARS + Y_LARS;
    
    MetaOpts.PCE.Basis.Indices = model(iModel).OMP.PCE.alphaFull(model(iModel).OMP.PCE.alphaIndex,:);
    MetaOpts.PCE.Coefficients = model(iModel).OMP.PCE.Coeff(model(iModel).OMP.PCE.alphaIndex);
    myPCE = uq_createModel(MetaOpts);
    Y_OMP = uq_evalModel(X);
    meanY_OMP = meanY_OMP+Y_OMP;
    
    rPCE_approach = model(iModel).rPCE.selectApproach.name;
    if strcmpi(rPCE_approach,'merge')
        MetaOpts.PCE.Basis.Indices = model(iModel).rPCE.Merge(end).PCE.alphaFull(model(iModel).rPCE.Merge(end).PCE.alphaIndex,:);
        MetaOpts.PCE.Coefficients = model(iModel).rPCE.Merge(end).PCE.Coeff(model(iModel).rPCE.Merge(end).PCE.alphaIndex);
    elseif strcmpi(rPCE_approach,'lars')
        MetaOpts.PCE.Basis.Indices = model(iModel).rPCE.LARS(end).PCE.alphaFull(model(iModel).rPCE.LARS(end).PCE.alphaIndex,:);
        MetaOpts.PCE.Coefficients = model(iModel).rPCE.LARS(end).PCE.Coeff(model(iModel).rPCE.LARS(end).PCE.alphaIndex);
    elseif strcmpi(rPCE_approach,'omp')
        MetaOpts.PCE.Basis.Indices = model(iModel).rPCE.OMP(end).PCE.alphaFull(model(iModel).rPCE.OMP(end).PCE.alphaIndex,:);
        MetaOpts.PCE.Coefficients = model(iModel).rPCE.OMP(end).PCE.Coeff(model(iModel).rPCE.OMP(end).PCE.alphaIndex);
    end
    myPCE = uq_createModel(MetaOpts);
    Y_rPCE = uq_evalModel(X);
    meanY_rPCE = meanY_rPCE + Y_rPCE;
end
meanY_LARS = meanY_LARS/length(model);
meanY_OMP = meanY_OMP/length(model);
meanY_rPCE = meanY_rPCE/length(model);

Model.mHandle = @ishigami;
myModel = uq_createModel(Model);
YRef = uq_evalModel(myModel,X); 