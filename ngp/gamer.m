% The function gamer creates the objective function and the constraints for
% the optimization problem to supply it to fmincon.

function [x,fval,exitflag,output] = gamer(n,Us,p,I,s,ub,lb,x0,Aeq,beq,pay,U)

    function F = myfun(x)
        Funct = 0;
        prod = 1;  %Ԫ�ػ�
        for i = 1 : n
            Funct = Funct + x(s+i);
        end
        for i = 1 : p      %pΪ��ϴ����Ե���������Ŀ
            for j = 1 : n   %nΪ�û���Ŀ
                prod = prod * x(I(i,j));  %I   ÿ����ϴ������µڸ��û��ģ���
            end
            Funct = Funct - Us(i) * prod;
            prod = 1;
        end
        F = Funct;
    end

    function [c ceq] = confun(x)
        C = zeros(s,1);   %s��1��
        for i = 1 : s    
            C(i) = -x(pay(i));  %C��Ԫ�صĵõ���ʽ
            for t = 1 : n
                add = 0;
                for j = 1 : p
                    prd = 1;
                    for k = 1 : n
                        if i == I(j,k)   %I����p��n��
                            prd = prd * U(j,k);  %prd�ĵõ���ʽ ���֣�ȡ����i��I(j��k)���Ƿ�����ȹ�ϵ
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