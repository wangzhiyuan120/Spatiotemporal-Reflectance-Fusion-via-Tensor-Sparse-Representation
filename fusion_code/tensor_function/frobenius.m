function f=frobenius(A)
%计算张量A的f范数

a=reshape(A,1,[]);
b=power(a,2);
c=cumsum(b);
f=sqrt(c(end));


end