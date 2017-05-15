function c = get_c_plus(A, k, DEBUG)
%% get_c_plus(A)
% obtain vector c s.t. c * A > 0
% use at most k iterations
%
% Format for the map f:
% matrices (A_1, ..., A_m) -> tensor A(i, j, k) -- i'th row, j'th column of matrix A_k
% vectors  (b_1, ..., b_m) -> tensor b(i, j)    -- i'th element          of vector b_j
%
%% example:
% 1) loading map from file
% 2) obtaining c_plus using 10 iterations at most
%
% clear all;
% load('maps/real_R4_R4.mat');
% try
%     get_c_plus(A, 10, 1)
% catch
%     disp('no c_plus obtained');
% end

%% initializing
    if nargin == 2
        DEBUG = 0;
    end

    % resulting c
    c = [];
    
    % is c found?
    found = 0;
    
    % dimensions
    m = size(A, 3);
    
    % iterator
    i = 0;
    
    cvx_clear;
    cvx_quiet true;
    
%% looking for c_plus
    while ~found && i < k
        if DEBUG
            fprintf('get_c_plus attempt %d\n', i);
        end
        
        % choosing p for diversity
        p = randn(m, 1);
        
        try
            c = get_near_c_plus(A, p);
            found = 1;
        catch
            
        end
         
        i = i + 1;
    end
    
    if found == 0
        error('No c_plus found');
    end
    
    % normalizing
    c = c / norm(c);
end
