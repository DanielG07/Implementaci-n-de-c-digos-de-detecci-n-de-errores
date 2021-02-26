function [bitErroneos, tramasErroneas] = checksum(NR, palabraDatos,filas)
%clear all
%% Codigo de revision de checksum.

palabraCodigo = palabraDatos;
bitsNuevos = [0 0 0 0];

for i = 1:filas
    A = palabraCodigo(i,1:4);
    B = palabraCodigo(i,5:8);
    A = [0 A];
    B = [0 B];
    
    aux1 = bin2dec(num2str(A));
    aux2 = bin2dec(num2str(B));
    suma = dec2bin(aux1 + aux2);
    if isempty(suma)
        suma = [0 0 0 0];
    elseif length(suma) == 1
        suma = [0 0 0 0 str2num(suma(1))];
    elseif length(suma) == 2
        suma = [0 0 0 str2num(suma(1)) str2num(suma(2))];
    elseif length(suma) == 3
        suma = [0 0 str2num(suma(1)) str2num(suma(2)) str2num(suma(3))];
    elseif length(suma) == 4
        suma = [0 str2num(suma(1)) str2num(suma(2)) str2num(suma(3)) str2num(suma(4))];
    else
        suma = [str2num(suma(1)) str2num(suma(2)) str2num(suma(3)) str2num(suma(4)) str2num(suma(5))];
    end
    acarreo = [0 0 0 suma(1)];
    suma(1) = [];
    
    aux1 = bin2dec(num2str(suma));
    aux2 = bin2dec(num2str(acarreo));
    sumaFinal = dec2bin(aux1 + aux2);
    if isempty(sumaFinal)
        sumaFinal = [0 0 0 0]
    elseif length(sumaFinal) == 1
        sumaFinal = [0 0 0 str2num(sumaFinal(1))];
    elseif length(sumaFinal) == 2
        sumaFinal = [0 0 str2num(sumaFinal(1)) str2num(sumaFinal(2))];
    elseif length(sumaFinal) == 3
        sumaFinal = [0 str2num(sumaFinal(1)) str2num(sumaFinal(2)) str2num(sumaFinal(3))];
    else
        sumaFinal = [str2num(sumaFinal(1)) str2num(sumaFinal(2)) str2num(sumaFinal(3)) str2num(sumaFinal(4))];
    end
    bitsNuevos = [bitsNuevos; sumaFinal];
    
end

%Hacemos el complemento de los resultados de las sumas
bitsNuevos(1,:) = [];
for i = 1:filas
    for j = 1:4
        if bitsNuevos(i,j) == 1
            bitsNuevos(i,j) = 0;
        else 
            bitsNuevos(i,j) = 1;
        end
    end
end 

palabraCodigo = [palabraCodigo bitsNuevos];

% Aplicamos ahora una inversion de los bits para la simulacion de errores
% de transmisión. La variable NR va a ser nuestro valor de referencia que
% puede ir entre [0.001 0.005 0.01 0.05 0.1]. La variable noCambios nos
% ayuda a ver el numero de cambios que hubo al hacer la simulacion del
% efecto de errores y la variable ubicacionCambios nos ayuda a conocer la
% ubicacion de donde se genero el error.

palabraTransmitida = palabraCodigo;
noErroresGeneradosbit = 0;
ubicacionErroresMediobit = [0 0];

for i = 1:filas
    for j = 1:12
        if rand < NR
            if palabraTransmitida(i,j) == 0
                palabraTransmitida(i,j) = 1;
            else
                palabraTransmitida(i,j) = 0;
            end
            noErroresGeneradosbit = noErroresGeneradosbit + 1;
            ubicacionErroresMediobit = [ubicacionErroresMediobit; i j];
        end
    end
end

ubicacionErroresMediobit(1,:) = [];

% Ahora nos vamos del lado del receptor para ver el funcionamiento de la
% deteccion de errorres de este código. Primero vamos a implementar el
% verificador del código de paridad simple en el receptor.

palabraRecibida = palabraTransmitida;
ubicacionErroresTramaRx = [0 0];
noErroresDetectadosTrama = 0;

for i = 1:filas
    A = palabraRecibida(i,1:4);
    B = palabraRecibida(i,5:8);
    C = palabraRecibida(i,9:12);
    A = [0 A];
    B = [0 B];
    C = [0 C];
    
    aux1 = bin2dec(num2str(A));
    aux2 = bin2dec(num2str(B));
    suma = dec2bin(aux1 + aux2);
    if isempty(suma)
        suma = [0 0 0 0];
    elseif length(suma) == 1
        suma = [0 0 0 0 str2num(suma(1))];
    elseif length(suma) == 2
        suma = [0 0 0 str2num(suma(1)) str2num(suma(2))];
    elseif length(suma) == 3
        suma = [0 0 str2num(suma(1)) str2num(suma(2)) str2num(suma(3))];
    elseif length(suma) == 4
        suma = [0 str2num(suma(1)) str2num(suma(2)) str2num(suma(3)) str2num(suma(4))];
    else
        suma = [str2num(suma(1)) str2num(suma(2)) str2num(suma(3)) str2num(suma(4)) str2num(suma(5))];
    end
    acarreo = [0 0 0 suma(1)];
    suma(1) = [];
   
    aux1 = bin2dec(num2str(suma));
    aux2 = bin2dec(num2str(acarreo));
    sumaAcarreo = dec2bin(aux1 + aux2);
    if isempty(sumaAcarreo)
        sumaAcarreo = [0 0 0 0]
    elseif length(sumaAcarreo) == 1
        sumaAcarreo = [0 0 0 str2num(sumaAcarreo(1))];
    elseif length(sumaAcarreo) == 2
        sumaAcarreo = [0 0 str2num(sumaAcarreo(1)) str2num(sumaAcarreo(2))];
    elseif length(sumaAcarreo) == 3
        sumaAcarreo = [0 str2num(sumaAcarreo(1)) str2num(sumaAcarreo(2)) str2num(sumaAcarreo(3))];
    else
        sumaAcarreo = [str2num(sumaAcarreo(1)) str2num(sumaAcarreo(2)) str2num(sumaAcarreo(3)) str2num(sumaAcarreo(4))];
    end
    
    sumaAcarreo = [0 sumaAcarreo];
    
    aux1 = bin2dec(num2str(sumaAcarreo));
    aux2 = bin2dec(num2str(C));
    suma = dec2bin(aux1 + aux2);
    if isempty(suma)
        suma = [0 0 0 0];
    elseif length(suma) == 1
        suma = [0 0 0 0 str2num(suma(1))];
    elseif length(suma) == 2
        suma = [0 0 0 str2num(suma(1)) str2num(suma(2))];
    elseif length(suma) == 3
        suma = [0 0 str2num(suma(1)) str2num(suma(2)) str2num(suma(3))];
    elseif length(suma) == 4
        suma = [0 str2num(suma(1)) str2num(suma(2)) str2num(suma(3)) str2num(suma(4))];
    else
        suma = [str2num(suma(1)) str2num(suma(2)) str2num(suma(3)) str2num(suma(4)) str2num(suma(5))];
    end
    acarreo = [0 0 0 suma(1)];
    suma(1) = [];
    
    aux1 = bin2dec(num2str(suma));
    aux2 = bin2dec(num2str(acarreo));
    sumaAcarreo = dec2bin(aux1 + aux2);
    if isempty(sumaAcarreo)
        sumaAcarreo = [0 0 0 0]
    elseif length(sumaAcarreo) == 1
        sumaAcarreo = [0 0 0 str2num(sumaAcarreo(1))];
    elseif length(sumaAcarreo) == 2
        sumaAcarreo = [0 0 str2num(sumaAcarreo(1)) str2num(sumaAcarreo(2))];
    elseif length(sumaAcarreo) == 3
        sumaAcarreo = [0 str2num(sumaAcarreo(1)) str2num(sumaAcarreo(2)) str2num(sumaAcarreo(3))];
    else
        sumaAcarreo = [str2num(sumaAcarreo(1)) str2num(sumaAcarreo(2)) str2num(sumaAcarreo(3)) str2num(sumaAcarreo(4))];
    end

    if sum(sumaAcarreo) ~= 4
        noErroresDetectadosTrama = noErroresDetectadosTrama + 1;
        ubicacionErroresTramaRx = [ubicacionErroresTramaRx; i j];
    end    
    
end

ubicacionErroresTramaRx(1,:) = [];
ubicacionErroresTramaRx(:,2) = [];

% Comparamos la palabra recibida con la transmitida, para eso primero le
% vamos a quitar el bit de paridad a toda la palabra recibida 

palabraDatosRx = palabraRecibida;
palabraDatosRx (:,9:12) = [];
indice=1;
tramasErroneas = 0;
bitErroneos = 0;
comparador = palabraDatos == palabraDatosRx;
for i = 1:filas
    suma = sum(comparador(i,:));
    m=find(ubicacionErroresTramaRx == i);

    if indice == m %Checar si es una trama descartada
        indice= indice +1;
        if suma == 8 %Checar si la suma de los bits de datos da 8, sino esta mal
            tramasErroneas = tramasErroneas + 1;
        end
    else
        if suma ~= 8 %Checar si la suma de los bits de datos da 8, sino esta mal
            bitErroneos = bitErroneos + (8-suma);
            tramasErroneas = tramasErroneas + 1;
        end
    end
    
end

end
