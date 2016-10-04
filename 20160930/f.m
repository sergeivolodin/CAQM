function y = f(A, x)
sz = size(A);
m = sz(3);
n = sz(1);
y = zeros(m, 1);
for i = 1:n
    y(i) = x' * A(:, :, i) * x;
end
end