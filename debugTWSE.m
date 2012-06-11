clear
load('twse_ret.mat')
load('twse.mat')

M = 10; 
T = 100; % The number of time series inputs to the trader
N = 10;
miu = 1;
delta = 0;
 
theta = ones(M+2,1); % initialize theta

X = twse_ret(:); % truncate input data

Xn = featureNormalize(X);

%  Set options for fminunc
%options = optimset('GradObj', 'on', 'MaxIter', 100, 'PlotFcns', @optimplotfval); % for debugging
options = optimset('GradObj', 'on', 'MaxIter', 50);

 %Ft(T:T+N)
 pI = 1;
 fprintf('Start trading & re-training for %d runs.(%d trades for each run)\n', pI, N); 
 Ret = zeros(pI*N, 1);
 %size(Ret)
 Ft = zeros(pI*N, 1);
 for i = 0:pI-1,
     [theta, cost, EXITFLAG,OUTPUT] = fminunc(@(t)(costFunction(Xn(i*N+1:i*N+M+T), X(i*N+1:i*N+M+T), t)), theta, options);
     
     Ftt = updateFt(Xn(T+i*N:T+(i+1)*N+M), theta, N);
    % X(T+i*N:T+(i+1)*N+M)
     [Rett, sharp] = rewardFunction(X(T+i*N+1:T+(i+1)*N+M), miu, delta, Ftt, M);
     %Rett = Rett + 1;
     Ret(i*N+1:(i+1)*N) = Rett;
     
     %for j = i*N+1:(i+1)*N,
     %    if j-1 ~= 0,
     %        Ret(j) = Ret(j-1)*Ret(j); 
     %    end
     %end
     
     Ft(i*N+1:(i+1)*N) = Ftt(2:end);  
     
 end
plot(twse(1:M+T));
figure('Name','Trading & Re-training Results','NumberTitle','off');
subplot(3,1,1);
D = X(M+T+1:M+T+pI*N);
hold on;
line([1 10], [0 0]);
plot(D);
axis([1, pI*N, min(D), max(D)]);
%axis([0, pI*N, min(D)*0.95, max(D)*1.05]);
subplot(3,1,2);
plot(Ft(:));
title('Position');
axis([1, length(Ft), -1.05, 1.05]);
subplot(3,1,3);
plot(Ret(:));
title('Returns');
axis([1, length(Ret), min(Ret), max(Ret)]);