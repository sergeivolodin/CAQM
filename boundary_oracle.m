function [t, is_in_F] = boundary_oracle(A, b, y, d)
% TODO: description
%% [t, is_in_F] = boundary_oracle(A, b, y, d)
% get maximal t
% s.t. y+td in G = convF
% returns is_in_F if y+td is also in F
%
% Format for the map f:
% matrices (A_1, ..., A_m) -> tensor A(i, j, k) -- i'th row, j'th column of matrix A_k
% vectors  (b_1, ..., b_m) -> tensor b(i, j)    -- i'th element          of vector b_j
%
%% example
% 1) loading map from file
% 2) calculating y = f(x) for pre-defined x
% 3) running boundary oracle for y and pre-defined d
%
% clear all;
% load('maps/real_R4_R4.mat');
% x = [1 2 3 4]';
% y = quadratic_map(A, b, x);
% d = [4 3 2 1]';
% try
%     boundary_oracle(A, b, y, d)
% catch
%     disp('optimization failed');
% end
% ans = 193.3203

%% configuration
    rank_eps = 1e-3;

%% dimensions & init
    n = size(A, 1);
    m = size(A, 3);
    
    H = get_H(A, b);
    
    t = 0;
    is_in_F = 0;

%% solve task (4)
    cvx_clear;
    cvx_quiet true;
    
    cvx_begin
        % X vector from the article
        variable X(n + 1, n + 1);
        
        % resulting t
        variable t;
        
        % objective
        maximize(t)
        
        X == X';
        
        for i = 1:m
            trace(H(:, :, i) * X) == y(i) + t * d(i);
        end
        
        X == hermitian_semidefinite(n + 1);
        X(n + 1, n + 1) == 1
    cvx_end
    
%% no result (infeasible)
    if cvx_optval ~= Inf
        is_in_F = (rank(X, rank_eps) == 1);
    else
        error('Boundary oracle failed');
    end
end

