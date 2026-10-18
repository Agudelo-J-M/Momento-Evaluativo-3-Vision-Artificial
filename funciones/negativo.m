function s = negativo(r)
% Transformacion negativo: s = (L-1) - r
L = rangoMax(r);
s = cast(L - double(r), 'like', r);
end
