function [t, is_in_F] = boundary_oracle(A, b, y, d)
%% [t, is_in_F] = boundary_oracle(A, b, y, d)
% get maximal t
% s.t. y+td in G = convF
% returns is_in_F if y+td is also in F

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
        
        X == semidefinite(n + 1);
        X(n + 1, n + 1) == 1
    cvx_end
    
 %% no result (infeasible)
    if cvx_optval ~= Inf
        is_in_F = (rank(X, rank_eps) == 1);
    else
        error('Boundary oracle failed');
    end
end

