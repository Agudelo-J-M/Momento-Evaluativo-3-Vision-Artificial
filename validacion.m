%% VALIDACION DE FUNCIONES (no calificable)
% Verifica que las conversiones de espacio de color son invertibles:
% RGB -> espacio -> RGB  y  SSIM(original, reconstruida) = 1
clear; clc; close all;
addpath(fullfile(fileparts(mfilename('fullpath')), 'funciones'));

I = cargarImagen();

% CMY
rec = cmy2rgb(rgb2cmy(I));
fprintf('SSIM RGB->CMY->RGB   : %.6f\n', ssim(rec, I));

% CMYK
rec = im2uint8(cmyk2rgb(rgb2cmyk(I)));
fprintf('SSIM RGB->CMYK->RGB  : %.6f\n', ssim(rec, I));

% HSI
rec = im2uint8(hsi2rgb(rgb2hsi(I)));
fprintf('SSIM RGB->HSI->RGB   : %.6f\n', ssim(rec, I));

% YCbCr (Image Processing Toolbox)
rec = im2uint8(ycbcr2rgb(rgb2ycbcr(im2double(I))));
fprintf('SSIM RGB->YCbCr->RGB : %.6f\n', ssim(rec, I));

% YIQ (Image Processing Toolbox)
rec = im2uint8(ntsc2rgb(rgb2ntsc(I)));
fprintf('SSIM RGB->YIQ->RGB   : %.6f\n', ssim(rec, I));

% Transformaciones de intensidad (graficas de las curvas)
r = uint8(0:255);
figure('Name', 'Transformaciones de intensidad');
plot(0:255, double(negativo(r)), 0:255, double(transfLogaritmica(r)), ...
     0:255, double(transfGamma(r, 1.5)), 0:255, double(transfGamma(r, 0.4)), ...
     0:255, double(transfLinealTrozos(r, 80, 60, 210, 120)), 'LineWidth', 1.5);
legend('Negativo', 'Logaritmica', '\gamma = 1.5', '\gamma = 0.4', ...
       'Lineal a trozos (80,60)-(210,120)', 'Location', 'northwest');
xlabel('r'); ylabel('s'); axis([0 255 0 255]); axis square; grid on;
