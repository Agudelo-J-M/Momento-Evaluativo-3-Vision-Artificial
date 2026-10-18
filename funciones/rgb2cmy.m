function cmy = rgb2cmy(rgb)
% RGB -> CMY : [C M Y] = (L-1) - [R G B]
cmy = negativo(rgb);
end
