% The function gamer creates the objective function and the constraints for
% the optimization problem to supply it to fmincon.

function [x,fval,exitflag,output] = gamer(n,Us,p,I,s,ub,lb,x0,Aeq,beq,pay,U)

    function F = myfun(x)
        Funct = 0;
        prod = 1;  %元素积
        for i = 1 : n
            Funct = Funct + x(s+i);
        end
        for i = 1 : p      %p为组合纯策略的组合情况数目
            for j = 1 : n   %n为用户数目
                prod = prod * x(I(i,j));  %I   每种组合纯策略下第个用户的？？
            end
            Funct = Funct - Us(i) * prod;
            prod = 1;
        end
        F = Funct;
    end

    function [c ceq] = confun(x)
        C = zeros(s,1);   %s行1列
        for i = 1 : s    
            C(i) = -x(pay(i));  %C中元素的得到方式
            for t = 1 : n
                add = 0;
                for j = 1 : p
                    prd = 1;
                    for k = 1 : n
                        if i == I(j,k)   %I矩阵p行n列
                            prd = prd * U(j,k);  %prd的得到方式 两种，取决于i与I(j，k)的是否有相等关系
                        else
                            prd = prd * x(I(j,k));
                        end
                    end
                    if I(j,t) ~= i
                        prd = 0;
                    end
                    add = add + prd;
                end
                C(i) = add + C(i);
            end
        end
        c = C;
        ceq = [];
    end

options = optimset('Display','off');
warning 'off' 'all';
[x,fval,exitflag,output] = fmincon(@myfun,x0,[],[],Aeq,beq,lb,ub,@confun,options);

end