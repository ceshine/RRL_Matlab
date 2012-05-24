function [ sharp ] = sharpRatio( Ret )
%SHARPRATIO Summary of this function goes here
%   Detailed explanation goes here

    T = length(Ret);
    ER = sum(Ret) / T;
    ERS = sum(Ret.^2) / T;
    sharp = ER / sqrt(ERS-ER^2);

end

