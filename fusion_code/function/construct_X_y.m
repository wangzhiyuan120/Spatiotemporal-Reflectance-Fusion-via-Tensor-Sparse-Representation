function [X,y]=construct_X_y(NSCT_X,NSCT_Y)
%构造LSR中心向量y和HSR向量块X

[rows_x,cols_x,bands_x]=size(NSCT_X);
[rows_y,cols_y,bands_y]=size(NSCT_Y);
if rows_x==0
    X=[];
    y=[];
    return;
end

%沿模式1矩阵化NSCT X,Y
X_1=reshape(NSCT_X,rows_x,cols_x*bands_x);
Y_1=reshape(NSCT_Y,rows_y,cols_y*bands_y);

%中心点像素集合y
index_cols=(cols_y/2):cols_y:(cols_y*bands_y-cols_y/2);
y_t=Y_1(:,index_cols);
for i=1:size(y_t,1)
    y{i}=y_t(i,:);
end
y=cell2mat(y);

%中心块集合X
t=zeros(1,bands_x);
m=zeros(cols_x,bands_x);
X=zeros(cols_x,rows_x*bands_x);
for k=1:rows_x

    for i=1:cols_x
        for j=1:bands_x
            t(1,j)=X_1(k,i+(j-1)*cols_x);
        end
        m(i,:)=t;
    end
    
    kk=1+(k-1)*bands_x;
    X(:,kk:(kk+bands_x-1))=m;
end


end