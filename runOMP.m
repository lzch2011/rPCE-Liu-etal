function modelOMP = runOMP(PsiN,Yc,Psi,Y,modelConf)

nData = size(PsiN,1);

nIter= min(nData-1,size(PsiN,2));

A_active = zeros(1,nIter);
A_remain = 1:size(PsiN,2);
Res = Yc;

vecQ2 = zeros(nIter,1);
vecErr = zeros(nIter,1);
betaOLS = zeros(size(PsiN,2),nIter);
for iIter=1:nIter
    [~,idSelect]=max(abs(Res.'*PsiN(:,A_remain)));
    A_active(iIter)=A_remain(idSelect);
    A_remain(idSelect) = [];
    iPSI = PsiN(:,A_active(1:iIter));
    beta = (iPSI.'*iPSI)\(iPSI.'*Yc);
    Res = Yc - iPSI*beta;
    
    iPsi = Psi(:,[1,A_active(1:iIter)+1]);
    ibetaOLS = (iPsi.'*iPsi)\(iPsi.'*Y);
    betaOLS([1,A_active(1:iIter)+1],iIter) = ibetaOLS;
    [vecQ2(iIter),vecErr(iIter)] = computeLOOError(iPsi,Y,ibetaOLS);
    
    pES = 0;
    if (modelConf.earlyStop==1) && (iIter > 0.1*nIter) && (iIter > 2)
      % early stop in model selection
      ss = sign(vecQ2 - max(vecQ2));
      pES = (sum(ss(end-1:end)) == -3);
    end
  
    if pES == 1
        vecQ2((iIter+1):end)=[];
        [maxQ2,indMaxQ2] = max(vecQ2);
        vecQ2((indMaxQ2+1):end)=[];
        vecErr((indMaxQ2+1):end)=[];
        A_active((indMaxQ2+1):end) = [];
        break
    end
end

if modelConf.earlyStop==0 || ((modelConf.earlyStop==1) && (pES == 0)) 
    [maxQ2,indMaxQ2] = max(vecQ2);
    vecQ2((indMaxQ2+1):end)=[];
    vecErr((indMaxQ2+1):end)=[];
    A_active((indMaxQ2+1):end) = [];
end

modelOMP.A = [1,A_active+1];
modelOMP.vecQ2 = vecQ2;
modelOMP.vecErr = vecErr;
modelOMP.maxQ2 = maxQ2;
modelOMP.beta = betaOLS([1,A_active+1],indMaxQ2);
end
