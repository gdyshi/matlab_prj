% ��·��Ч�ú���
% c ��·�Ĺ��ʶ�������
% h ��·�ŵ�����,
% p ��·j�Ĳ������
function u = gdyshi_u(c,h,p,N)
u = zeros(1,N);
for i = 1 : N
    u(i) = gdyshi_uj(c,h,p,i);
end