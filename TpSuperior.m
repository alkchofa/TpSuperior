clear all 
opengl('save','software')   %Si no ponia esto me tiraba error por OpenGL
clc %Borro lo que habia en el command Window

%%% Pequeña presentacion y menu
disp('Tp Integrador Grupo NoTengoIdea\n');
disp('Funcion 1: f(x)=1 si x ?(0,2), f(x) = f(x + 4)');
disp('Funcion 2: f(x)=x si x ?(0,2), f(x) = f(x + 2)');
disp('Funcion 3: f(x)= x si x ?(0,2)');
disp('           f(x)=-x si x ?(-2,0), f(x) = f(x + 4)');

funcion=input('Que funcion desea representar?: ');

%%% Segun la funcion seteamos los datos 
% A => Intervalos
% B => Valores de la funcion entre los intervalos

syms t
switch funcion
    case 1
       A=[-2 0 2];
       B=[0 1];
       T=4;
    case 2
        A=[0 2];
        B=[ t ];
        T=2;
    case 3
        A=[-2 0 2];
        B=[-t t];
        T=4;
end
% funcOriginal=0;
% for i=1:length(B)
%     funcOriginal = funcOriginal + sum(B(i));
% end
% funcOriginal=simplify(funcOriginal);

w0=2*pi/T;

B=sym(B); %Hacemos simbolico el array de la funcion con los valores entre los intervalos

x1=input('Ingrese limite inferior del intervalo: ');
x2=input('Ingrese limite superior del intervalo: ');
armonicas=input('Ingrese cantidad de armonicas minimas: ');

syms t n

%%% Calculamos Ao
a0=0;
for i=1:length(B)
        a0 = a0 + int(B(i),'t',A(i),A(i+1));
end
a0=simplify(a0/T);

%%% Calculamos An
an=0;
for i=1:length(B)
        an = an + int(B(i)*cos(n*w0*t),A(i),A(i+1));
end
an=simplify(2*an/T);

%%% Calculamos Bn
bn=0;
for i=1:length(B)
        bn = bn + int(B(i)*sin(n*w0*t),A(i),A(i+1));
end
bn=simplify(2*bn/T);

%%% Pasamos a string el resultado de An y Bn
an = char(an);
bn = char(bn);

%%% Luegos buscamos ciertos casos para simplificar la funcion
an = simplify(sym(strrep(char(an),'sin(pi*n)','0')));
bn = simplify(sym(strrep(char(bn),'sin(pi*n)','0')));

an = simplify(sym(strrep(char(an),'cos(pi*n)','(-1)^n')));
bn = simplify(sym(strrep(char(bn),'cos(pi*n)','(-1)^n')));

an = simplify(sym(strrep(char(an),'sin(2*pi*n)','0')));
bn = simplify(sym(strrep(char(bn),'sin(2*pi*n)','0')));

an = simplify(sym(strrep(char(an),'sin(2*pi*n)','1')));
bn = simplify(sym(strrep(char(bn),'sin(2*pi*n)','1')));

%%%
% for n=1:armonicas
%     f(n,:) = sum((eval(an))*cos(n*w0*t)+(eval(bn))*sin(n*w0*t));
% end

error=1;
n=1;
while (n<5)%(error>0.5)%((n<armonicas&armonicas<=50)&(error>0.05))
     f(n,:) = sum((eval(an))*cos(n*w0*t)+(eval(bn))*sin(n*w0*t));
     
     num=0;
     denum=0;
     for i=1:length(B)
         num=num+int(abs(B(i)-f),'t',A(i),A(i+1));
         denum=denum+int(B(i),'t',A(i),A(i+1));
     end
     error=eval((num)/(denum));
%      simplify(error);
     error
     %error=(int(abs(funcOriginal-f),0,T))/(int(abs(funcOriginal),0,T));
     n=n+1;
end



x= linspace(x1,x2,10);
fx=0;
for i=1:length(A)-1
   fx = fx + ((x>A(i))&(x<A(i+1))).*subs(B(i),x); 
end
plot(x, fx, 'Linewidth', 2); hold on
plot(x+max(x)-min(x), fx, 'Linewidth', 2)
plot(x-max(x)+min(x), fx, 'Linewidth', 2)
plot([max(x) max(x)], [fx(1) fx(end)], 'linewidth', 2)
plot([min(x) min(x)], [fx(end) fx(1)], 'linewidth', 2)
grid on
xlabel('\bfTIEMPO');
ylabel('\bfAMPLITUD');
title('\bfGRAFICA DE LA FUNCION');

% while condicion
%     an = an + int(f*cos(n*w0*t),x1,x2); 
%     
%    % error= (int())/();
% end
% bn

