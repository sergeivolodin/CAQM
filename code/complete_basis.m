function R = complete_basis(v)
    n = size(v, 1);
    S(:, 1) = v;
    %S(:, 2) = v;
    S(:, 2:n) = rand(n, n - 1);
    [S1, ~] = qr(S);
    R = S1(:, 2:end);
end