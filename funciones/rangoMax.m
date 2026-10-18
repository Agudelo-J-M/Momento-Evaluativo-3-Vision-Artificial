function L = rangoMax(img)
% Devuelve el valor maximo del rango dinamico segun la clase de la imagen
% (255 para uint8, 65535 para uint16, 1 para double/single).
if isinteger(img)
    L = double(intmax(class(img)));
else
    L = 1;
end
end
