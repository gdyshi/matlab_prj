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

function [A,payoff,iterations,err] = npg(M,U)   %M��ʾÿ���û��Ĳ�����Ŀ����1��n�У���U��ʾ��ϲ������û����������p��n�У�

p = 1; V = 1;
n = length(M);   %�Ñ���Ŀ
s = sum(M);      %���û������Ԕ�Ŀ���� M�����
A = zeros(max(M),n);   %��ϴ����Ծ������в�ͬѡ����������0�� max(M)Ϊ�û�ӵ����󴿲��Եĸ���
payoff = zeros(1,n);   %�����û��ڲ���ѡ��ʱ�����������0

for i = 1 : n          
    p = p * M(1,i);    %��ϴ����Ե���������Ŀ��M����������Ԫ�صĳ˻����������տ��ܳ��ֵ���������������ܺ�
end

if p ~= size(U,1) || n ~= size(U,2)   %���p������U�����������С��n������U�����������С
                                      %��U���д�СΪ��ϴ������������д�СΪ�û�����
    error('Error: Dimension mismatch!');   %ά����ƥ��
end

P = zeros(1,n);   %P����1��n����0
N = zeros(1,n);   %N����1��n����0
P(n) = 1;         %P��n��Ԫ����Ϊ1 

for i = n-1 : -1 : 1
    P(i) = P(i+1) * M(i+1);  % P��Ԫ�ش�ŵ�����ϲ��Ը���
end

for i = 1 : n
    N(i) = p / P(i);    %N��1��=m1,N��2��=m1*m2,������N(i)=m1*m2*��*mi,��ʾN����Ĵ�Сȡ�����û��Ĳ��Ը���
end

x0 = zeros(s,1); k = 1;   %s�Ǵ����Ը��� x0Ϊs��1������

for i = 1 : n             %��ÿһ�û�
    for j = 1 : M(1,i)    %��ÿһ�û���ÿһ�ִ������������
        x0(k) = 1 / M(1,i); k = k + 1;   %ÿ�û���ĳ�ִ����Եĸ��ʣ�x0��k����ʾѡ��ĳ�ִ����Եĸ���
    end
end

Us = sum(U,2);             %UsΪ�Ծ���U������ͣ����ڸò���ѡ���¸��û��������

for i = 1 : n
    V = V * (1 / M(i)) ^ M(i);   %����V��ʼֵΪ1����ʽ��ʾѡ��һ����ϲ��Եĸ���
end

x0 = [x0 ; V * (sum(U,1)')];  %sum(U,1)'Ϊ��U���������ͺ���ת�� 
                              %U��������ͱ�ʾ��������ϲ���������û�i�õ��������
Aeq = zeros(n,s+n); cnt = 0;   %����n��s+n�У�s��m1+m2+��+mn֮��

for i = 1 : n
    if i ~= 1                %i��Ϊ1�����û���Ŀ��Ϊ1
        
        cnt = cnt + M(i-1);  %��i�û������i��Ϊ1����cntΪ�ڣ�i-1�����û��Ĵ����Ը����ĺ�
    end
    for j = 1 : s
        if j <= sum(M(1:i)) &&  j > cnt  %����sum(M(1:i)) �����һ��Ԫ����͡�jС�ڵ����ܴ����Ը����Ҵ���cnt��
            Aeq(i,j) = 1; 
        end
    end
end

beq = ones(n,1);   %beq��n��1�о�����Ϊ1 
I = ones(p,n);     %I��p��n�о���Ԫ����Ϊ1��pΪ��ϲ�������Ŀ
counter = 0; count = 1;

for i = 1 : n      %��ÿһ�û�
    for j = 1 : N(i)   %N��1��=m1,N��2��=m1*m2,������N(i)=m1*m2*��*mi
        counter = counter + 1;
        if i ~= 1
            if counter > sum(M(1:i))  %counter������M�����1����i��Ԫ�غ�
                counter = counter-M(i);  %counter���䶯
            end
        end
        for k = 1 : P(i)   %P��Ԫ�ش�ŵ�����ϲ��Ը���
            I(count) = counter;
            count = count + 1;  %����ѡ��ͬһ���Ե��û���Ŀ
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