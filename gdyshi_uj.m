% 链路j的效用函数
% c 链路的功率定价因子
% h 链路信道增益,
% p 链路j的策略组合
function uj = gdyshi_uj(c,h,p,j)
% 户j单位带宽的可达速率,
sulv = log10(1 + (h(j)*p(j))/(1 + h*p' - h(j)*p(j)));
% cj*hj*pj^2 关于用户发送功率的代价函数
dajia = c(j)*h(j)*p(j)^2;
uj = sulv - dajia;