clear;
clc;
%%
%读取图像
filename_of_HSR_t1= 'L7SR.05-24-01.r-g-nir.tif';
filename_of_HSR_t3='L7SR.08-12-01.r-g-nir.tif';
filename_of_LSR_t1='MOD09GHK.05-24-01.r-g-nir.tif';
filename_of_LSR_t3='MOD09GHK.08-12-01.r-g-nir.tif';

HSR_t1=imread(filename_of_HSR_t1);
HSR_t3=imread(filename_of_HSR_t3);

LSR_t1=imread(filename_of_LSR_t1);
LSR_t3=imread(filename_of_LSR_t3);
clear filename_of_HSR_t1;
clear filename_of_HSR_t3;
clear filename_of_LSR_t1;
clear filename_of_LSR_t3;
%将数据类型uint16转化为double
HSR_t1=double(HSR_t1);
HSR_t3=double(HSR_t3);
LSR_t1=double(LSR_t1);
LSR_t3=double(LSR_t3);

%%
%计算HSR_DIS_13和LSR_DIs_13
HSR_DI_31=HSR_t3-HSR_t1;
LSR_DI_31=LSR_t3-LSR_t1;
clear HSR_t1
clear HSR_t3
clear LSR_t1
clear LSR_t3
%%
%设置参数
model_parameter.r=256;
model_parameter.rmax=65535;
model_parameter.maxIP=20;
model_parameter.mu=1e-3;
model_parameter.lambda_s=0.15;
model_parameter.lambda_x=1e-3;
model_parameter.lambda_y=1e-4;
%下面几个参数文中未给出
model_parameter.beta_x=1e-3;
model_parameter.beta_y=1e-3;clc
model_parameter.beta_w=1e-3;
model_parameter.ksi=0.05;
model_parameter.K=10;               %分组数
model_parameter.width_of_patch=4;  %每个patch的宽度
model_parameter.n_iteration=30;
model_parameter.change_threshold=0.005;
model_parameter.sigma=1e-4;

%%
%先获取HSR_DI_13的聚类结构
[rows_of_HSR_DI31,cols_of_HSR_DI31,~]=size(HSR_DI_31);
patches=img2patches(HSR_DI_31,model_parameter.width_of_patch);
label_of_HSR_DI31=K_means_plus(patches,model_parameter.K,model_parameter.change_threshold,model_parameter.n_iteration);
label_of_HSR_DI31=patches2img(label_of_HSR_DI31,rows_of_HSR_DI31,cols_of_HSR_DI31,1,model_parameter.width_of_patch);

clear bands_of_HSR_DI31
clear cols_of_HSR_DI31
clear patches;
clear rows_of_HSR_DI31;
save("clusters.mat");
%%
%训练参数
for k=1:model_parameter.K
    X=construct_NSCT(HSR_DI_31,model_parameter.width_of_patch,label_of_HSR_DI31,k);
    Y=construct_NSCT(LSR_DI_31,model_parameter.width_of_patch,label_of_HSR_DI31,k);
    [D_x,D_y,W]=ADMM_solver(X,Y,model_parameter);
    
    [X_m,y_m]=construct_X_y(X,Y);
    M=train_matrixM(X_m,y_m,model_parameter);
    
    %存储训练的数据
    Dxs{k}=real(D_x);
    Dys{k}=real(D_y);
    Ws{k}=real(W);
    Ms{k}=M;


    
end
%%
clear D_x;
clear D_y;
clear HSR_DI_31;
clear LSR_DI_31;
clear k;
clear M;
clear W;
clear X;
clear Y;
clear X_m;
clear y_m;
save("dic_parameters.mat");
