clear
load('retDAX.txt')
load('DAX.txt')

M = 10; 
T = 1000; % The number of time series inputs to the trader

X = retDAX(1:M+T); % truncate input data

Xn = featureNormalize(X);

debug_theta = zeros(M+2,1); % initialize theta
debug_theta = reshape(sin(1:numel(debug_theta)), size(debug_theta));

[J, grad] = costFunction(Xn, X, debug_theta);

costFunc = @(p) costFunction(Xn, X, p);

numgrad = getNumericalGradient(costFunc, debug_theta);

disp([numgrad grad]);

