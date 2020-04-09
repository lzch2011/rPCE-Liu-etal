function eval=Legendre_unidim(X,degre_max)
eval=zeros(size(X,1),degre_max+1);

eval(:,1)= ones(size(X));
eval(:,2)= X;

for ii=2:degre_max
    eval(:,ii+1)=(1/ii)*((2*(ii-1)+1).*X.*eval(:,ii)-(ii-1).*eval(:,ii-1));
end