function cmyk = rgb2cmyk(rgb)
% RGB -> CMYK (salida double en [0,1])
%   K = min(C,M,Y);  C' = (C-K)/(1-K) ...  (si K = 1 -> C'=M'=Y'=0)
cmy = im2double(rgb2cmy(rgb));
K   = min(cmy, [], 3);
den = 1 - K;
den(den == 0) = 1;                      % evita division por cero (negro puro)
C = (cmy(:,:,1) - K) ./ den;
M = (cmy(:,:,2) - K) ./ den;
Y = (cmy(:,:,3) - K) ./ den;
cmyk = cat(3, C, M, Y, K);
end
