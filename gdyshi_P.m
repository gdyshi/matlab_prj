% ���в�����ϵĿռ�
function P = gdyshi_P(max,N)
Pj = gdyshi_Pj(max);
P = zeros(N,length(Pj));
for i = 1 : N
    P(i,:) = Pj;
end