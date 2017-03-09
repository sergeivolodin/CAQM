function [A, b] = get_random_f(n, m, complex)
%% get_random_f(n, m)
% obtain random quadratic map A, b

%%
    if nargin == 2
        complex = 0;
    end 

    A = zeros(n, n, m);
    b = zeros(n, m);

    for i = 1:m
        if complex
            A(:, :, i) = (randn(n, n) + 1i * randn(n, n)) / sqrt(2);
            A(:, :, i) = A(:, :, i) + A(:, :, i)';
            b(:, i) = (randn(n, 1) + 1i * randn(n, 1)) / sqrt(2);
        else
            A(:, :, i) = randn(n, n);
            A(:, :, i) = A(:, :, i) + A(:, :, i)';
            b(:, i) = randn(n, 1);
        end
    end

    A(:, :, 1) = A(:, :, 1) + n * eye(n, n);
end

