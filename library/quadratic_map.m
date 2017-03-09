function y = quadratic_map(A, b, x)
%% y = quadratic_map(A, b, x)
% calculate y(i) = x'Ax+2b'x

%%
    m = size(A, 3);
    y = zeros(m, 1);
    for i = 1:m
        y(i) = x' * A(:, :, i) * x + b(:, i)' * x + x' * b(:, i);
    end
    
    y = real(y);
end