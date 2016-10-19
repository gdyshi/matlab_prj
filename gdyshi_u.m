% 链路的效用函数
% c 链路的功率定价因子
% h 链路信道增益,
% p 链路j的策略组合
function u = gdyshi_u(c,h,p,N)
u = zeros(1,N);
for i = 1 : N
    u(i) = gdyshi_uj(c,h,p,i);
end