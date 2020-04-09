function [ alpha ] = algoH( M,p,j )

%%%%%%%% Algorithm H

if j==1
    alpha=[zeros(1,M-j) p];
else


% initialize
vec(1)=p-j+1;
vec(2:j)=1;
vec(j+1)=-1;
alpha=[zeros(1,M-j) vec(1:j)];

while vec(2)<vec(1)-1
    vec(1)=vec(1)-1;
    vec(2)=vec(2)+1;
    alpha=[alpha;[zeros(1,M-j) vec(1:j)]];
end

k=3;
s=vec(1)+vec(2)-1;

while vec(k)>=vec(1)-1
    s=s+vec(k);
    k=k+1;
end

while k<=j
    x=vec(k)+1;
    vec(k)=x;
    k=k-1;
    
    while k>1
        vec(k)=x;
        s=s-x;
        k=k-1;
    end
    
    vec(1)=s;
    
    alpha=[alpha;[zeros(1,M-j) vec(1:j)]];
    
    while vec(2)<vec(1)-1
        vec(1)=vec(1)-1;
        vec(2)=vec(2)+1;
        alpha=[alpha;[zeros(1,M-j) vec(1:j)]];
    end
    
    k=3;
    s=vec(1)+vec(2)-1;
    
    while vec(k)>=vec(1)-1
        s=s+vec(k);
        k=k+1;
    end
end

end