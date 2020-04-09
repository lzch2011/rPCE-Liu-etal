function [firstOrderSobol_GFun,totalSobol_GFun] = referenceSobolGFun(alpha)

iD = 1./(3*(1+alpha).^2);
D = prod(1+iD)-1;
firstOrderSobol_GFun = iD/D;

nVar = length(alpha);
totalSobol_GFun = firstOrderSobol_GFun;

for iVar = 1:nVar
    varVariab = setdiff(1:nVar,iVar);
    for nIter = 1:(nVar-1)
        combos = combntns(1:(nVar-1),nIter);
        for iR = 1:size(combos,1)
            iSobol = prod(iD([varVariab(combos(iR,:)),iVar]))/D;
            totalSobol_GFun(iVar) = totalSobol_GFun(iVar)+ iSobol;
        end
    end
end