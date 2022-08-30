function img=patches2img(data,rows,cols,bands,width_of_patches)
% data是一个多光谱图像
%width_of_patches是每个块的宽度
%patches是一个矩阵，每行表示一个patch
%data必须能够整除width
%Authors WANG ZHI YUAN
img=zeros(rows,cols,bands);

num_of_rows=rows/width_of_patches;
num_of_cols=cols/width_of_patches;

n=1;
for j=1:num_of_cols
    for i=1:num_of_rows
        idx=(j-1)*width_of_patches;
        idy=(i-1)*width_of_patches;
        m=1;
        for ii=1:width_of_patches
            for jj=1:width_of_patches
                if bands==1
                     img(idy+ii,idx+jj,:)=data(n,1);
                else
                img(idy+ii,idx+jj,:)=data(n,m:m+bands-1);
                m=m+bands;
                end
            end
        end
        n=n+1;
    end
end
if bands==1
    img=img(:,:,1);
end


end