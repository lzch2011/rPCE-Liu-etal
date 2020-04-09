function preErr = compMergeErr(A,Err,XTrain,YTrain,XOracle,YOracle,modelConf)

[uniqA,IA,IC] = unique(A,'rows','stable');
ScoreFreq = accumarray(IC, 1);

maxErr = max(Err);
ScoreErr = zeros(size(uniqA,1),1);
for iD = 1:size(uniqA,1)
    ScoreErr(iD) = sum(Err(IC==iD))/ScoreFreq(iD)/maxErr;
end
ScoreErr = modelConf.rPCE.considerErr*ScoreErr;

totalScore = ScoreFreq + ScoreErr;
[~,idW]=sort(totalScore,'descend');
sortA = uniqA(idW,:);

nIter = min(size(sortA,1),length(YTrain)-1);
UTrain = reformX(XTrain,modelConf);
PSI = basisGe(UTrain,sortA(1:nIter,:).',modelConf);

vecErr = zeros(nIter,1);
vecQ2 = zeros(nIter,1);
    
for iIter=1:nIter
    iPSI = PSI(:,1:iIter);

    [vecQ2(iIter),vecErr(iIter)] = computekFoldError(iPSI,YTrain,length(YTrain));
    
    pES = 0;
    if (iIter > 2) && (modelConf.rPCE.earlyStop==1) && (iIter > 0.1*nIter)
        ss = sign(vecQ2 - max(vecQ2));
        pES = (sum(ss(end-1:end)) == -2);
    end
    
    if pES == 1
        vecQ2((iIter+1):end)=[];
        [maxQ2,indMaxQ2] = max(vecQ2);
        vecQ2((indMaxQ2+1):end)=[];
        alpha = sortA(1:indMaxQ2,:);
        break
    end
end
    
if (modelConf.rPCE.earlyStop==0) || ((modelConf.rPCE.earlyStop==1) && (pES == 0))
    [maxQ2,indMaxQ2] = max(vecQ2);
    alpha = sortA(1:indMaxQ2,:);
end

bestPSI=PSI(:,1:indMaxQ2);
beta = (bestPSI.'*bestPSI)\(bestPSI.'*YTrain);

UOracle = reformX(XOracle,modelConf);
testPSI = basisGe(UOracle,alpha.',modelConf);
YPC = testPSI*beta;
preErr = sum((YPC-YOracle).^2);
    
end