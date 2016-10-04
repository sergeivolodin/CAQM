function r = fxy(A, x, y)
sz = size(A);
m = sz(3);
n = sz(1);
r = zeros(m, 1);
for i = 1:n
    r(i) = x' * A(:, :, i) * y;
end
end