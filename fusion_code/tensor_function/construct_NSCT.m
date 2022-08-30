function NSCT_of_clusteri=construct_NSCT(data,width_of_patch,labels,cluster_i)
%data为原始多光谱数据
%width_of_patch为patch的宽度
%labels为2维，它的前两维必须与data大小相同
%Authors WANG ZHI YUAN

[rows,cols,bands]=size(data);
id_rows=1:width_of_patch:rows;
id_cols=1:width_of_patch:cols;
%用于获取同一类的mask
mask=labels(id_rows,id_cols)==cluster_i;
%g构造的NSCT的非局部维度大小
n_rows=length(find(mask==1));
%注意此NSCT的结构，NSCT(i,:,:)是一个bands行，（rows*cols)列的矩阵，每列表示一个像素的光谱值
NSCT_of_clusteri=zeros(n_rows,width_of_patch*width_of_patch,bands);
%构建NSCT
m=1;
 for i=1:size(mask,1)
    for j=1:size(mask,2)
        if mask(i,j)==1
            id_row=id_rows(i);
            id_col=id_cols(j);
            cube=data(id_row:id_row+width_of_patch-1,id_col:id_col+width_of_patch-1,:);
            NSCT_of_clusteri(m,:,:)=reshape(cube,width_of_patch*width_of_patch,[]);
            m=m+1;
        end      
    end      
end

end