function rgb = hsi2rgb(hsi)
% HSI (double [0,1]) -> RGB (double [0,1]) (Gonzalez & Woods)
H = hsi(:,:,1) * 2*pi;
S = hsi(:,:,2);
I = hsi(:,:,3);
R = zeros(size(H)); G = R; B = R;

% Sector RG (0 <= H < 120)
idx = (H >= 0) & (H < 2*pi/3);
B(idx) = I(idx) .* (1 - S(idx));
R(idx) = I(idx) .* (1 + S(idx) .* cos(H(idx)) ./ cos(pi/3 - H(idx)));
G(idx) = 3*I(idx) - (R(idx) + B(idx));

% Sector GB (120 <= H < 240)
idx = (H >= 2*pi/3) & (H < 4*pi/3);
Hs = H(idx) - 2*pi/3;
R(idx) = I(idx) .* (1 - S(idx));
G(idx) = I(idx) .* (1 + S(idx) .* cos(Hs) ./ cos(pi/3 - Hs));
B(idx) = 3*I(idx) - (R(idx) + G(idx));

% Sector BR (240 <= H <= 360)
idx = (H >= 4*pi/3) & (H <= 2*pi);
Hs = H(idx) - 4*pi/3;
G(idx) = I(idx) .* (1 - S(idx));
B(idx) = I(idx) .* (1 + S(idx) .* cos(Hs) ./ cos(pi/3 - Hs));
R(idx) = 3*I(idx) - (G(idx) + B(idx));

rgb = min(max(cat(3, R, G, B), 0), 1);
end
