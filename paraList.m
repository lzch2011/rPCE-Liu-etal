function [pdfs,parameters, bounds] = paraList(funName)

parameters = [];
bounds = [];
switch lower(funName)
    case 'borehole'
        pdfs = cell(1,8);
        parameters = cell(1,8);
        bounds = cell(1,8);
        
        pdfs{1,1} = 'Gaussian';
        parameters{1,1}=[0.10, 0.0161812];
        bounds{1,1}=[0.05, 0.15];
        
        pdfs{1,2} = 'Lognormal';
        parameters{1,2}=[7.71 1.0056];
        bounds{1,2}=[100, 50000];
        
        for ii = 3 : 8
            pdfs{1,ii} = 'Uniform' ;
        end
        parameters{1,3}=[63070, 115600];
        parameters{1,4}=[990, 1110];
        parameters{1,5}=[63.1, 116];
        parameters{1,6}=[700, 820];
        parameters{1,7}=[1120, 1680];
        parameters{1,8}=[1500, 15000];
    case 'ishigami'
        pdfs = cell(1,3);
        parameters = cell(1,3);
        for ii = 1 : 3
            pdfs{1,ii} = 'Uniform' ;
            parameters{1,ii} = [-pi, pi] ;
        end
end

