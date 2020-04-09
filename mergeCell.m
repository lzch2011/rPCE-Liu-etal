function S = mergeCell(S1,S2)

if size(S1) == size(S2)
    S = cell(size(S1));
    for ii = 1:size(S1,1)
        for jj = 1:size(S1,2)
            S{ii,jj} = [S1{ii,jj};S2{ii,jj}]; 
        end
    end
else
    error('The merged cells are not with same size!')
end