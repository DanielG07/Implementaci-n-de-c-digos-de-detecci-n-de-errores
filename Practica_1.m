close all
clear all
% Creacion de secuencia de bits donde ya se hacen en arreglo de 125,000 x 8
% para un total de 1,000,000 de bits.
bits=1000000;
filas=bits/8;
palabraDatos = randi([0 1], filas, 8);

NR=[0.001, 0.005, 0.01, 0.05, 0.1];

tramasE=[];
bitsE=[];

for i=1:5
    [bit, tramas] = paridadSimple(NR(i),palabraDatos,filas);
    
    figure(1)
    subplot(2,1,1)
    stem(NR(i),bit,'LineWidth',2)
    title('Bits erroneos dejados pasar')
    xlabel('NR')
    ylabel('# bits')
    hold on
    
    subplot(2,1,2)
    stem(NR(i),tramas,'LineWidth',2)
    title('Tramas erroneas dejadas pasar/descartadas')
    xlabel('NR')
    ylabel('# tramas')
    hold on
    
    tramasE = [tramasE tramas];
    bitsE = [bitsE bit];
end

tramasE
bitsE

% % Creacion de secuencia de bits donde ya se hacen en arreglo de 200,000 x 5
% % para un total de 1,000,000 de bits.
filas=bits/5;
palabraDatos = randi([0 1], filas, 5);
tamanoCodigo = 8;
tamanoDatos = 5;
generador=[1 0 1 1];

tramasE=[];
bitsE=[];

for i=1:5
    [bit, tramas] = crc(NR(i), palabraDatos, tamanoDatos, tamanoCodigo, filas, generador);
    
    figure(2)
    subplot(2,1,1)
    stem(NR(i),bit,'LineWidth',2)
    title('Bits erroneos dejados pasar')
    xlabel('NR')
    ylabel('# bits')
    hold on
    
    subplot(2,1,2)
    stem(NR(i),tramas,'LineWidth',2)
    title('Tramas erroneas dejadas pasar/descartadas')
    xlabel('NR')
    ylabel('# tramas')
    hold on
    
    tramasE = [tramasE tramas];
    bitsE = [bitsE bit];
end

tramasE
bitsE

% Creacion de secuencia de bits donde ya se hacen en arreglo de 125,000 x 8
% para un total de 1,000,000 de bits.
bits=1000000;
filas=bits/8;
palabraDatos = randi([0 1], filas, 8);

NR=[0.001, 0.005, 0.01, 0.05, 0.1];

tramasE=[];
bitsE=[];

for i=1:5
    [bit, tramas] = checksum(NR(i),palabraDatos,filas);
    
    figure(3)
    subplot(2,1,1)
    stem(NR(i),bit,'LineWidth',2)
    title('Bits erroneos dejados pasar')
    xlabel('NR')
    ylabel('# bits')
    hold on
    
    subplot(2,1,2)
    stem(NR(i),tramas,'LineWidth',2)
    title('Tramas erroneas dejadas pasar/descartadas')
    xlabel('NR')
    ylabel('# tramas')
    hold on
    
    tramasE = [tramasE tramas];
    bitsE = [bitsE bit];
end

tramasE
bitsE


