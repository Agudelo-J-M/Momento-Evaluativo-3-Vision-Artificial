function s = transfGamma(r, gamma, c)
% Transformacion gamma (potencia): s = c * r^gamma (sobre r normalizado)
if nargin < 3, c = 1; end
L = rangoMax(r);
rd = double(r) / L;
s  = c * rd .^ gamma;
s  = min(max(s, 0), 1);
s  = cast(s * L, 'like', r);
end
