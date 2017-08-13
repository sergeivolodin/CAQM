function z_max = get_z_max(A, b, c_plus, z_max_guess, k, DEBUG)
%% z_max = get_z_max(A, b, c_plus, z_max_guess, k)
% obtain z_max = inf z(c) over C_- using at most
% k iterations of get_c_minus
%
% Format for the map f:
% matrices (A_1, ..., A_m) -> tensor A(i, j, k) -- i'th row, j'th column of matrix A_k
% vectors  (b_1, ..., b_m) -> tensor b(i, j)    -- i'th element          of vector b_j
%
% y = y_0 - z_max_guess * c_plus
% where y_0 is the boundary point which is touched by hyperplane c_plus
%
%% example
% 1) loading map from file
% 2) obtaining c_plus for map
% 3) minimizing z(c) over c_- using k = 1 starting point
%
% clear all;
% load('maps/real_R4_R4.mat');
% c_plus = get_c_plus(A, 10, 1);
% get_z_max(A, b, c_plus, 0.01, 10)

%%
    if nargin == 5
        DEBUG = 0;
    end

%%
    y = point_inside(A, b, c_plus, z_max_guess);

%% basis: c_+A=I, c_+b=0
    [A_, b_, ~, y0] = change_basis(A, b, c_plus);

% new y0 for A_, b_
    y = y - y0;

% resulting z
    z_array = Inf(k + 1, 1);

    % resulting c
    c_array = zeros(size(A, 3), k);

    % how many c found
    found = 0;

    if DEBUG
        h = waitbar(0, 'Nonconvexity cert.: starting jobs');
    end

    % m dimension
    m = size(A, 3);
    % H from article
    H = get_H(A, b);

    % vectors d
    D = randn(m, k);

    % obtaining c via dual problem from d
    get_c_d = @(d) get_c_from_d(H, y, d);
    p = gcp();

    for i = 1:k
        f(i) = parfeval(p, get_c_d, 1, D(:, i));
    end

    for i = 1:k
        [idx, c] = fetchNext(f);
        if norm(c) > 0 && is_nonconvex(A, b, c)
            c = c / norm(c);
            found = found + 1;
            c_array(:, i) = c;
        end
        if DEBUG
            s = sprintf('Nonconvexity cert. %d/%d, found %d, success %.1f%%', i, k, found, 100. * found / i);
            waitbar(1. * i / k, h, s);
        end
    end

    if DEBUG
        close(h);
        h = waitbar(0, 'Gradient descent');
    end

    processed = 0;

    for i = 1:k
        try
            % minimizing z(c)
            if norm(c_array(:, i)) > 0
                if DEBUG
                    s = sprintf('Gradient descent %d/%d', processed, found);
                    waitbar(1. * processed / found, h, s);
                end
                [z, ~, ~] = minimize_z_c(A_, b_, c_array(:, i), c_plus, 1, 1, DEBUG);

                % adding z(c^*) to z_array
                z_array(end + 1) = z;
                processed = processed + 1;
            end
        catch
            continue
        end
    end

    if DEBUG
        close(h);
    end

    z_max = min(z_array);
end
