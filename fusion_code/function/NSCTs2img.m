function img=NSCTs2img(NSCTs,label,width,K)


%³õÊ¼»¯imgÍ¼Ïñ
img=zeros(size(label,1),size(label,2),3);

for k=1:K
    m=NSCTs{k};
    if isempty(m)
        continue;
    end
    s=1;
    for i=1:width:size(img,1)
        for j=1:width:size(img,2)
            if label(i,j)==k
                mm=m(s,:,:);
                img(i:(i+width-1),j:(j+width-1),:)=reshape(mm,width,width,3);
                s=s+1;
            end
        end
    end
            
    
    
    
    
    
    
    
    
    
    
    
end





end