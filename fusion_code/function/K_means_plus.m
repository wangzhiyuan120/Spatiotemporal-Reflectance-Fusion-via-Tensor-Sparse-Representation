function [new_class_label, Central_Position]=K_means_plus(data,k,change_threshold,iteration)
%data为输入图像数据
%k为分类后的cluster数
% change_threshold变化阈值
%iteration为迭代次数
%Authors WANG ZHI YUAN

[samples,arrtibutes]=size(data);
old_seed=zeros(k,arrtibutes);
new_seed=zeros(k,arrtibutes);

%%
%存储中心点
index_record=zeros(1,k);
%随机初始化第一个点
index_1=round(rand()*samples);
index_record(1)=index_1;


old_seed(1,:)=data(index_1,:);
%使用k-means++方法计算剩余的k-1个中点
for i=2:k
    dist=zeros(samples,1);
    for p=1:samples
        point=data(p,:);
        d=realmax;
        for j=1:i-1
             temp_dist=point-data(index_record(j),:);
             temp_dist=dot(temp_dist,temp_dist);
             d=min(d,temp_dist);
        end
        dist(p)=d;
    end
    [~,posion]=max(dist);
    index_record(i)=posion;
    old_seed(i,:)=data(posion);

end



%%
%下面进行迭代，如果本次分别所有类新得到的像元数目变化在change_threshold内，则认为分类完毕。
n=1;
new_class_label=zeros(samples,1);
while true
    distance_matrix=zeros(samples,k);
    for kind=1:k
        tmp=data-old_seed(kind,:);
        tmp=dot(tmp,tmp,2);
        %每个像元与初始7个类别中心的欧式距离
        ou_distance=sqrt(tmp);
        distance_matrix(:,kind)=ou_distance;
    end
    %给各类别赋值类别标注
    for i=1:samples
        currentpixel_vector=distance_matrix(i,:);
        [~, index_of_value]=min(currentpixel_vector);
        currentpixel_class=index_of_value;
        new_class_label(i,1)=currentpixel_class;
    end
    
    %计算新的类中点
    
    for i=1:k
        id=new_class_label==i;
        temp1=data(id,:);
        new_seed(i,:)=mean(temp1);
    end
    
    Central_Position=new_seed;
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
    
        