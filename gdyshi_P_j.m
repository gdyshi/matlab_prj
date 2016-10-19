% 链路j以外的所有其他用户的策略组合
function P_j = gdyshi_P_j(Pj,j,N)
P_j = zeros(length(Pj),N-1);
for i = 1 : j-1
    P_j(i) = Pj;
end
for i = j+1 : N
    P_j(i) = Pj;
end