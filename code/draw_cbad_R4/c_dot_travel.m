clear all

% getting an image

load('example03.mat');

% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

c_start = [];
c_array = [];
z_value = [];

item_size = [];

i = 1;
j = 1;
N = 1;

max_c_attempts = 20;
x_search_size = 1;

while i <= N
    % a point inside F
    x0_ = rand(n, 1) * x_search_size;
    y0_ = quadratic_map(A_, b_, x0_);
    
    c = get_nonconvex_c(A_, b_, y0_, c_start, c_plus, max_c_attempts);
    if size(c, 1) == 0
        fprintf('i = %d j = %d C not found\n', i, j, k);
        j = j + 1;
        continue
    end
    c = remove_component(c, c_plus);
    c = c / norm(c);
    
    fprintf('i = %d j = %d Found c', i, j);
    
    [~, ~, ~, ~, ~, ~, ~, normal] = get_gradient(A_, b_, c);
    X = [];
    X(1, :) = normal;
    X(2, :) = c_plus;
    X(3, :) = c;
    
    N = null(X);
    sz = size(N, 2);
    if sz > 1
        fprintf('Wrong sz = %d', sz);
        continue;
    end
    c_dot = N;
    
    c_start(:, end + 1) = c;
    
    i = i + 1;
    j = j + 1;
end