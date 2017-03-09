function [A, b] = get_random_f(n, m)
%% get_random_f(n, m)
% obtain random quadratic map A, b

%%
    A = zeros(n, n, m);
    b = zeros(n, m);

    for i = 1:m
        A(:, :, i) = randn(n, n);
        A(:, :, i) = A(:, :, i) + A(:, :, i)';
        b(:, i) = randn(n, 1);
    end

    A(:, :, 1) = A(:, :, 1) + n * eye(n, n);
end

