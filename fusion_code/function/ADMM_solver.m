function [D_x,D_y,W]=ADMM_solver(NSCT_X,NSCT_Y,model_parameter)
%对张量NSCT_X和NSCT_Y训练字典的相关参数
%返回字典D_x，D_y和稀疏之间的关系W

%获取一些模型参数
r=model_parameter.r;
rmax=model_parameter.rmax;
maxIP=model_parameter.maxIP;
mu=model_parameter.mu;
lambda_s=model_parameter.lambda_s;
lambda_x=model_parameter.lambda_x;
lambda_y=model_parameter.lambda_y;
beta_x=model_parameter.beta_x;
beta_y=model_parameter.beta_y;
beta_w=model_parameter.beta_w;
ksi=model_parameter.ksi;

[rows_X,cols_X,bands_X]=size(NSCT_X);
[rows_Y,cols_Y,bands_Y]=size(NSCT_Y);

if rows_X==0
    D_x=[];
    D_y=[];
    W=[];
    return;
end
    

%初始化参数
D_x=randi([0,rmax],rows_X,r,bands_X);
D_y=randi([0,rmax],rows_Y,r,bands_Y);
A=randi([0,rmax],r,cols_X,bands_X);
B=randi([0,rmax],r,cols_Y,bands_Y);
W=randi([0,rmax],r,r,bands_X);
A1=A;B1=B;B2=B;
V1=zeros(size(A));
U1=zeros(size(B));U2=U1;

%训练过程
not_converged=true;     %收敛标志
i=1;                    %迭代次数
while not_converged && i<maxIP 
    %%
    %更新A和B
    s_1=mu.*(A1+V1)+lambda_s.*(t_product(W,B2)); %分子
    s_1=s_1./(mu+lambda_s);
    s_2=lambda_x/(2*(mu+lambda_s));
    A=soft(s_1,s_2);
    ss_1=mu.*(B1+B2+U1+U2)./(2*mu);
    ss_2=lambda_y/(4*mu);
    B=soft(ss_1,ss_2);
    %%
    %更新A1,B1,B2,D_x,D_y和W
    dig_Dx=tensor2bdiag_DFT(D_x);
    n_eye=size(dig_Dx,2);
    p1=transpose(dig_Dx)*dig_Dx+mu*eye(n_eye,n_eye);
    p2=transpose(dig_Dx)*tensor2bdiag_DFT(NSCT_X)+mu*(tensor2bdiag_DFT(A)-tensor2bdiag_DFT(V1));
    dig_A1=pinv(p1)*p2;
    [rows_t,cols_t,bands_t]=size(A1);
    A1=bdiag_DFT2tensor(dig_A1,rows_t,cols_t,bands_t);           %更新A1
    
    dig_Dy=tensor2bdiag_DFT(D_y);
    n_eye=size(dig_Dy,2);
    p1=transpose(dig_Dy)*dig_Dy+mu*eye(n_eye,n_eye);
    p2=transpose(dig_Dy)*tensor2bdiag_DFT(NSCT_Y)+mu*(tensor2bdiag_DFT(B)-tensor2bdiag_DFT(U1));
    dig_B1=pinv(p1)*p2;  
    [rows_t,cols_t,bands_t]=size(B1);
    B1=bdiag_DFT2tensor(dig_B1,rows_t,cols_t,bands_t);           %更新B1
    
    dig_W=tensor2bdiag_DFT(W);
    n_eye=size(dig_W,2);
    p1=lambda_s*transpose(dig_W)*dig_W+mu*eye(n_eye,n_eye);
    p2=lambda_s*transpose(dig_W)*tensor2bdiag_DFT(A)+mu*(tensor2bdiag_DFT(B)-tensor2bdiag_DFT(U2));
    dig_B2=pinv(p1)*p2;
    [rows_t,cols_t,bands_t]=size(B2);
    B2=bdiag_DFT2tensor(dig_B2,rows_t,cols_t,bands_t);           %更新B2
    
    n_eye=size(dig_A1,1);
    p1=tensor2bdiag_DFT(NSCT_X)*transpose(dig_A1);
    p2=dig_A1*transpose(dig_A1)+beta_x*eye(n_eye,n_eye);
    dig_Dx=(p1)*pinv(p2);
    [rows_t,cols_t,bands_t]=size(D_x);
    D_x=bdiag_DFT2tensor(dig_Dx,rows_t,cols_t,bands_t);          %更新D_x
    
    n_eye=size(dig_B1,1);
    p1=tensor2bdiag_DFT(NSCT_Y)*transpose(dig_B1);
    p2=dig_B1*transpose(dig_B1)+beta_y*eye(n_eye,n_eye);
    dig_Dy=(p1)*pinv(p2);
    [rows_t,cols_t,bands_t]=size(D_y);
    D_y=bdiag_DFT2tensor(dig_Dy,rows_t,cols_t,bands_t);           %更新D_y
    
    n_eye=size(dig_B2,1);
    p1=lambda_s*tensor2bdiag_DFT(A)*transpose(dig_B2);
    p2=lambda_s*dig_B2*transpose(dig_B2)+beta_w*eye(n_eye,n_eye);
    dig_W=(p1)*pinv(p2);
    [rows_t,cols_t,bands_t]=size(W);
    W=bdiag_DFT2tensor(dig_W,rows_t,cols_t,bands_t);           %更新W
   %% 
    %更新V1,U1,U2
    V1=V1-(A-A1);
    U1=U1-(B-B1);
    U2=U2-(B-B2);
    
    %%
    %检查收敛状态
    pp1=NSCT_X-t_product(D_x,A1);
    f1=frobenius(pp1)^2;
    pp2=NSCT_Y-t_product(D_y,B1);
    f2=frobenius(pp2)^2;
    pp3=A-t_product(W,B2);
    f3=frobenius(pp3)^2;
    
    err=max([f1 f2 f3]);
    if err<ksi
        not_converged=false;
    end
    
    i=i+1;
end

end