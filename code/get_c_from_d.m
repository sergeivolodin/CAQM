% get normal vector for a hyperplanetouching at y \in F
% where y = y^0 + td, t --> max
% see equations (4) and (5)

% H_ -- matrices [A_i, b_i; b_i', 0]
% y0 -- starting point y^0
% d -- direction

function c = get_c_from_d(H_, y0, d)
    % size of spaces (n --> m)
    m = size(H_, 3);
    n = size(H_, 1) - 1;
    
    cvx_clear;
    cvx_quiet true;
    
    % minimization task (5)
    cvx_begin
        % variables: gamma -- scalar, c -- vector
        variable gam
        % c vector
        variable c(m)
        
        % objective
        minimize(gam + dot(c, y0))
        
        % H = c * H_ (eq 5)
        H = get_Ac(H_, c);
        H(end, end) = H(end, end) + gam;
        
        % (c, d) = -1 constraint
        c' * d == -1;
        
        % H >= 0 constraint
        H == semidefinite(n + 1);
    cvx_end
    
    % no result (infeasible)
    if cvx_optval == Inf
        c = [];
    end
end