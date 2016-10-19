% 链路的效用函数
% c 链路的功率定价因子
% h 链路信道增益,
% p 链路j的策略组合
function pp = gdyshi_diedai1(c,h,p,P,N)
tempp=p;
for j = 1 : N
    ttt = (1 + h*p' - h(j)*p(j));
    zuiyoujie = ( ((c(j)*ttt)^2 + 2*c(j)*h(j))^0.5 - c(j)*ttt ) / (2*c(j)*h(j));
    tempp(j) = min(zuiyoujie,max(P(j,:)));
end
pp = tempp;
