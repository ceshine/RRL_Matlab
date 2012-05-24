function [ Ret, sharp ] = rewardFunction( X, miu, delta, Ft, M)
%REWARDFUNCTION Summary of this function goes here
%   Detailed explanation goes here
    T = length(Ft)-1;

    Ret = miu * (Ft(1:T) .* X(M+1:M+T) - delta * abs(Ft(2:end)-Ft(1:T)));
    
    sharp = sharpRatio(Ret);
    
end

