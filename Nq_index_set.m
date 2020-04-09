function [ alpha ] = Nq_index_set( M,p,q )

%{
We want here to obtain all the "multi-degrees" preserved when performing a
truncation of order p or involving the norm q (hyperbolic index)
The algorithm to obtain alpha involves:
-Algorithm H  (function algoH)
-Algorithm L (function algoL)
This algorithm was coded from G.Blatman's thesis (see appendix C,
"efficient generation of index sets")

input: - M = number of input variables
       - p = truncation order
       - q = norm used for truncation

We obtain at the output the set of degrees (a1, a2, ..., aM) satisfying:

       (a1 ^ q + a2 ^ q + ... + aM ^ q) ^ (1 / q) <= p

output: - alpha = matrix containing M rows with columns
         the multi-degrees preserved during truncation

Note: very fast function ...

%}

alpha=zeros(1,M);

for k=1:p

    ensemble=algoH( M,k,1 );  
    alpha_int = algoL( ensemble );
    alpha=[alpha;alpha_int];
    
    
    for j=2:min(k,M)
        
        ensemble = algoH( M,k,j );
        ensemble_test=ensemble.^q;
        ensemble_test=(sum(ensemble_test,2)).^(1/q);
        
        ensemble = ensemble((ensemble_test<=p),:);
        
        alpha_int=zeros(1,M);
        
        for i=1:size(ensemble,1)
            alpha_int = [alpha_int ; algoL( ensemble(i,:) )];
        end
        
        alpha_int(1,:)=[];
        
        alpha=[alpha;alpha_int];
        
    end
end

alpha=alpha';



