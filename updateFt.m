function [ Ft ] = updateFt( X, theta, T )
%UPDATEFT Summary of this function goes here
%   Detailed explanation goes here
    M= length(theta)-2;
    
    Ft = zeros(T+1,1);
    
    for i = 2:T+1,
        xt = [1; X(i-1:i+M-2); Ft(i-1)];
        Ft(i) = tanh(xt' * theta);
    end

end

