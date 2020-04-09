function [Q2,err] = computeLOOError(Psi,Y,beta,PSINew)

N = length(Y);

if nargin == 3
    PSINew = sqrt(size(Psi,2))*eye(size(Psi,2));
end


[U,~,~]=svd(Psi);

Id = eye(size(Psi,1));
if size(Psi,2) < size(Psi,1)
    Id(size(Psi,2)+1:end,size(Psi,2)+1:end)=0;
end
% INV=inv(PSI'*PSI);
Diag=diag(U*Id*U');
hi=1-Diag;

err = mean(((Y-Psi*beta)./hi).^2);

covPSI = (Psi.'*Psi)/N;
covPSINew = (PSINew.'*PSINew)/size(PSINew,1);
err = err * N*(1+trace(pinv(covPSI)*covPSINew)/N)/(N-size(Psi,2));

Q2 = 1-err/var(Y,1,1);



