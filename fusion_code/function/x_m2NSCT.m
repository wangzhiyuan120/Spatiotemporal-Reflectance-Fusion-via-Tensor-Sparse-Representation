function X=x_m2NSCT(x_m,rows,cols,bands)

[~,c]=size(x_m);
X=zeros(rows,cols,bands);
n_cell=c/bands;

x_c=mat2cell(x_m,cols,ones([1 n_cell])*bands);

for i=1:rows
    X(i,:,:)=x_c{i};
end







end