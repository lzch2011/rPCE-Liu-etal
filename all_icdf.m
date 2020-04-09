function icdfx = all_icdf(x,pdf,parameters,bounds)

if nargin==3
    bounds = [];
end
    
if strcmpi(pdf,'gaussian')
    pdf = 'normal';
end

if strcmpi(pdf, 'uniform')
    if isempty(bounds)
        a = parameters(1);
        b = parameters(2);
    else
        a = bounds(1);
        b = bounds(2);
    end
    icdfx = x*(b-a)+a;
else
    parameters = num2cell(parameters);
    if ~isempty(bounds)
        Fa = cdf(pdf,bounds(1),parameters{:});
        Fb = cdf(pdf,bounds(2),parameters{:});
        
        icdfx = x*(Fb-Fa)+Fa;
        icdfx = icdf(pdf,icdfx,parameters{:});
    else
        icdfx = icdf(pdf,x,parameters{:});
    end
end
