function [Q2,err] = computekFoldError(Psi,Y,nFold,nTimeCV,PSINew)

N = length(Y);

if nargin == 2
    nFold = N;
    nTimeCV = 1;
    PSINew = eye(size(Psi,2));
elseif nargin == 3
    nTimeCV = 1;
    PSINew = sqrt(size(Psi,2))*eye(size(Psi,2));
elseif nargin == 4
    PSINew = sqrt(size(Psi,2))*eye(size(Psi,2));
end


if nFold == N
    if size(Psi,1)==size(Psi,2)
        Y_predic = zeros(length(Y),1);
        for iSample = 1:length(Y)
            indexTraining = setdiff(1:length(Y),iSample);
            PsiTraning = Psi(indexTraining,:);
            iBeta=(PsiTraning.'*PsiTraning)\(PsiTraning.'*Y(indexTraining));
            
            Y_predic(iSample) = Psi(iSample,:)*iBeta;
        end
        
        err = mean((Y_predic-Y).^2);
        
    else
        [U,S,V]=svd(Psi);
        
        Id = eye(size(Psi,1));
        if size(Psi,2) < size(Psi,1)
            Id(size(Psi,2)+1:end,size(Psi,2)+1:end)=0;
        end
        % INV=inv(PSI'*PSI);
        Diag=diag(U*Id*U');
        hi=1-Diag;
        
        beta = (Psi.'*Psi)\(Psi.'*Y);
        err = mean(((Y-Psi*beta)./hi).^2);
        
    end
else
    % dividing data into k groups, which have similar size
    err = zeros(1,nTimeCV);
    for iTime = 1:nTimeCV
%         fprintf(sprintf('the %d-th CV\n',iTime))
        randIndex = randperm(N);
        
        matrixIndex = repmat((1:nFold).',1,floor(N/nFold))+repmat((0:floor(N/nFold)-1)*nFold,nFold,1);
        nRemData = mod(N,nFold);
        
        YFold = cell(1,nFold);
        PSIFold = cell(1,nFold);
        for iFold = 1:nRemData
            selectIndex = matrixIndex(iFold,:);
            YFold{1,iFold}=[Y(randIndex(selectIndex));Y(randIndex(selectIndex(end)+nFold))];
            PSIFold{1,iFold}=[Psi(randIndex(selectIndex),:);Psi(randIndex(selectIndex(end)+nFold),:)];
        end
        for iFold = nRemData+1:nFold
            selectIndex = matrixIndex(iFold,:);
            YFold{1,iFold}=Y(randIndex(selectIndex));
            PSIFold{1,iFold}=Psi(randIndex(selectIndex),:);
        end
        
        GError = zeros(nFold,1);
        for iFold = 1:nFold
            PSI_val = PSIFold{1,iFold};
            Y_val = YFold{1,iFold};
            trainFold = setdiff(1:nFold,iFold);
            PSI_train = zeros(N-length(Y_val),size(PSI_val,2));
            Y_train = zeros(N-length(Y_val),1);
            nRow = 0;
            for iTrainData = 1:nFold-1
                indFold = trainFold(iTrainData);
                iPSI = PSIFold{1,indFold};
                iY = YFold{1,indFold};
                indRow = nRow + (1:length(iY));
                PSI_train(indRow,:) =iPSI;
                Y_train(indRow) = iY;
                nRow = nRow + length(iY);
            end
            
            beta = (PSI_train.'*PSI_train)\(PSI_train.'*Y_train);
            GError(iFold)=sum((PSI_val*beta-Y_val).^2);
        end
        err(iTime) = sum(GError)/length(Y);
    end
    err = mean(err);
end

covPSI = (Psi.'*Psi)/N;
covPSINew = (PSINew.'*PSINew)/size(PSINew,1);
err = err * N*(1+trace(pinv(covPSI)*covPSINew)/N)/(N-size(Psi,2));

Q2 = 1-err/var(Y,1,1);



