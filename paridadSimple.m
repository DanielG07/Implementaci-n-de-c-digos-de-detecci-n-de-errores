function [bitErroneos, tramasErroneas] = paridadSimple(NR, palabraDatos,filas)
%clear all
%% Codigo de revision de paridad simple.


% Aplicamos la logica para agregar el bit de paridad, donde vamos a contar
% el numero de 1 que tenemos en cada fila, en caso de tener un valor de
% unos par agregamos un 0 en el bit de paridad, en caso contrario agregamos
% un 0.

palabraCodigo = palabraDatos;

% Agregamos una columna para evitar problemas de dimensiones de la matriz
% del mensaje.

palabraCodigo(1,9) = 0;

for i = 1:filas
   unos = 0;
    for j = 1:8
        
        if palabraCodigo(i,j) == 1
            unos = unos + 1;
        end
        
    end
    
    if rem(unos,2) == 0
        palabraCodigo(i,9) = 0;
    else
        palabraCodigo(i,9) = 1;
    end
end

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
    for j = 1:9
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
   unos = 0;
    for j = 1:9
        if palabraRecibida(i,j) == 1
            unos = unos + 1;
        end
        
    end
    
    if rem(unos,2) ~= 0
        noErroresDetectadosTrama = noErroresDetectadosTrama + 1;
        ubicacionErroresTramaRx = [ubicacionErroresTramaRx; i j];
    end
end

ubicacionErroresTramaRx(1,:) = [];
ubicacionErroresTramaRx(:,2) = [];

% Comparamos la palabra recibida con la transmitida, para eso primero le
% vamos a quitar el bit de paridad a toda la palabra recibida 

palabraDatosRx = palabraRecibida;
palabraDatosRx (:,end) = [];
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