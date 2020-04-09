function [AB] = arbitrary_ml_integrator(maxdeg, Wx, bounds, CDFquantiles)

if ~exist('CDFquantiles','var')
    integral_fun = @(fun,bounddown,boundup) integral(fun,bounddown,boundup);
else
    integral_fun = @(fun,bounddown,boundup) integral(fun,bounddown,boundup,'Waypoints',CDFquantiles);
end

%% The AB matrix:
% No preallocation of AB is necessary since the function that uses it to
% calculate the polynomials (uq_eval_rec_rule) uses the size of the matrix
% to infer the requested degree. The matrix is not huge anyway so this is
% not a significant performance hit.
b0 = integral_fun(@(x) Wx(x')' , bounds(1),bounds(2));
AB = [0 sqrt(b0)];



%% calculate recurrence coefficients up to the requested degree:
for ii=1:(maxdeg+1)
    % Evaluate the polynomials with the recurrence rule
    a_num_new = @(x) Wx(x')' .* x .* uq_eval_rec_rule(x', AB, 1)'.^2 ;
    a_num_int_new = integral_fun(a_num_new,bounds(1),bounds(2));

    an_new = a_num_int_new ;
    
    AB(ii,1) = an_new;
    
    %% Please insert clearer comments
    % I need to increment AB here.
    % I need a non-normalized b_n for 
    % <p_{n+1},p_{n+1}> 
    AB = [AB ; 0 1];
    
    %% Computation of the P_k+1 non normalized polynomial
    P_k_plus_one= @(x) uq_eval_rec_rule(x',AB(1:(end),:),1)';
    
    %% Find b_k+1 for the next iteration from the normalization
    bn_plus_one_new = integral_fun(@(x) Wx(x')' .* P_k_plus_one(x).^2, ...
        bounds(1),bounds(2));
    
    % Store the recursion coefficient:
    AB(end,2) = sqrt(bn_plus_one_new);
    
end

% Remove the last row because it contains useless (incomplete) info
AB = AB(1:end-1,:);
if any(any(isnan(AB)))
    deg =     find(isnan(AB(:,1)));
    error(sprintf('The integration for the recurrence coefficients returned NaN for degree %d!\n',deg));
end
% And because we integrate for a PDF:
AB(1,2) = 1;