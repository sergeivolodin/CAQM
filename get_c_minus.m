function [c, i] = get_c_minus(A, b, y0, MAXITER, DEBUG)
%% [c, iterations_count] = get_c_minus(A, b, y0, max_iterations)
% obtain c from C_-
% using nonconvexity certificate
%
% Format for the map f:
% matrices (A_1, ..., A_m) -> tensor A(i, j, k) -- i'th row, j'th column of matrix A_k
% vectors  (b_1, ..., b_m) -> tensor b(i, j)    -- i'th element          of vector b_j
%
%% example
% 1) loading map from file
% 2) obtaining c_- using y as a point inside image F
%
% clear all;
% load('maps/real_R4_R4.mat');
% x = [1 1 0 0]';
% y = quadratic_map(A, b, x);
% try
%     get_c_minus(A, b, y, 10, 1)
% catch
%     disp('no c_minus obtained');
% end

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
            fprintf('get_c_minus attempt %d\n', i);
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
