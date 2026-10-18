function rgb = cmy2rgb(cmy)
% CMY -> RGB : [R G B] = (L-1) - [C M Y]
rgb = negativo(cmy);
end
