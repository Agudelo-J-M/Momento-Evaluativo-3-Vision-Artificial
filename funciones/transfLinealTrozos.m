function s = transfLinealTrozos(r, r1, s1, r2, s2)
% Transformacion lineal a trozos (estiramiento de contraste) definida por
% los puntos (0,0), (r1,s1), (r2,s2) y (L-1,L-1). r1,s1,r2,s2 se expresan
% en el mismo rango que la imagen (p. ej. 0-255 para uint8).
L  = rangoMax(r);
rd = double(r);
s  = zeros(size(rd));

m1 = rd <= r1;
m2 = rd > r1 & rd <= r2;
m3 = rd > r2;

s(m1) = (s1 / r1) * rd(m1);
s(m2) = s1 + (s2 - s1) / (r2 - r1) * (rd(m2) - r1);
s(m3) = s2 + (L - s2) / (L - r2) * (rd(m3) - r2);

s = cast(s, 'like', r);
end
