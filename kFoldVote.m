function [dicAlpha_LARS,dicErr_LARS,dicAlpha_OMP,dicErr_OMP,dicR2,dicQ2] = kFoldVote(XTrain,YTrain,modelConf)

if isfield(modelConf.rPCE,'kFold')
    if isfield(modelConf.rPCE.kFold,'nFold')
        nFold = modelConf.rPCE.kFold.nFold;
    else
        nFold = 10;
    end
else
    nFold = 10; % number of subsets the training data would be divided into
end

dicAlpha_LARS = cell(1,length(nFold)); %set of alpha selected by LARS
dicErr_LARS = cell(1,length(nFold)); % set of decreasement of LOOCV error when increasing number of basis polynomials
dicAlpha_OMP = cell(1,length(nFold)); %set of alpha selected by OMP
dicErr_OMP = cell(1,length(nFold));
dicR2 = zeros(length(nFold)*length(YTrain),2); % set of determination coeff. from testing data
dicQ2 = zeros(length(nFold)*length(YTrain),2); % set of determination coeff. from LOOCV
idR2 = 0; % index

for ii = 1:length(nFold)
    idicAlpha_LARS = [];
    idicErr_LARS = [];
    idicAlpha_OMP = [];
    idicErr_OMP = [];
    
    % Divide training data into nFold subsets
    [XFold,YFold]=divTrainData(XTrain,YTrain,nFold(ii));

    for iFold = 1:nFold(ii)
        
        % leaving iFold-th subset out for validation and remaining data for
        % training
        [XCons,YCons,XTest,YTest] = genConsTestData(XFold,YFold,iFold,length(YTrain));
        
        % train LARS model and collect required information
        modelConf.rPCE.methodChoice= 'LARS';
        [~,modelUQLab_LARS] = evalc('runUQLab(XCons,YCons,XTest,YTest,modelConf);');
        idR2 = idR2 + 1;
        dicR2(idR2,1) = modelUQLab_LARS.Predict.R2; % determination coefficient from testing (validation) data
        dicQ2(idR2,1) = modelUQLab_LARS.PCE.Q2; % determination coefficient from LOOCV
        AUQLab_LARS = full(modelUQLab_LARS.PCE.alphaFull); % alpha of full model
        idicAlpha_LARS = [idicAlpha_LARS;AUQLab_LARS(modelUQLab_LARS.PCE.alphaIndex,:)]; % merge selected alpha by LARS into a multiset
        vecErr_LARS = modelUQLab_LARS.PCE.loo_scores(1:length(modelUQLab_LARS.PCE.alphaIndex))*var(YCons); % collect LOOCV error
        [~,vecErr_LARS(1)]= computekFoldError(ones(length(YCons),1),YCons,length(YCons)); % compute LOOCV error when only constant term in surrogate model
        idicErr_LARS = [idicErr_LARS;[vecErr_LARS(1),vecErr_LARS(1:(end-1))-vecErr_LARS(2:end)].']; % collect the decreasement of LOOCV error with increasing number of basis polynomials
        
        % train OMP model and collect required information
        modelConf.rPCE.methodChoice= 'OMP';
        [~,modelUQLab_OMP] = evalc('runUQLab(XCons,YCons,XTest,YTest,modelConf);');
        dicR2(idR2,2) = modelUQLab_OMP.Predict.R2;
        dicQ2(idR2,2) = modelUQLab_OMP.PCE.Q2;
        AUQLab_OMP = full(modelUQLab_OMP.PCE.alphaFull);
        idicAlpha_OMP = [idicAlpha_OMP;AUQLab_OMP(modelUQLab_OMP.PCE.alphaIndex,:)];
        vecErr_OMP = modelUQLab_OMP.PCE.loo_scores(1:length(modelUQLab_OMP.PCE.alphaIndex))*var(YCons);
        [~,vecErr_OMP(1)]= computekFoldError(ones(length(YCons),1),YCons,length(YCons));
        idicErr_OMP = [idicErr_OMP;[vecErr_OMP(1),vecErr_OMP(1:(end-1))-vecErr_OMP(2:end)].'];
    end

    dicAlpha_LARS{1,ii} = idicAlpha_LARS;
    dicErr_LARS{1,ii} = idicErr_LARS;
    dicAlpha_OMP{1,ii} = idicAlpha_OMP;
    dicErr_OMP{1,ii} = idicErr_OMP;
end

dicR2((idR2+1):end,:) = [];
dicQ2((idR2+1):end,:) = [];
end