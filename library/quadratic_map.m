function y = quadratic_map(A, b, x)
%% y = quadratic_map(A, b, x)
% calculate y(i) = x'Ax+2b'x

%%
    m = size(A, 3);
    y = zeros(m, 1);
    for i = 1:m
        y(i) = x' * A(:, :, i) * x + 2 * b(:, i)' * x;
    end
end