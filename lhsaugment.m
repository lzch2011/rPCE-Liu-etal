function lhsaug=lhsaugment(LHS,m)

% This function from an existing LHS adds points to this LHS while
% retaining its LHS configuration
%
% Inputs: - LHS: Npts-by-Ndim matrix of an LHS experiment plan
%         - m: number of points to add to the LHS
%
% Outputs: - lshaug: LHS (Npts + m) -by-Ndim matrix increased

K=size(LHS,2); 
N=size(LHS,1);

colvec=rank(rand(K,1));
colvec=colvec';
rowvec=rank(rand(N+m,1));
rowvec=rowvec';

B=zeros(m,K);

for j=colvec
    newrow=0;
    for i = rowvec
        if (any(LHS(:,j)>=(i-1)/(N+m) & LHS(:,j)<= i/(N+m)) == 0)
            newrow=newrow+1;
            B(newrow,j)=(i-1)/(N+m)+rand/(N+m);
        end
    end
end

lhsaug=[LHS;B(1:m,:)];
end



function r=rank(x)

% Similar to tiedrank, but no adjustment for ties here
[sx, rowidx] = sort(x);
r(rowidx) = 1:length(x);
r = r(:);
end