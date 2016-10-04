function Ac = GetAc(A, c)
sz = size(A);
n = sz(1);
Ac = zeros(n, n);
for i = 1:n
    Ac = Ac + c(i) * A(:,:,i);
end
end