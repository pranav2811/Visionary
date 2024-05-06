clc
clear all
syms x1 x2
f= x1^2-x1*x2+x2^2;
f1=inline(f);
f_obj=@(x) f1(x(1),x(2));
grad=gradient(f);
g1=inline(grad);
gx=@(x) g1(x(1),x(2));
h1=hessian(f);
x0=[1,1/2];
ite=5;
tol=0.05;
i=0;
while norm(gx(x0))>tol && i<ite
  
s=-gx(x0);
lab=s'*s/(s'*h1*s);
x_new=x0+lab*s';
x0=x_new;
i=i+1;
end
f_obj(x0)