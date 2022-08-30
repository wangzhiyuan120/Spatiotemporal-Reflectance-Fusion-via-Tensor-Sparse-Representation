function B=initB(Y,Dy,lambda_y)
%已知字典求稀疏表示
%张量运算

[~,~,bands_Dy]=size(Dy);
[~,~,bands_Y]=size(Y);


%求解birc_Dy
col_birc=cell(bands_Dy,1);
for i=1:bands_Dy
    col_birc{i}=Dy(:,:,i);
end
birc_Dy=col_birc;
for i=2:bands_Dy
    col_birc=circshift(col_birc,1);
    birc_Dy=[birc_Dy,col_birc];
end
birc_Dy=cell2mat(birc_Dy);
%求解unfold_Y
unfold_Y=cell(bands_Y,1);
for i=1:bands_Y
    unfold_Y{i}=Y(:,:,i);
end
unfold_Y=cell2mat(unfold_Y);

% bcirc(Dy)与unfold(Y)
param.mode=0;
param.lambda=lambda_y;
ufold_B=mexLasso(unfold_Y,birc_Dy,param);
r=size(Dy,2);
B=zeros(r,size(Y,2),size(Y,3));

index=1:r:(r*bands_Y);
for i=1:bands_Y
    id=index(i);
    B(:,:,i)=ufold_B( id:(id+r-1), : );
end




end