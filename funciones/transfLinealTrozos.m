function s = transfLinealTrozos(r, r1, s1, r2, s2)
% Transformacion lineal a trozos (estiramiento de contraste) definida por
% los puntos (0,0), (r1,s1), (r2,s2) y (255,255). Los parametros r1,s1,r2,s2
% se expresan siempre en la escala 0-255, sin importar la clase de la imagen
% (uint8 o double en [0,1]); devuelve la misma clase de la entrada.
L  = rangoMax(r);
rd = double(r) * (255 / L);         % llevar a la escala 0-255
s  = zeros(size(rd));

m1 = rd <= r1;
m2 = rd > r1 & rd <= r2;
m3 = rd > r2;

s(m1) = (s1 / r1) * rd(m1);
s(m2) = s1 + (s2 - s1) / (r2 - r1) * (rd(m2) - r1);
s(m3) = s2 + (255 - s2) / (255 - r2) * (rd(m3) - r2);

s = cast(s * (L / 255), 'like', r);
end
