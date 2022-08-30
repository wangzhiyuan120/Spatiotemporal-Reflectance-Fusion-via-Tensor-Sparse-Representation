function Y=tensor2bdiag_DFT(X)
%在第三维度，对X进行离散傅里叶变换得到X_DFT
%Y=bdiag(X_DFT)

X_DFT=fft(X,[],3);

k=size(X_DFT,3);
X_t=X_DFT(:,:,1);
for i=2:k
    X_i=X_DFT(:,:,i);
    Y=blkdiag(X_t,X_i);
    X_t=Y;
end



end