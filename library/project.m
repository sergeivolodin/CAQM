function [c_new, lambda] = project(A, b, c, x_0, delta_c, normal, search_area_size, DEBUG)
%% [c_new, lambda] = project(A, b, c, x_0, delta_c, normal, search_area_size)
% do the projection of point c to c_minus using bisection method

%% parameters

    if nargin == 7
        DEBUG = 0;
    end

    config = get_config();
    
    % minimal value
    % for r - l
    min_rl = config.project_bisection_min_rl;
    
    % if r - l > min_rl
    % but value < min_value
    % stop
    min_value = config.project_bisection_min_value;
    
    % if bisection stopped
    % but value > max_value
    % throw error
    max_value = config.project_bisection_max_value;
    
%% initialization

    % calculating c' (c_1)
    c_1 = c + delta_c;

    % biggest lambda
    lambda_0 = norm(c_1 - c) * search_area_size;

    % binary search forr m(lambda) = 0
    % (projection)
    l = -lambda_0;
    r = lambda_0;
    
    i = 1;
    
    while (r - l) > min_rl
        center = (r + l) / 2;
        sign_c = sign(get_m(A, b, c_1, normal, x_0, center));
        value_p = get_m(A, b, c_1, normal, x_0, r);
        sign_p = sign(value_p);
        value_m = get_m(A, b, c_1, normal, x_0, l);
        sign_m = sign(value_m);
        
        value = get_m(A, b, c_1, normal, x_0, center);
        
        if DEBUG
            fprintf('  Projection l=%f/%f r=%f/%f val=%f\n', l, value_m, r, value_p, value);
        end
    
        if abs(value) < min_value
            break;
        end

        if ~(sign_c == sign_p)
            l = center;
        elseif ~(sign_c == sign_m)
            r = center;
        else
            error('  Projection error: All signs equal');
        end
    
        i = i + 1;
    end
    
    if ~exist('value')
        error('  Projection error: Empty search area');
    end

    if abs(value) > max_value
        error('  Projection error: Too big value');
    end
    
    % updating c
    lambda = (l + r) / 2;
    c_new = c_1 + lambda * normal;
    c_new = c_new / norm(c_new);
end
