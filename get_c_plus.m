function c = get_c_plus(A, DEBUG)
%% get_c_plus(A)
% obtain vector c s.t. c * A > 0
%
% example:
% [A, b] = get_random_f(4, 4);
% c_plus = get_c_plus(A);
% c_plus =
%
%     0.5430
%     0.3073
%    -0.7657
%    -0.1560

%% initializing
    if nargin == 1
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
    while ~found
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
