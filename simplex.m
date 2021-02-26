%Integrantes:
%Cristian Reinales, Nicolas Botero, Daniel Zarate, Giancarlo Gonzalez,
%Miguel Caciedo
%Implementacion del metodo simplex


Min = "Min";
Max = "Max";
%Input Zone
disp("Recuerde que todos los valores deben ser ingresados entre brackets")
disp("Tenga en cuenta que el problema lineal debe estar en formato standard")
disp("( [] ) y los valores deben estar separados por comas ( , )")
disp("Ejemplo: [1,2,3,4,5]")
disp("=======================================================================")
indicesFo = input("Ingrese los indices para las variables de la funcion objetivo: ");
c = input("Ingrese los coeficientes de la funcion objetivo: ");
minMax = input("Escriba 'Min' para minimizar la funcion o 'Max' para maximizarla: ");
minMax = Min



%NUESTROS VALORES POR DEFECTO
%A = [2,3,1,0;-1,1,0,1];
%Ib =  [3,4];
%In = [1,2];
%b = [6;1];
%c = [-1,-3,0,0];
%FIN DE NUESTROS VALORES POR DEFECTO






%Ejecucion del Metodo Simplex (Iteracion Nº 1)
optimal = false;
result = iterar(A, Ib, In, b, c, minMax, optimal)
%iterar(A, Ib, In, b, c, minMax, optimal);

function result = iterar(A, Ib, In, b, c, minMax, optimal)
c = isMin(minMax, c);
B = findB(A,Ib);
N = findN(A,In);
bg = paso1(B,b);
[cjg, minIndex] = paso2(B,c, In, Ib, N);

[Ib, In, B, N] = paso3(A, B, minIndex, bg, Ib, In);
if optimal == true
   result = getResult(c, cjg);
else
    A
    Ib
    In
    b
    c
    minMax
    optimal
    result = iterar(A, Ib, In, b, c, minMax, optimal);

end
end


function result = getResult(c, cjg)
    xVector = zeros(1,size(c,2));
    for i = 1: size(cjg,2)
        xVector(:,i) = cjg(:,i);
    end
    xVector = xVector.'
    result = xVector * c;

end

function [c] = isMin(minMax,c)
    if(minMax == "Max")
        c = c*-1;
    else
        c = c;
    end
end

function B = findB(A, Ib)
%Hallamos B
for i = 1:size(Ib,2)
    %B(:,1) = A(:,3)
    B(:,i) = A(:,Ib(1,i));
end
end

function N = findN(A,In)
%Hallamos N
for i = 1:size(In,2)
    N(:,i) = A(:,In(1,i));
end
end

function [bg] = paso1(B, b) % Calcula B gorro
%B complemento
Bc = inv(B);
%B gorro
bg = Bc*b;
end

function [cjg,minIndex] = paso2(B, c, In, Ib, N)
disp("PASO 2")
%B complemento
Bc = inv(B);
%Hallamos cj
for i = 1:size(In,2)
    cj(:,i) = c(:,In(1,i));
end
cj
%Hallamos cb
for i = 1:size(Ib,2)
    cb(:,i) = c(:,Ib(1,i));
end
cb
%Hallamos cjg

cjg = cj - cb*Bc*N;

cjg
minVal = cjg(:,1);
for i = 1:size(cjg,2)
    if cjg(:,i) <= 0;
        if cjg(:,i) <= minVal
            minVal = cjg(:,i);
        end
    else
        optimal = true;
        break
    end
end
disp("Wanna kill me")
minIndex = find(cjg==minVal)
minIndex = In(1,minIndex)

end

function [Ib, In, B, N] = paso3(A, B, minIndex, bg, Ib, In)
Bc = inv(B);
yk = Bc*A(:,minIndex);
posibleMM = [];
for i = 1:size(bg,1)
    if (bg(i,1) >= 0) && (yk(i,1) > 0)
        tempMatrix = [bg(i,1);yk(i,1)]
        posibleMM = [posibleMM [tempMatrix]]

    end
    
end
compMM = [];
for i = 1: size(posibleMM,2)
    compMM(end+1) = posibleMM(1,i) / posibleMM(2,i)
end
minMM = min(compMM)

tempPos = find(compMM==minMM);
tempNum = bg(tempPos,1);
correctRow = find(bg==tempNum(1,1));
r = Ib(1,correctRow);

disp("Old ib and in")
Ib
In
disp("NEW ib and in")
Ib(:,correctRow,1) = In(:,minIndex)
In(:,minIndex,1) = r
disp("=======================================================================")
disp("=======================================================================")
disp("DEBUG")
disp("=======================================================================")
disp("=======================================================================")
Ib = sort(Ib)
In = sort(In)
disp("=======================================================================")
disp("=======================================================================")
disp("Aqui empieza otra iteracion")
disp("=======================================================================")
disp("=======================================================================")
B = findB(A,Ib)
N = findN(A,In)
disp("=======================================================================")
end
