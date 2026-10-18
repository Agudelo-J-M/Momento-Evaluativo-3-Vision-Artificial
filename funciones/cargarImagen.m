function I = cargarImagen()
% Carga la imagen generada con IA (debe llamarse "imagen_generada.*" y
% estar en la carpeta solucion/imagenes). Si no existe, usa peppers.png
% como imagen de prueba. Se garantiza un tamano 1024x1024x3 uint8.
carpeta = fullfile(fileparts(fileparts(mfilename('fullpath'))), 'imagenes');
archivos = dir(fullfile(carpeta, 'imagen_generada.*'));

if ~isempty(archivos)
    [I, mapa] = imread(fullfile(carpeta, archivos(1).name));
    if ~isempty(mapa), I = ind2rgb(I, mapa); end   % PNG indexado
else
    warning(['No se encontro "imagenes/imagen_generada.*". ' ...
             'Se usa peppers.png como imagen de prueba.']);
    I = imread('peppers.png');
end

if size(I, 3) == 4, I = I(:,:,1:3); end      % quitar canal alfa
if size(I, 3) == 1, I = repmat(I, [1 1 3]); end
I = im2uint8(I);
if ~isequal(size(I), [1024 1024 3])
    I = imresize(I, [1024 1024]);
end
end
