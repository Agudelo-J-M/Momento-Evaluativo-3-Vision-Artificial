function hsi = rgb2hsi(rgb)
% RGB -> HSI (Gonzalez & Woods). Salida double, H,S,I en [0,1]
rgb = im2double(rgb);
R = rgb(:,:,1); G = rgb(:,:,2); B = rgb(:,:,3);

num   = 0.5 * ((R - G) + (R - B));
den   = sqrt((R - G).^2 + (R - B).*(G - B));
theta = acos(min(max(num ./ (den + eps), -1), 1));

H = theta;
H(B > G) = 2*pi - H(B > G);
H = H / (2*pi);

S = 1 - 3 .* min(min(R, G), B) ./ (R + G + B + eps);
H(S == 0) = 0;

I = (R + G + B) / 3;
hsi = cat(3, H, S, I);
end
