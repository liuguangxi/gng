% CF_FIT    Fitting using order 2 polynomial
% Model: y = c2 * x^2 + c1 * x + c0

function c = cf_fit(x, y)

% Prepare data
[xData, yData] = prepareCurveData(x, y);


% Fitting
c = zeros(1, 3);
if (length(xData) == 1)
    c(1) = yData;
elseif (length(xData) == 2)
    c(2) = (yData(2)-yData(1)) / (xData(2)-xData(1));
    c(1) = yData(1) - c(2)*xData(1);
else    % length(xData) >= 3
    % Set up fittype and options.
    ft = fittype('poly2');
    opts = fitoptions(ft);
    opts.Lower = [-Inf -Inf -Inf];
    opts.Upper = [Inf Inf Inf];
    
    % Fit model to data
    fitresult = fit(xData, yData, ft, opts);
    c(1) = fitresult.p3;
    c(2) = fitresult.p2;
    c(3) = fitresult.p1;
end
