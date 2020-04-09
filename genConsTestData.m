function [XCons,YCons,XTest,YTest] = genConsTestData(XFold,YFold,iFold,nTrainData)

nFold = length(YFold);
XTest = XFold{1,iFold};
YTest = YFold{1,iFold};
consFold = setdiff(1:nFold,iFold);
XCons = zeros(nTrainData-length(YTest),size(XTest,2));
YCons = zeros(nTrainData-length(YTest),size(YTest,2));

nRow = 0;
for iConsData = 1:nFold-1
    indFold = consFold(iConsData);
    iXCons = XFold{1,indFold};
    iYCons = YFold{1,indFold};
    indRow = nRow + (1:length(iYCons));
    XCons(indRow,:) = iXCons;
    YCons(indRow,:) = iYCons;
    nRow = nRow + size(iYCons,1);
end
end