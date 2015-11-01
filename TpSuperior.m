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
        B=[t];
        T=2;
    case 3
        A=[-2 0 2];
        B=[-t t];
        T=4;
end

w0=2*pi/T;

B=sym(B); %Hacemos simbolico el array de la funcion con los valores entre los intervalos

x1=input('Ingrese limite inferior del intervalo: ');
x2=input('Ingrese limite superior del intervalo: ');
armonicas=input('Ingrese cantidad de armonicas minimas: ');
fprintf('\n');

syms t n

%%% Calculamos Ao
a0=0;
for i=1:length(B)
        a0 = a0 + int(B(i),A(i),A(i+1));
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


%%%Este es el while principal en el cual calculamos la serie y evaluamos el
%%%error de la aproximacion encontrada

error=1;
salir=1;
while (salir==1)
    
    %%%En esta pequeña parte calculo la serie en funcion de la variable t
    %%%Lo mejor seria ponerla en una funcion pero no pude hacerlo
     stf=a0;
     for n=1:armonicas
         stf= stf + eval(sum(an*cos(n*w0*t)+bn*sin(n*w0*t)));
     end
     armonicas=armonicas+1;
         
     %%%Calculo el error y muestro la cantidad de armonicas necesarias para
     %%%lograr un error menor al 5%
     num=0;
     denum=0;
     for i=1:length(B)
        num=num+int( (B(i)-stf) ,A(i),A(i+1));
        num=abs(num);
        denum=denum+int(B(i),A(i),A(i+1));
     end
     error=((num)/(denum));
     error=eval(error);
     fprintf('Con %d armonicas el error es de %10.7f %% \n',armonicas-1,error*100);
     
     %%%Solo salgo del while si el error es menor al 5% o si ya probe con
     %%%50 armonicas
     if (error<0.05) || (armonicas>=50)
        salir=0;
     end
end

%%%Genero un array con 100 elementos entre el rango propuesto por el usuario
x= linspace(x1,x2,100);
Original=[];
Stf=[];
minA=min(A);
maxA=max(A);

%%%Esto tambien deberia ponerlo en funciones, pero no se como se hace
syms aux
for i=1:length(x)
   aux=x(i);
   %%%Creo un array llamado Original para poder situar los valores fuera
   %%%del periodo dentro de este.
   while ((aux<minA)||(aux>maxA))
       if (aux<minA)
           aux=aux+T;
       else
           aux=aux-T;
       end
   end
   
  %%%Y aca reemplazo el elemento del array Original por la posicion en el
  %%%eje Y
  for j=1:length(B)
      if ( aux>=A(j) && aux<=A(j+1) )
          func=inline(B(j));
          Original(i)=func(aux);
      end
  end
       
end

%%%Grafico la funcion original pasandole los 2 arrays
plot(x,Original), hold on

%%%Y aca grafico la serie trigonometrica de Fourier pasandole el array de X
%%%y la funcion
%%%Esta funcion evalua cada elemento en la funcion pasada
ezplot(stf,x)
xlabel('\bfTIEMPO'); ylabel('\bfAMPLITUD'); title('\bfGRAFICA DE LA FUNCION');
