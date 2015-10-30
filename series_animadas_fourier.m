%% SUMA DE LAS SERIES DE FOURIER
clc
clear
close all
syms n t
A0 = 1/4;
An = ((-1)^n-1)/(pi^2*n^2);
Bn = -((-1)^n)/(pi*n);
T = 2;
w0 = 2*pi/T;
Arm = 20;
for n=1:Arm
    f(n,:) = sum((eval(An))*cos(n*w0*t)+(eval(Bn))*sin(n*w0*t));
%     f(n,:) = sum((((-1)^n-1)/(pi^2*n^2))*cos(n*w0*t)+(-((-1)^n)/(pi*n))*sin(n*w0*t));
end
t = linspace(0, 5*T, 100);
f = subs(f, 't', t);
f(n+1,:) = zeros(1,100);
plot(t,A0+sum(f), 'Linewidth', 2); grid on
xlabel('\bfTIEMPO'); ylabel('\bfAMPLITUD'); title('\bf SERIE DE FOURIER')

%% SUMA DE LAS SERIES DE FOURIER ANIMADA
% clc
% clear
% close all
% syms n t
% A0 = 1/4;
% An = ((-1)^n-1)/(pi^2*n^2);
% Bn = -((-1)^n)/(pi*n);
% T = 2;
% w0 = 2*pi/T;
% % t = linspace(0, 5*T, 100);
% Arm = 10;
% for n=1:Arm
%     syms t
%     f(n,:) = sum((((-1)^n-1)/(pi^2*n^2))*cos(n*w0*t)+(-((-1)^n)/(pi*n))*sin(n*w0*t));
%     t = linspace(0, 5*T, 1000);
%     subplot(3, 1, 1);
%     plot(t, subs(f(n,:), 't', t)); grid on
%     xlabel('\bfTIEMPO'); ylabel('\bfAMPLITUD'); title('\bfCOMPONENTE')
%     hold on
%     subplot(3, 1, 2);
%     plot(t,subs(sum(f), 't', t), 'r', 'Linewidth',1.5);grid on
%     xlabel('\bfTIEMPO'); ylabel('\bfAMPLITUD'); title('\bfSERIE DE FOURIER')
%     subplot(3, 1, 3);
% %   C(n) = sqrt((An)^2+(Bn)^2);
%     C(n) = sqrt((((-1)^n-1)/(pi^2*n^2))^2+(-((-1)^n)/(pi*n))^2);
%     stem(C, 'fill');grid on
%     xlim([1, Arm]);
%     xlabel('\bfARMONICO'); ylabel('\bfAMPLITUD'); title('\bfESPECTRO DE FRECUENCIA')
%     %pause(1)
% end
