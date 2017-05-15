function is_infeasible = infeasibility_oracle(A, b, y)
%% is_infeasible = infeasibility_oracle(A, b, y)
% check if the point y is infeasible
% if is_infeasible = 0, then feasibility is uncertain
%
% Format for the map f:
% matrices (A_1, ..., A_m) -> tensor A(i, j, k) -- i'th row, j'th column of matrix A_k
% vectors  (b_1, ..., b_m) -> tensor b(i, j)    -- i'th element          of vector b_j
%
%% example
% 1) loading map from file
% 2) checking infeasibility of a vector y
%
% clear all;
% load('maps/real_R4_R4.mat');
% y = [0 1000 0 0]';
% infeasibility_oracle(A, b, y)
% 1

%%
    n = size(A, 1);
    m = size(A, 3);
    
    cvx_clear;
    cvx_quiet true;
    
    is_infeasible = 0;
    
    cvx_begin
        % c vector
        variable c(m)
        
        H_c = get_H_c(A, b, c, y);
        
        % objective
        minimize(c' * c)
        
        H_c - eye(n + 1) == hermitian_semidefinite(n + 1);
    cvx_end
    
    % no result (infeasible)
    if cvx_optval ~= Inf
        is_infeasible = 1;
    end
end

