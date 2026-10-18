function s = transfLogaritmica(r)
% Transformacion logaritmica: s = c*log(1+r), con r en la escala [0,255] y
% c = 255/log(1+255) para que el nivel maximo se mantenga en el maximo.
% Funciona con imagenes uint8 o double (en [0,1]); devuelve la misma clase.
L  = rangoMax(r);
rd = double(r) * (255 / L);         % llevar a la escala 0-255
c  = 255 / log(1 + 255);
s  = c * log(1 + rd);
s  = cast(s * (L / 255), 'like', r);
end
