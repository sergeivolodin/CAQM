function is_infeasible = infeasibility_oracle(A, b, y)
%% is_infeasible = infeasibility_oracle(A, b, y)
% check if the point y is infeasible
% if is_infeasible = 0, then feasibility is uncertain

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
        minimize(1)
        
        H_c - 0.0001 * eye(n + 1) == semidefinite(n + 1);
    cvx_end
    
    % no result (infeasible)
    if cvx_optval ~= Inf
        is_infeasible = 1;
        %disp(cvx_optval)
    end
end

