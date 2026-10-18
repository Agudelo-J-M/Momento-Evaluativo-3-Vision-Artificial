function rgb = cmyk2rgb(cmyk)
% CMYK (double [0,1]) -> RGB (double [0,1])
K = cmyk(:,:,4);
C = cmyk(:,:,1) .* (1 - K) + K;
M = cmyk(:,:,2) .* (1 - K) + K;
Y = cmyk(:,:,3) .* (1 - K) + K;
rgb = 1 - cat(3, C, M, Y);
end
