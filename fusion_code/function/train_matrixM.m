function M=train_matrixM(X,y,model_parameter)
%X，y由construct_X_y得出
%y=MX
if isempty(X)
    M=[];
    return;
end


sigma=model_parameter.sigma;
p1=X-y;
H=p1*transpose(p1);
%计算Dis
Dis=zeros(1,size(X,1));
X_T=transpose(X);
for i=1:size(X,1)
    Dis(i)=dist(y,X_T(:,i));
end
t=H+sigma*diag(Dis);

if det(t)==0
    M=[];
    return;
end

C=inv(t)*ones([size(t,2) 1]);

rows_C=size(C,1);
p2=ones([1,rows_C])*C;
M=transpose(C/p2);
flag=true;


end
