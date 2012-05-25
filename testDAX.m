clear
load('retDAX.txt')
load('DAX.txt')

M = 10; 
T = 500; % The number of time series inputs to the trader
N = 100;

 
initial_theta = ones(M+2,1); % initialize theta

X = retDAX(:); % truncate input data

Xn = featureNormalize(X);

%Ft = zeros(T+1,1);

%[Ret, sharp] = rewardFunction(X, miu, delta, Ft)

%Ft = [0; ones(M,1)]

%[Ret, sharp] = rewardFunction(X, miu, delta, Ft)

 %[ theta, U_history ] = gradientAscent(X, Ft, miu, delta, theta, alpha, num_iters, T);
 %plot(U_history)

 %  Set options for fminunc
options = optimset('GradObj', 'on', 'MaxIter', 1000, 'PlotFcns', @optimplotfval);

%  Run fminunc to obtain the optimal theta
%  This function will return theta and the cost 
[theta, cost, EXITFLAG,OUTPUT] = fminunc(@(t)(costFunction(Xn(1:M+T), X(1:M+T), t)), initial_theta, options)


Ft = updateFt(Xn(1:M+T), theta, T);

miu = 1;
delta = 0.001;

[Ret, sharp] = rewardFunction(X(1:M+T), miu, delta, Ft, M);
Ret = Ret + 1;
%size(Ret), size(Ft)
for i = 2:length(Ret),
    Ret(i) = Ret(i-1)*Ret(i); 
end

subplot(3,1,1);
plot(DAX(M+2:M+T+2));
axis([0, T, min(DAX(M+2:M+T+2))*0.95, max(DAX(M+2:M+T+2))*1.05]);
subplot(3,1,2);
plot(Ft(2:end));
axis([0, length(Ft)-1, -1.05, 1.05]);
subplot(3,1,3);
plot(Ret(:));
axis([0, length(Ret), min(Ret), max(Ret)]);
 
pause;

 %Ft(T:T+N)
 
 pI = 1;
 Ret = zeros(pI*N, 1);
 %size(Ret)
 Ft = zeros(pI*N, 1);
 for i = 0:pI-1,
     Ftt = updateFt(Xn(T+i*N:T+(i+1)*N+M), theta, N);
     
     [Rett, sharp] = rewardFunction(X(T+i*N:T+(i+1)*N+M), miu, delta, Ftt, M);
     Rett = Rett + 1;
     Ret(i*N+1:(i+1)*N) = Rett;
     
     for j = i*N+1:(i+1)*N,
         if j-1 ~= 0,
             Ret(j) = Ret(j-1)*Ret(j); 
         end
     end
     
     Ft(i*N+1:(i+1)*N) = Ftt(2:end);
     
     [theta, cost, EXITFLAG,OUTPUT] = fminunc(@(t)(costFunction(Xn(i*N+1:i*N+M+T), X(i*N+1:i*N+M+T), t)), theta, options);
 end
 
figure(2);
subplot(3,1,1);
D = DAX(M+T+3:M+T+2+pI*N);
plot(D);
axis([0, pI*N, min(D)*0.95, max(D)*1.05]);
subplot(3,1,2);
plot(Ft(2:end));
axis([0, length(Ft)-1, -1.05, 1.05]);
subplot(3,1,3);
plot(Ret(:));
axis([0, length(Ret), min(Ret), max(Ret)]);