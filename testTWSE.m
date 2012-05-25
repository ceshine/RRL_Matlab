clear
load('twse_ret.mat')
load('twse.mat')

M = 5; 
T = 100; % The number of time series inputs to the trader
N = 10;

 
initial_theta = ones(M+2,1); % initialize theta

X = twse_ret(:); % truncate input data

Xn = featureNormalize(X);

fprintf('Conducting first training...\n');

%Ft = zeros(T+1,1);

%[Ret, sharp] = rewardFunction(X, miu, delta, Ft)

%Ft = [0; ones(M,1)]

%[Ret, sharp] = rewardFunction(X, miu, delta, Ft)

 %[ theta, U_history ] = gradientAscent(X, Ft, miu, delta, theta, alpha, num_iters, T);
 %plot(U_history)

 %  Set options for fminunc
%options = optimset('GradObj', 'on', 'MaxIter', 100, 'PlotFcns', @optimplotfval); % for debugging
options = optimset('GradObj', 'on', 'MaxIter', 50);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 
[theta, cost, EXITFLAG,OUTPUT] = fminunc(@(t)(costFunction(Xn(1:M+T), X(1:M+T), t)), initial_theta, options);


Ft = updateFt(Xn(1:M+T), theta, T);

miu = 1;
delta = 0.001;

[Ret, sharp] = rewardFunction(X(1:M+T), miu, delta, Ft, M);
Ret = Ret + 1;
%size(Ret), size(Ft)
for i = 2:length(Ret),
    Ret(i) = Ret(i-1)*Ret(i); 
end

figure('Name','First Training Results','NumberTitle','off');
subplot(3,1,1);
plot(twse(M+2:M+T+2));
axis([0, T, min(twse(M+2:M+T+2))*0.95, max(twse(M+2:M+T+2))*1.05]);
title('Taiwan Weighted Index');
subplot(3,1,2);
plot(Ft(2:end));
axis([0, length(Ft)-1, -1.05, 1.05]);
title('Position');
subplot(3,1,3);
plot(Ret(:));
axis([0, length(Ret), min(Ret), max(Ret)]);
title('Return');

%fprintf('Program paused. Press enter to continue.\n');
%pause;


 %Ft(T:T+N)
 figure(1);
 pI = 10;
 fprintf('Start trading & re-training for %d runs.(%d trades for each run)\n', pI, N); 
 Ret = zeros(pI*N, 1);
 %size(Ret)
 Ft = zeros(pI*N, 1);
 for i = 0:pI-1,
     if i > 0,
        [theta, cost, EXITFLAG,OUTPUT] = fminunc(@(t)(costFunction(Xn(i*N+1:i*N+M+T), X(i*N+1:i*N+M+T), t)), theta, options);
     end
     
     Ftt = updateFt(Xn(T+i*N:T+(i+1)*N+M), theta, N);
     
     [Rett, sharp] = rewardFunction(X(T+i*N+1:T+(i+1)*N+M), miu, delta, Ftt, M);
     Rett = Rett + 1;
     Ret(i*N+1:(i+1)*N) = Rett;
     
     for j = i*N+1:(i+1)*N,
         if j-1 ~= 0,
             Ret(j) = Ret(j-1)*Ret(j); 
         end
     end
     
     Ft(i*N+1:(i+1)*N) = Ftt(2:end);
     
 end
 
figure('Name','Trading & Re-training Results','NumberTitle','off');
subplot(3,1,1);
D = twse(M+T+2:M+T+1+pI*N);
plot(D);
title('Taiwan Weighted Index');
axis([0, pI*N, min(D)*0.95, max(D)*1.05]);
subplot(3,1,2);
plot(Ft(:));
title('Position');
axis([1, length(Ft), -1.05, 1.05]);
subplot(3,1,3);
plot(Ret(:));
title('Returns');
axis([1, length(Ret), min(Ret), max(Ret)]);