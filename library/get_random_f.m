function [A, b] = get_random_f(n, m)
%% get_random_f(n, m)
% obtain random quadratic map A, b

%%
    A = zeros(n, n, m);
    b = zeros(n, m);

    for i = 1:m
        A(:, :, i) = rand(n, n);
        A(:, :, i) = A(:, :, i) + A(:, :, i)';
        b(:, i) = rand(n, 1);
    end

    A(:, :, 1) = A(:, :, 1) + 2 * eye(n, n);
end

