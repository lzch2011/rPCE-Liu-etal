function cdfx = all_cdf(x, pdf, parameters, bounds)

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
    cdfx = (x - a)/(b - a);
elseif strcmpi(pdf,'gumbel')
    parameters = num2cell(parameters);
    if ~isempty(bounds)
        a = bounds(1);
        b = bounds(2);
        Fa = gumbel_cdf(a,parameters{:});
        Fb = gumbel_cdf(b,parameters{:});
        
        cdfx = gumbel_cdf(x,parameters{:});
        cdfx = (cdfx-Fa)/(Fb-Fa);
    else
        cdfx = gumbel_cdf(x,parameters{:});
    end
else
    parameters = num2cell(parameters);
    if ~isempty(bounds)
        a = bounds(1);
        b = bounds(2);
        Fa = cdf(pdf,a,parameters{:});
        Fb = cdf(pdf,b,parameters{:});
        
        cdfx = cdf(pdf,x,parameters{:});
        cdfx = (cdfx-Fa)/(Fb-Fa);
    else
        cdfx = cdf(pdf,x,parameters{:});
    end
end
