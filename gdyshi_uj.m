% ��·j��Ч�ú���
% c ��·�Ĺ��ʶ�������
% h ��·�ŵ�����,
% p ��·j�Ĳ������
function uj = gdyshi_uj(c,h,p,j)
% ��j��λ����Ŀɴ�����,
sulv = log10(1 + (h(j)*p(j))/(1 + h*p' - h(j)*p(j)));
% cj*hj*pj^2 �����û����͹��ʵĴ��ۺ���
dajia = c(j)*h(j)*p(j)^2;
uj = sulv - dajia;