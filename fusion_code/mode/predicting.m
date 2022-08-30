clear;
clc;
load("dic_parameters.mat");

model_parameter.lambda_m=0.6;

LSR_t1="MOD09GHK.05-24-01.r-g-nir.tif";
LSR_t2="MOD09GHK.07-11-01.r-g-nir.tif";
LSR_t3="MOD09GHK.08-12-01.r-g-nir.tif";

HSR_DI21=predict(model_parameter,LSR_t1,LSR_t2,Dxs,Dys,Ms,Ws,label_of_HSR_DI31);
HSR_DI32=predict(model_parameter,LSR_t3,LSR_t2,Dxs,Dys,Ms,Ws,label_of_HSR_DI31);

HSR_t1=double(imread("L7SR.05-24-01.r-g-nir.tif"));
HSR_t3=double(imread("L7SR.08-12-01.r-g-nir.tif"));

HSR_t2=0.5.*(HSR_t1+HSR_DI21)+0.5.*(HSR_t3+HSR_DI32);

HSR_t2=real(HSR_t2);

imwrite(uint16(HSR_t2),"output\output.tif");



