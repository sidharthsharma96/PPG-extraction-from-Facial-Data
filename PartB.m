clc;
clear all;
clear;

fps=15;

load img.mat
load vec.mat
load l.mat
load w.mat

[X Y Z]=pca(vec);

mu = mean(vec);

approx = Y(:,1:5) * X(:,1:5)';
approx = bsxfun(@plus,mu,approx);


[len wid]=size(vec);
d=1;
for i=1:len
    recon=reshape(approx(i,:),l,w);
    imag=img(:,:,d);
    dif =recon - imag;
    
    sig(i)=mean(mean(dif));
    d=d+1;
end

figure(1)
plot(sig)


sig1 = sig - mean (sig );    % cancel DC conponents
sig1 = sig1/ max( abs(sig1 )); % normalize to one
% LPF (1-z^-6)^2/(1-z^-1)^2
b=[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];
h_LP=filter(b,a,[1 zeros(1,12)]);

% transfer function of LPF

x2p1 = conv (sig1 ,h_LP);
%x2 = x2 (6+[1: N]); %cancle delay
x2p1 = x2p1/ max( abs(x2p1 )); % normalize , for convenience .
save x2p1 x2p1
figure(2)
plot(x2p1)