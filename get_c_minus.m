function [c, i] = get_c_minus(A, b, y0, MAXITER, DEBUG)
%% [c, iterations_count] = get_c_minus(A, b, y0, max_iterations)
% obtain c from C_-
% using nonconvexity certificate
%
% example
% n = 4;
% m = 4;
% [A, b] = get_random_f(n, m);
% x0_ = randn(n, 1);
% y0_ = quadratic_map(A, b, x0_);
% [c, ~] = get_c_minus(A, b, y0_, 1000);

%% initializing

    if nargin == 4
        DEBUG = 0;
    end

    % resulting c
    c = [];
    
    % m dimension
    m = size(A, 3);
    
    % H from article
    H = get_H(A, b);
    
    % is c found?
    found = 0;
    
    % iterator
    i = 0;
    
%% looking for c
    
    % making MAXITER attemts or less
    while (~found) && (i < MAXITER)
        if DEBUG
            fprintf('get_nonconvex_c attempt %d\n', i);
        end
        
        % random direction
        d = randn(m, 1);
        
        % obtaining c via dual problem
        c = get_c_from_d(H, y0, d);
        
        % checking if c is a vector
        if size(c, 1) == m
            % checking nonconvexity
            if is_nonconvex(A, b, c)
                found = 1;
            else
                c = [];
            end
        end
        i = i + 1;
    end
    
    if size(c, 1) == 0
        error('No c_minus found');
    end
    
    % normalizing
    c = c / norm(c);
end
