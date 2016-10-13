function v=xiaoyong(h,p,c,i)
%
sum=h.*p - h(i)*p(i);
v=log(1+(h(i)*p(i))/(e^2+sum)) - c(i)*h(i)*p(i)^2;