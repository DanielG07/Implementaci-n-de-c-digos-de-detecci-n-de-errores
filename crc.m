function [bitErroneos, tramasErroneas] = crc(NR, palabraDatos, tamanoDatos, tamanoCodigo, filas, generador)
%clear all
%% Codifo de revision CRC.

% Aplicamos la logica para agregar los bits 0 extras, de acuerdo con
% tamanoCodigo-tamanoDatos

palabraCodigo = [palabraDatos zeros(filas,(tamanoCodigo-tamanoDatos))];

% Ahora debemos de hacer uso del generador para poder realizar la division
% y de esta forma sustituir por el resto que nos de la division los bits
% agregados.

for i = 1:filas
    resto = [];
    trama=palabraCodigo(i,:);
    [cociente, resto] = deconv(trama, generador);
    resto = [resto(tamanoDatos+1) resto(tamanoDatos+2) resto(tamanoDatos+3)];
    
    for j = 1:(tamanoCodigo-tamanoDatos)
        if rem(resto(j),2) == 0
            palabraCodigo(i,tamanoDatos+j) = 0;
        else
            palabraCodigo(i,tamanoDatos+j) = 1;
        end
    
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
    for j = 1:tamanoCodigo
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
% deteccion de errorres de este código.

palabraRecibida = palabraTransmitida;
ubicacionErroresTramaRx = [0];
noErroresDetectadosTrama = 0;

for i = 1:filas
    resto = [];
    trama=palabraRecibida(i,:);
    [cociente, resto] = deconv(trama, generador);
    resto = [resto(tamanoDatos+1) resto(tamanoDatos+2) resto(tamanoDatos+3)];
    
    for j = 1:(tamanoCodigo-tamanoDatos)
        if rem(resto(j),2) == 0
           resto(j) = 0;
        else
            resto(j) = 1;
        end
    end
    
    resto = sum(resto);
    
    if resto ~= 0
        noErroresDetectadosTrama = noErroresDetectadosTrama + 1;
        ubicacionErroresTramaRx = [ubicacionErroresTramaRx; i];
    end
end

ubicacionErroresTramaRx(1) = [];

% Comparamos la palabra recibida con la transmitida, para eso primero le
% vamos a quitar el bit de paridad a toda la palabra recibida 

palabraDatosRx = [];
for i = 1:tamanoDatos
    palabraDatosRx = [palabraDatosRx palabraRecibida(:,i)];
end
indice=1;
bitErroneos = 0;
tramasErroneas = 0;
comparador = palabraDatos == palabraDatosRx;
for i = 1:filas
    suma = sum(comparador(i,:));
    m=find(ubicacionErroresTramaRx == i);

    if indice == m %Checar si es una trama descartada
        indice= indice +1;
        if suma == tamanoDatos %Checar si la suma de los bits de datos de tamaño de datos, sino esta mal
            tramasErroneas = tramasErroneas + 1;
        end
    else
        if suma ~= tamanoDatos %Checar si la suma de los bits de datos de tamaño de datos, sino esta mal
            bitErroneos = bitErroneos + (tamanoDatos-suma);
            tramasErroneas = tramasErroneas + 1;
        end
    end
    
end

end