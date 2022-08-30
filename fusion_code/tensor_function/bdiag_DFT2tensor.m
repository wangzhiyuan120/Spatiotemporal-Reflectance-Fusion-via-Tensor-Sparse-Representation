function Y=bdiag_DFT2tensor(X,rows,cols,bands)

[r,c]=size(X);
n_r=r/rows;
n_c=c/cols;
data=mat2cell(X,ones(1,n_r)*rows,ones(1,n_c)*cols);
Y=zeros(rows,cols,bands);
for i=1:size(data,1)
    Y(:,:,i)=data{i,i};
end
Y=ifft(Y,[],3);

end