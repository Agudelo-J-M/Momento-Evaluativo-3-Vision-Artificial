function s = transfLogaritmica(r)
% Transformacion logaritmica: s = c*log(1+r), con c tal que (L-1) -> (L-1)
L = rangoMax(r);
rd = double(r) / L;                 % normalizar a [0,1]
c  = 1 / log(2);                    % log(1+1)*c = 1
s  = c * log(1 + rd);
s  = cast(s * L, 'like', r);
end
