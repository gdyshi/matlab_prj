% 链路j的效用函数
% U 算法控制因子
% max_dd_count 最大迭代次数
function [res,fs] = gdyshi_do(U)
N = 8;
max = 0.5;
% c 链路的功率定价因子
c = ones(1,N)*0.5;
% h 链路的信道增益,
% h = [0.7, 0.9, 1.1, 1.3, 1.4, 0.8, 0.2, 0.6];
 h = [0.7, 0.9, 1.1, 1.3, 1.4, 1.8, 2.2, 2.6];
% h = h*0.1667/0.5;
% p 链路的策略组合
P = gdyshi_P(max,N);

p = ones(1,N);
for i = 1 : N
    p(i) = P(i,1);
end

% 进行迭代
fs = zeros(1,20);
ppp = zeros(20,N);
pppp = zeros(1,20);
for i = 1 : 20
    pp = gdyshi_diedai1(c,h,p,P,N);
    fs(i) = norm(pp-p);
    if(fs(i)<=U) 
        break;
    end
    p = pp;
    ppp(i,:)=p;
    pppp(i)=sum(gdyshi_u(c,h,p,N));
end
plot(pppp,'DisplayName','ans','YDataSource','ans');figure(gcf)
%plot(fs,'*--','DisplayName','ans','YDataSource','ans');figure(gcf)
res = p
%res = gdyshi_u(c,h,p,N);
% 链路的效用函数
%u = gdyshi_u(c,h,p,N);


%[x,fval,exitflag,output] = fmincon(@myfun,x0,[],[],Aeq,beq,lb,ub,@confun,options);

