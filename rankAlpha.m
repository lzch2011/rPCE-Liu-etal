function rPCEModel = rankAlpha(dicAlpha,dicErr,XTrain,YTrain,XOracle,YOracle,modelConf)

ScoreFreq = cell(1,length(dicAlpha)); % frequency score
ScoreErr = cell(1,length(dicAlpha)); % error score
dicUniqAlpha = cell(1,length(dicAlpha));
vec_nFold = modelConf.rPCE.kFold.nFold;
maxFold = lcms(vec_nFold);

for ii = 1:(length(dicAlpha)+1)
    
    if ii <=  length(dicAlpha)  
        % compute frequency and error score with a single value of k (number of division)
        idicAlpha = dicAlpha{1,ii};
        [uniqAlpha,IA,IC] = unique(idicAlpha,'rows','stable');
        dicUniqAlpha{1,ii} = uniqAlpha;
        
        iScoreFreq = accumarray(IC, 1);
        ScoreFreq{1,ii} = iScoreFreq/vec_nFold(ii)*maxFold;
        
        idicErr = dicErr{1,ii};
        maxErr = max(abs(idicErr));
        iScoreErr = zeros(size(uniqAlpha,1),1);
        for iD = 1:size(uniqAlpha,1)
            iScoreErr(iD) = sum(idicErr(IC==iD))/iScoreFreq(iD)/maxErr;
        end
        ScoreErr{1,ii} = iScoreErr;
    else
        % compute frequency and error score by combining good values of k 
        wholeAlpha = [];
        wholeErr = [];
        wholeFreq = [];
        for jj=1:length(dicAlpha)
            wholeAlpha = [wholeAlpha; dicUniqAlpha{1,jj}];
            wholeErr = [wholeErr; ScoreErr{1,jj}];
            wholeFreq = [wholeFreq; ScoreFreq{1,jj}]; 
        end
        
        [uniqAlpha,~,IC] = unique(wholeAlpha,'rows','stable');
        repeFreq = accumarray(IC, 1);
        
        iScoreFreq = zeros(size(uniqAlpha,1),1);
        iScoreErr = zeros(size(uniqAlpha,1),1);
        for aa = 1:size(uniqAlpha,1)
            iScoreFreq(aa) = sum(wholeFreq(IC == aa));
            iScoreErr(aa) = sum(wholeErr(IC==aa))/repeFreq(aa);
        end
    end
    
    totalScore = iScoreFreq + iScoreErr;
    
    % rank alpha depending on total score
    [~,idW]=sort(totalScore,'descend');
    sortedAlpha = uniqAlpha(idW,:);
    iScoreFreq = iScoreFreq(idW);
    iScoreErr = iScoreErr(idW);
    
    % construct polynomial basis
    nAlpha = min(size(sortedAlpha,1),length(YTrain)-1); % maximum number of basis polynomials to be included in the final model 
    UTrain = reformX(XTrain,modelConf); % normalize input variables
    PSI = basisGe(UTrain,sortedAlpha(1:nAlpha,:).',modelConf); % composte basis
    
    % optimize basis size by LOOCV
    vecErr = zeros(nAlpha,1);
    vecQ2 = zeros(nAlpha,1);
    for iAlpha=1:nAlpha
        iPSI = PSI(:,1:iAlpha);
        [vecQ2(iAlpha),vecErr(iAlpha)] = computekFoldError(iPSI,YTrain,length(YTrain)); % compute LOOCV error
    end
    [maxQ2,indMaxQ2] = max(vecQ2);
    alpha = sortedAlpha(1:indMaxQ2,:);

    finalPSI=PSI(:,1:indMaxQ2); % final basis
    beta = (finalPSI.'*finalPSI)\(finalPSI.'*YTrain); % expansion coeff. as least-square solution
    
    YTrainPCE = finalPSI*beta;  % predicted training data
    
    rPCEModel(ii).Predict.YTrainp = YTrainPCE;
    rPCEModel(ii).PCE.alphaFull = sortedAlpha;
    rPCEModel(ii).PCE.alphaIndex = 1:indMaxQ2;
    rPCEModel(ii).PCE.Q2 = maxQ2;
    rPCEModel(ii).PCE.loo_scores = 1-vecQ2;
    rPCEModel(ii).PCE.Coeff = beta;
    rPCEModel(ii).PCE.freqScore = iScoreFreq;
    rPCEModel(ii).PCE.errScore = iScoreErr;
    
    % Compute R2 according to independent testing
    if ~isempty(YOracle)
        UOracle = reformX(XOracle,modelConf);
        testPSI = basisGe(UOracle,alpha.',modelConf);
        YPCE = testPSI*beta;
        Err = sum((YPCE-YOracle).^2);
        R2 = 1-Err/var([YOracle;YTrain])/length(YOracle);
        rPCEModel(ii).Predict.Err = Err;
        rPCEModel(ii).Predict.R2 = R2;
        rPCEModel(ii).Predict.YTest = YPCE;
    end
end
end