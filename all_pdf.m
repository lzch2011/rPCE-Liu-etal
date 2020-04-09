function y = all_pdf(X,pdfName,parameters,bounds)

if nargin==3
    bounds = [];
end
    
if strcmpi(pdfName,'gaussian')
    pdfName = 'normal';
end
    
if strcmpi(pdfName, 'uniform')
        a = bounds(1);
        b = bounds(2);
        y = 1/(b-a);
else 
    parameters = num2cell(parameters);
    if ~isempty(bounds)
        a = bounds(1);
        b = bounds(2);
        Fa = cdf(pdfName,a,parameters{:});
        Fb = cdf(pdfName,b,parameters{:});
        
        y = pdf(pdfName,X,parameters{:})+ (Fa+(1-Fb))/(b-a);
    else
        y = pdf(pdfName,X,parameters{:});
    end
end
