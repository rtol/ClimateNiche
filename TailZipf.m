function [KR KRsd SS1 SS2 SS2sd BF BFsd AM AMsd GI GIsd] = TailZipf(X,k);
% KR = Kratz and Resnick (Comm Stats C, 1995) estimator of tail index
% SS = Schulze and Steineback (Stats & Risk Mod, 1996) estimators
% BF = Brito and Freitas (Insurance: Math & Econ, 2003) estimators
% AB = Aban and Meerschaert (J Stat Plan & Inf, 2004) estimator
% GI = Gabaix and Ibragimov (J Bus Ec Stat, 2011) estimator
%
% X is a vector of observations in descending order, the k largest ones are
% used to estimate the tail-index
%
% First version: Richard Tol, 2 November 2019
% This version: Richard Tol, 29 February 2020

lnX = log(X);
n = length(X);
for j=1:k,
    lnj(j) = log((k+1)/j);
    lnn(j) = log(n/j);
    lnn2(j) = lnn(j)*lnn(j);
    lnn3(j) = log((j-0.5)/n);
end
SS1 = lnn*lnX(1:k) / sum(lnn2);

W = [ones(k,1) lnj'];
beta = inv(W'*W)*W'*lnX(1:k);
KR = 1/beta(2);
KRsd = sqrt(2)/beta(2)/sqrt(k);
W = [ones(k,1) lnX(1:k)];
beta = inv(W'*W)*W'*lnj';
SS2 = beta(2);
SS2sd = sqrt(2)*beta(2)/sqrt(k);
W = [ones(k,1) lnn3'];
beta = inv(W'*W)*W'*lnX(1:k);
AM = -1/beta(2);
AMsd = sqrt(2)/beta(2)/sqrt(k);
W = [ones(k,1) lnX(1:k)];
beta = inv(W'*W)*W'*lnn3';
GI = -beta(2);
GIsd = sqrt(2)*beta(2)/sqrt(k);
BF = 1/sqrt(1/KR/SS2);
BFsd = sqrt(2)/BF/sqrt(k);