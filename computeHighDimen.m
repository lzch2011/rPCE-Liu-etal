function Y = computeHighDimen(X)

global nSim

nSim = nSim + size(X,1);

M = size(X,2);
Y = 3-5/M*X*(1:M)'+1/M*(X.^3)*(1:M)'+log(1/(3*M)*(X.^2+X.^4)*(1:M)')+...
    X(:,1).*(X(:,2).^2)-X(:,5).*X(:,3)+X(:,2).*X(:,4)+X(:,M-4)+X(:,M-4).*(X(:,M).^2);