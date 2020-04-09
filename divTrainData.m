function [XFold,YFold]=divTrainData(XTrain,YTrain,nFold)

N = length(YTrain);
randIndex = randperm(N);
matrixIndex = repmat((1:nFold).',1,floor(N/nFold))+repmat((0:floor(N/nFold)-1)*nFold,nFold,1);
nRemData = mod(N,nFold);

YFold = cell(1,nFold);
XFold = cell(1,nFold);
for iFold = 1:nRemData
    selectIndex = matrixIndex(iFold,:);
    YFold{1,iFold}=[YTrain(randIndex(selectIndex));YTrain(randIndex(selectIndex(end)+nFold))];
    XFold{1,iFold}=[XTrain(randIndex(selectIndex),:);XTrain(randIndex(selectIndex(end)+nFold),:)];
end
for iFold = nRemData+1:nFold
    selectIndex = matrixIndex(iFold,:);
    YFold{1,iFold}=YTrain(randIndex(selectIndex));
    XFold{1,iFold}=XTrain(randIndex(selectIndex),:);
end
end