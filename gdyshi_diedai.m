% 链路的效用函数
% c 链路的功率定价因子
% h 链路信道增益,
% p 链路j的策略组合
function pp = gdyshi_diedai(c,h,p,P,N)
pn = size(P,2);
tempp=p;
pp=p;
u = zeros(1,pn);
for i = 1 : N
    for j = 1 : pn
        tempp(i)=P(i,j);
        u(j) = gdyshi_uj(c,h,tempp,i);
    end
    [maxu,index]=max(u);
    pp(i) = P(i,index);
end
