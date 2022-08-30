function [new_class_label]=K_means(data,k,change_threshold,iteration)
%data为输入图像数据
%k为分类后的cluster数
% change_threshold变化阈值
%iteration为迭代次数
[lines,columns,bands]=size(data);
tfl=lines*columns;
dat=zeros(tfl,bands);
for i=1:bands
    dat(:,i)=reshape(data(:,:,i),tfl,1);
end

old_seed=zeros(k,bands);
new_seed=zeros(k,bands);
%产生k个随机种子作为遥感图像类别的种子像元
index_record=zeros(1,k);
for i=1:k
    index_i=round(rand()*tfl);
    judge=find(index_record==index_i, 1);
    if isempty(judge)==0
        i=i-1;
        continue;
    end
    index_record(i)=index_i;
    %计算取得的随机值对应图像的行列号
    column_of_index_i=ceil(index_i/lines);
    line_of_index_i=index_i-(column_of_index_i-1)*lines;
    %存储种子像元的b个波段值
    old_seed(i,:)=data(line_of_index_i,column_of_index_i);
end

%下面进行迭代，如果本次分别所有类新得到的像元数目变化在change_threshold内，则认为分类完毕。
n=1;
new_class_label=zeros(lines,columns);
while n
    distance_matrix=zeros(lines,columns);
    for kind=1:k
        sum=0;
        for i=1:bands
            temp=power(data(:,:,i)-old_seed(kind,i),2);
            sum=sum+temp;
        end
        %每个像元与初始7个类别中心的欧式距离
        ou_distance=sqrt(sum);
        distance_matrix(:,:,kind)=ou_distance;
    end
    %给各类别赋值类别标注
    for i=1:lines
        for j=1:columns
            currentpixel_vector=distance_matrix(i,j,:);
            currentpixel_class=find(currentpixel_vector==min(currentpixel_vector));
            new_class_label(i,j)=currentpixel_class(1);
        end
    end
    %计算新的类中点
    for i=1:k
        id=find(new_class_label==i);
        for j=1:bands
            temp1=data(:,:,j);
            temp2=temp1(id);
            new_seed(i,j)=mean(temp2(:));
        end
    end
    %计算每个类的像素个数
    new_class_pixcel_number=zeros(1,k);
    for i=1:k
        new_class_pixcel_number(i)=length(find(new_class_label(:)==i));
    end
    %change_threshold:0.05
    if n==1
        old_class_pixcel_number=ones(1,k);
    end
    if max(abs(new_class_pixcel_number-old_class_pixcel_number)./old_class_pixcel_number)<change_threshold || n>=iteration
        break;
    else
        old_class_pixcel_number=new_class_pixcel_number;
        old_seed=new_seed;
    end
    n=n+1;
end
    
        