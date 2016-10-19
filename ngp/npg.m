% The function npg solves an n-person finite non-co-operative game to
% compute one sample Nash Equilibrium. It uses an optimization formulation
% of n-person non-co-operative games as described in the adjoining paper
% "An Optimization Formulation to Compute Nash Equilibrium in finite
% Games" presented by the author.
%
% The inputs to the function are:
% a) M : The row vector containing number of strategies of each player.
% b) U : The matrix containing the pay-offs to the players at various
%        pure strategy combinations.
%
% The outputs are:
% a) A : The matrix whose columns are mixed strategies to players at Nash
%        equilibrium.
% b) payoff : The row vector containing the pay-offs to the players at Nash
%        equilibrium.
% c) iterations : Number of iterations performed by the optimization
%        method.
% d) err : The absolute error in the objective function of the minimization
%        problem.
%
% For theory of the method the adjoining paper may be consulted. Here an
% example is given for explanantion. Consider a 3-person game where each
% player has 2 strategies each. So M = [2 2 2]. Suppose the pay-offs at the
% pure strategy combinations (1-1-1), (1-1-2) and so on, as described by
% the ranking in the theory, are given as the matrix U =
% [2,7.5,0;3,.2,.3;6,3.6,1.5;2,3.5,5;0,3.2,9;2,3.2,5;0,2,3.2;2.1,0,1]. Then
% after supplying M and U call [A,payoff,iterations,err] = npg(M,U).
%
% The method is capable of giving one sample Nash equilibrium out of
% probably many present in a given game. The screenshot showing GUI has 
% been developed on the code using it as dll and VB.Net. The GUI software 
% may be made available on request.
%
% Any error in the code may be reported to bhaskerchatterjee@gmail.com. Any
% suggestion/comment is greatly appreciated.

function [A,payoff,iterations,err] = npg(M,U)   %M表示每个用户的策略数目矩阵（1行n列），U表示混合策略下用户的收益矩阵（p行n列）

p = 1; V = 1;
n = length(M);   %用戶數目
s = sum(M);      %各用户純策略數目部和 M列求和
A = zeros(max(M),n);   %组合纯策略矩阵（所有不同选择结果）先置0， max(M)为用户拥有最大纯策略的个数
payoff = zeros(1,n);   %所有用户在策略选定时的收益矩阵置0

for i = 1 : n          
    p = p * M(1,i);    %组合纯策略的组合情况数目（M矩阵中所有元素的乘积），即最终可能出现的所有情况种数的总和
end

if p ~= size(U,1) || n ~= size(U,2)   %如果p不等于U矩阵的行数大小或n不等于U矩阵的列数大小
                                      %（U的行大小为组合纯策略总数，列大小为用户数）
    error('Error: Dimension mismatch!');   %维数不匹配
end

P = zeros(1,n);   %P矩阵1行n列置0
N = zeros(1,n);   %N矩阵1行n列置0
P(n) = 1;         %P中n个元素置为1 

for i = n-1 : -1 : 1
    P(i) = P(i+1) * M(i+1);  % P中元素存放的是组合策略个数
end

for i = 1 : n
    N(i) = p / P(i);    %N（1）=m1,N（2）=m1*m2,……，N(i)=m1*m2*…*mi,表示N矩阵的大小取决于用户的策略个数
end

x0 = zeros(s,1); k = 1;   %s是纯策略个数 x0为s行1列向量

for i = 1 : n             %对每一用户
    for j = 1 : M(1,i)    %对每一用户的每一种纯策略情况考虑
        x0(k) = 1 / M(1,i); k = k + 1;   %每用户的某种纯策略的概率，x0（k）表示选择某种纯策略的概率
    end
end

Us = sum(U,2);             %Us为对矩阵U的行求和，即在该策略选择下各用户的收益和

for i = 1 : n
    V = V * (1 / M(i)) ^ M(i);   %？？V初始值为1，此式表示选择一种组合策略的概率
end

x0 = [x0 ; V * (sum(U,1)')];  %sum(U,1)'为对U矩阵的列求和后再转置 
                              %U矩阵列求和表示在所有组合策略情况下用户i得到的收益和
Aeq = zeros(n,s+n); cnt = 0;   %？？n行s+n列，s是m1+m2+…+mn之和

for i = 1 : n
    if i ~= 1                %i不为1，即用户数目不为1
        
        cnt = cnt + M(i-1);  %对i用户，如果i不为1，则cnt为第（i-1）个用户的纯策略个数的和
    end
    for j = 1 : s
        if j <= sum(M(1:i)) &&  j > cnt  %？？sum(M(1:i)) 矩阵第一行元素求和。j小于等于总纯策略个数且大于cnt数
            Aeq(i,j) = 1; 
        end
    end
end

beq = ones(n,1);   %beq的n行1列矩阵置为1 
I = ones(p,n);     %I的p行n列矩阵元素置为1，p为组合策略总数目
counter = 0; count = 1;

for i = 1 : n      %对每一用户
    for j = 1 : N(i)   %N（1）=m1,N（2）=m1*m2,……，N(i)=m1*m2*…*mi
        counter = counter + 1;
        if i ~= 1
            if counter > sum(M(1:i))  %counter数大于M矩阵从1到第i个元素和
                counter = counter-M(i);  %counter数变动
            end
        end
        for k = 1 : P(i)   %P中元素存放的是组合策略个数
            I(count) = counter;
            count = count + 1;  %？？选择同一策略的用户数目
        end
    end
end


lb = zeros(s+n,1);
ub = ones(s+n,1);
pay = zeros(s,1);
counter = 0;

for i = 1 : n
    for j = 1 : M(i)
        counter = counter + 1;
        pay(counter) = i + s;
    end
end

for i = 1 : n
    lb(s+i) = -inf;
    ub(s+i) = inf;
end

[x,fval,exitflag,output] = gamer(n,Us,p,I,s,ub,lb,x0,Aeq,beq,pay,U);

count = 0;

for i = 1 : n
    for j = 1 : M(i)
        count = count + 1;
        A(j,i) = abs(x(count));
    end
    payoff(1,i) = x(s+i);
end

iterations = output.iterations;
err = abs(fval);