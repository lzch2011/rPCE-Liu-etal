function dcvQ2 = runDCV_LARS(modelConf,X,Y)

nTrial = 1;
nFold = length(Y);

errMatrix = zeros(nTrial,nFold);
dcvQ2=zeros(1,nTrial);

% figure
for iTrial = 1:nTrial
    [XFold,YFold]=divTrainData(X,Y,nFold);
    for iFold = 1:nFold
        [XCons,YCons,XTest,YTest] = genConsTestData(XFold,YFold,iFold,length(Y));
        R2 = dispatchCenter(XCons,YCons,XTest,YTest,modelConf);
        errMatrix(iTrial,iFold) = (1-R2)*length(YTest);
    end
    meanErrMatrix = sum(errMatrix(1:iTrial,:),2)/length(Y);
    dcvQ2(iTrial) = 1-sum(meanErrMatrix(1:iTrial))/iTrial;
%     plot(1:iTrial,dcvQ2(1:iTrial))
%     drawnow
end
