function [curves gofs] = allfitlines(x, y, varargin)
%ALLFITLINES Fit all valid lines to data
%   [D PD] = ALLFITDIST(DATA) fits all valid parametric probability
%   distributions to the data in vector DATA, and returns a struct D of
%   fitted distributions and parameters and a struct of objects PD
%   representing the fitted distributions. PD is an object in a class
%   derived from the ProbDist class.
%
%   [...] = ALLFITDIST(DATA,SORTBY) returns the struct of valid distributions
%   sorted by the parameter SORTBY
%        NLogL - Negative of the log likelihood
%        BIC - Bayesian information criterion (default)
%        AIC - Akaike information criterion
%        AICc - AIC with a correction for finite sample sizes
%
%   [...] = ALLFITDIST(...,'DISCRETE') specifies it is a discrete
%   distribution and does not attempt to fit a continuous distribution
%   to the data
%
%   [...] = ALLFITDIST(...,'PDF') or (...,'CDF') plots either the PDF or CDF
%   of a subset of the fitted distribution. The distributions are plotted in
%   order of fit, according to SORTBY.
%
%   List of distributions it will try to fit
%     Continuous (default)
%       Beta
%       Birnbaum-Saunders
%       Exponential
%       Extreme value
%       Gamma
%       Generalized extreme value
%       Generalized Pareto
%       Inverse Gaussian
%       Logistic
%       Log-logistic
%       Lognormal
%       Nakagami
%       Normal
%       Rayleigh
%       Rician
%       t location-scale
%       Weibull
%
%     Discrete ('DISCRETE')
%       Binomial
%       Negative binomial
%       Poisson
%
%   Optional inputs:
%   [...] = ALLFITDIST(...,'n',N,...)
%   For the 'binomial' distribution only:
%      'n'            A positive integer specifying the N parameter (number
%                     of trials).  Not allowed for other distributions. If
%                     'n' is not given it is estimate by Method of Moments.
%                     If the estimated 'n' is negative then the maximum
%                     value of data will be used as the estimated value.
%   [...] = ALLFITDIST(...,'theta',THETA,...)
%   For the 'generalized pareto' distribution only:
%      'theta'        The value of the THETA (threshold) parameter for
%                     the generalized Pareto distribution. Not allowed for
%                     other distributions. If 'theta' is not given it is
%                     estimated by the minimum value of the data.
%
%   Note: ALLFITDIST does not handle nonparametric kernel-smoothing,
%   use FITDIST directly instead.
%
%
%   EXAMPLE 1
%     Given random data from an unknown continuous distribution, find the
%     best distribution which fits that data, and plot the PDFs to compare
%     graphically.
%        data = normrnd(5,3,1e4,1);         %Assumed from unknown distribution
%        [D PD] = allfitdist(data,'PDF');   %Compute and plot results
%        D(1)                               %Show output from best fit
%
%   EXAMPLE 2
%     Given random data from a discrete unknown distribution, with frequency
%     data, find the best discrete distribution which would fit that data,
%     sorted by 'NLogL', and plot the PDFs to compare graphically.
%        data = nbinrnd(20,.3,1e4,1);
%        values=unique(data); freq=histc(data,values);
%        [D PD] = allfitdist(values,'NLogL','frequency',freq,'PDF','DISCRETE');
%        PD{1}
%
%  EXAMPLE 3
%     Although the Geometric Distribution is not listed, it is a special
%     case of fitting the more general Negative Binomial Distribution. The
%     parameter 'r' should be close to 1. Show by example.
%        data=geornd(.7,1e4,1); %Random from Geometric
%        [D PD]= allfitdist(data,'PDF','DISCRETE');
%        PD{1}
%
%  EXAMPLE 4
%     Compare the resulting distributions under two different assumptions
%     of discrete data. The first, that it is known to be derived from a
%     Binomial Distribution with known 'n'. The second, that it may be
%     Binomial but 'n' is unknown and should be estimated. Note the second
%     scenario may not yield a Binomial Distribution as the best fit, if
%     'n' is estimated incorrectly. (Best to run example a couple times
%     to see effect)
%        data = binornd(10,.3,1e2,1);
%        [D1 PD1] = allfitdist(data,'n',10,'DISCRETE','PDF'); %Force binomial
%        [D2 PD2] = allfitdist(data,'DISCRETE','PDF');       %May be binomial
%        PD1{1}, PD2{1}                             %Compare distributions
%

%    Michael Jensen
%    Last Modified: 17-May-2015

D = cell(0,0);
curves = {};
gofs = {};
%% Run through all CurveFits in Fit function
%warning('off','all'); %Turn off all future warnings
curveName = {'poly1','poly2','poly3',...
    'weibull','exp1','exp2',...
    'fourier1','fourier2','fourier3','gauss1',...%'gauss2','gauss3',...
    'power1','power2','sin1','sin2','sin3',...%'cubicspline',...
    'smoothingspline'};%,...%'linearinterp',...
    %'cubicinterp','pchipinterp'};
for indx=1:length(curveName)
    %try
        cType=curveName{indx};
        
        [curves{end+1} gofs{end+1}] = fit(x,y,cType);
        
        %k=numel(PD.Params); %Number of parameters
        %D(num).curveName=curve.curveName;
        %D(num).NLogL=NLL;
        %D(num).BIC=-2*(-NLL)+k*log(n);
        %D(num).AIC=-2*(-NLL)+2*k;
        %D(num).AICc=(D(num).AIC)+((2*k*(k+1))/(n-k-1));
        %D(num).ParamNames=PD.ParamNames;
        %D(num).ParamDescription=PD.ParamDescription;
        %D(num).Params=PD.Params;
        %D(num).Paramci=PD.paramci;
        %D(num).ParamCov=PD.ParamCov;
        %D(num).Support=PD.Support;
    %catch err %#ok<NASGU>
        %Ignore distribution
    %end
end
warning('on','all'); %Turn back on warnings
if numel(curves)==0
    error('ALLFITLINE:NoLine','No curveFits were found');
end
[curves gofs] = sortCurveByError('sse', curves, gofs);


end


function [curves gofs] = sortCurveByError(errorCriteria, curves, gofs)

indx1=1:length(gofs); %Identity Map
errorNums(length(gofs)) = 0;
for indx1=1:length(curves)
    errorNums(indx1) = getfield(cell2mat(gofs(indx1)),errorCriteria);
end
[~,indx1]=sort([errorNums]);
curves=curves(indx1);
gofs=gofs(indx1);
end
    

