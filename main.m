%% MOMENTO EVALUATIVO 3 - INTRODUCCION A VISION ARTIFICIAL
% Procesamiento de color de imagenes digitales.
% Las imagenes resultantes se guardan en la carpeta "resultados" para
% incorporarlas en el documento de entrega.
clear; clc; close all;

raiz = fileparts(mfilename('fullpath'));
addpath(fullfile(raiz, 'funciones'));
dirRes = fullfile(raiz, 'resultados');
if ~exist(dirRes, 'dir'), mkdir(dirRes); end

I = cargarImagen();                       % imagen RGB 1024x1024x3 uint8
imwrite(I, fullfile(dirRes, 'p0_original.png'));

%% PUNTO 1 - Escala de grises con el negativo del mapa de color parula
gris = rgb2gray(I);
mapa = 1 - parula(256);                   % negativo del mapa parula

figure('Name', 'Punto 1');
imshow(gris); colormap(gca, mapa); colorbar;
title('Escala de grises con mapa de color negativo de parula');
exportgraphics(gca, fullfile(dirRes, 'p1_gris_negParula.png'));
imwrite(gris, mapa, fullfile(dirRes, 'p1_gris_negParula_indexada.png'));

% Un uint8 de nivel 170 usa la fila 171 del mapa (indices 0..255 -> 1..256)
nivel = 170;
tripleta = mapa(nivel + 1, :);
fprintf('PUNTO 1: tripleta RGB para el nivel %d\n', nivel);
fprintf('   [0,1]  : [%.4f  %.4f  %.4f]\n', tripleta);
fprintf('   [0,255]: [%d  %d  %d]\n\n', round(255 * tripleta));

%% PUNTO 2 - Componentes R,G,B / C,M,Y,K / H,S,I
cmyk = rgb2cmyk(I);
hsi  = rgb2hsi(I);

comps = {I(:,:,1), 'R'; I(:,:,2), 'G'; I(:,:,3), 'B'; ...
         cmyk(:,:,1), 'C'; cmyk(:,:,2), 'M'; cmyk(:,:,3), 'Y'; cmyk(:,:,4), 'K'; ...
         hsi(:,:,2), 'Saturacion'; hsi(:,:,1), 'Tono'; hsi(:,:,3), 'Intensidad'};

figure('Name', 'Punto 2', 'Position', [50 50 1400 600]);
tiledlayout(2, 5, 'TileSpacing', 'compact');
for k = 1:size(comps, 1)
    nexttile; imshow(comps{k, 1}); title(comps{k, 2});
    imwrite(im2uint8(comps{k, 1}), fullfile(dirRes, ['p2_' comps{k, 2} '.png']));
end

%% PUNTO 3 - YCbCr: negativo(log(Cr))
% Se trabaja en double para no acumular redondeos de uint8 entre pasos
ycc = rgb2ycbcr(im2double(I));
Cr  = ycc(:,:,3);
ycc(:,:,3) = negativo(transfLogaritmica(Cr));      % Paso 2 y 3
I3 = im2uint8(ycbcr2rgb(ycc));                     % Paso 4
mostrarPar(I, I3, 'Punto 3: YCbCr, Cr -> negativo(log(Cr))');
imwrite(I3, fullfile(dirRes, 'p3_transformada.png'));

%% PUNTO 4 - YIQ: gamma 1.5 en Y, Q -> -Q
yiq = rgb2ntsc(I);                                 % double, Y en [0,1]
yiq(:,:,1) = transfGamma(yiq(:,:,1), 1.5);         % Paso 2
yiq(:,:,3) = -yiq(:,:,3);                          % Paso 3
I4 = im2uint8(ntsc2rgb(yiq));                      % Paso 4 y 5
mostrarPar(I, I4, 'Punto 4: YIQ, \gamma=1.5 en Y y Q \times -1');
imwrite(I4, fullfile(dirRes, 'p4_transformada.png'));

%% PUNTO 5 - CMY: lineal a trozos en el Amarillo
cmy = rgb2cmy(I);
cmy(:,:,3) = transfLinealTrozos(cmy(:,:,3), 80, 60, 210, 120);   % r1,s1,r2,s2
I5 = cmy2rgb(cmy);
mostrarPar(I, I5, 'Punto 5: CMY, lineal a trozos en Y (r1=80,r2=210,s1=60,s2=120)');
imwrite(I5, fullfile(dirRes, 'p5_transformada.png'));

%% PUNTO 6 - HSI: ecualizacion del histograma
% Se ecualiza SOLO la intensidad: ecualizar H o S alteraria los colores.
hsi6 = rgb2hsi(I);
hsi6(:,:,3) = histeq(hsi6(:,:,3));
I6 = im2uint8(hsi2rgb(hsi6));
mostrarPar(I, I6, 'Punto 6: HSI, ecualizacion de la intensidad');
imwrite(I6, fullfile(dirRes, 'p6_transformada.png'));

figure('Name', 'Punto 6 - histogramas de I');
subplot(1, 2, 1); imhist(hsi(:,:,3));  title('Intensidad original');
subplot(1, 2, 2); imhist(hsi6(:,:,3)); title('Intensidad ecualizada');

%% PUNTO 7 - Realce laplaciano de 4 vecinos
% g = f - lap(f), con lap = [0 1 0; 1 -4 1; 0 1 0] aplicado a cada canal
w   = [0 1 0; 1 -4 1; 0 1 0];
f7  = double(I);
lap = imfilter(f7, w, 'replicate');
I7  = uint8(f7 - lap);                    % uint8 recorta a [0,255]
mostrarPar(I, I7, 'Punto 7: realce laplaciano de 4 vecinos');
imwrite(I7, fullfile(dirRes, 'p7_filtrada.png'));

%% PUNTO 8 - Correccion del balance de color
dirImg   = fullfile(raiz, 'imagenes');
desb     = imread(fullfile(dirImg, 'imagen_desbalanceada.tiff'));
objetivo = imread(fullfile(dirImg, 'imagen_objetivo.tiff'));

cmyD = rgb2cmy(desb);
cmyO = rgb2cmy(objetivo);

% (1) Diagnostico: comparar cada componente CMY con la del objetivo
nombres = {'Cian', 'Magenta', 'Amarillo'};
fprintf('PUNTO 8: diagnostico en el espacio CMY\n');
fprintf('   SSIM inicial = %.4f\n', ssim(desb, objetivo));
for k = 1:3
    d = double(cmyD(:,:,k)); o = double(cmyO(:,:,k));
    fprintf('   %-8s media desbalanceada = %6.2f | objetivo = %6.2f | max|dif| = %3d\n', ...
            nombres{k}, mean(d(:)), mean(o(:)), max(abs(d(:) - o(:))));
end

figure('Name', 'Punto 8 - curva de transferencia del Cian');
cD = double(cmyD(:,:,1)); cO = double(cmyO(:,:,1));
plot(cO(1:97:end), cD(1:97:end), '.', 'MarkerSize', 4); hold on;
plot(0:255, 255 * ((0:255) / 255) .^ 2.5, 'r', 'LineWidth', 1.5);
xlabel('Cian objetivo'); ylabel('Cian desbalanceada');
legend('pixeles', 's = 255 (r/255)^{2.5}', 'Location', 'northwest');
axis([0 255 0 255]); axis square; grid on;
title('Solo el Cian fue alterado con una curva tipo gamma');

% Estimacion del gamma aplicado: C_d = C_o^gamma (normalizados)
% => gamma = log(C_d) / log(C_o), usando pixeles en rango medio
cDn = cD / 255; cOn = cO / 255;
v = cOn > 0.1 & cOn < 0.9 & cDn > 0;
gammaDesb = median(log(cDn(v)) ./ log(cOn(v)));
fprintf('   Gamma estimado en el Cian = %.3f\n', gammaDesb);

% (2) Correccion: gamma inverso sobre el Cian
cmyC = cmyD;
cmyC(:,:,1) = transfGamma(cmyD(:,:,1), 1 / gammaDesb);
corregida = cmy2rgb(cmyC);

fprintf('   Gamma de correccion = 1/%.3f = %.3f\n', gammaDesb, 1 / gammaDesb);
fprintf('   SSIM final = %.4f\n\n', ssim(corregida, objetivo));

figure('Name', 'Punto 8', 'Position', [50 50 1400 500]);
tiledlayout(1, 3, 'TileSpacing', 'compact');
nexttile; imshow(desb);      title(sprintf('Desbalanceada (SSIM = %.4f)', ssim(desb, objetivo)));
nexttile; imshow(objetivo);  title('Objetivo');
nexttile; imshow(corregida); title(sprintf('Corregida (SSIM = %.4f)', ssim(corregida, objetivo)));
imwrite(objetivo,  fullfile(dirRes, 'p8_objetivo.png'));
imwrite(corregida, fullfile(dirRes, 'p8_corregida.png'));

%% Funcion local para mostrar original vs. transformada
function mostrarPar(A, B, titulo)
figure('Name', titulo, 'Position', [50 50 1200 550]);
tiledlayout(1, 2, 'TileSpacing', 'compact');
nexttile; imshow(A); title('Original RGB');
nexttile; imshow(B); title('Transformada');
sgtitle(titulo);
end
