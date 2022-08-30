function C=t_product(A,B)
%A和B均为3-D张量
%C=A*B，其中*为张量积

% 获取张量大小
[l,p,n]=size(A);dimA=[l,p,n];
[p,m,n]=size(B);dimB=[p,m,n];
dimC=[l,m,n];

% 对A，B进行unfold展开操作
ufold_A=reshape(permute(A,[2,1,3]),dimA(2),[])';
ufold_B=reshape(permute(B,[2,1,3]),dimB(2),[])';

% 对A构建循环矩阵
bcirc_A=zeros([l*n,p*n]);
for i=1:n
    bcirc_A(:,(1:p)+(i-1)*p)=circshift(ufold_A,l*(i-1),1);
end

% bcirc(A)·unfold(B)
AB=bcirc_A*ufold_B;

% 还原张量维度
C=ipermute(reshape(AB',dimC([2,1,3])),[2,1,3]);
end

