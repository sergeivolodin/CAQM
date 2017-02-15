function H = get_H(A, b)
% get H matrices [A_i, b_i; b_i', 0] from A, b
% see Theorem 3.1

n = size(A, 1);
    m = size(A, 3);
    H = zeros(n + 1, n + 1, m);
    for j = 1:m
        H(:, :, j) = [A(:, :, j), b(:, j); b(:, j)', 0];
    end
end