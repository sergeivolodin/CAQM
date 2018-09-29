function [c_new, distance] = project_descent(A, b, c, normal_1, normal_2, DEBUG)
%% [c_new, distance] = project_descent(A, b, c, normal_1, normal_2, DEBUG)
% do the projection of point c to c_minus using gradient descent method

%% parameters

    normals = zeros(size(normal_1, 1), 2);
    normals(:, 1) = normal_1;
    normals(:, 2) = normal_2;

    config = get_config();

    eps_tolerance = config.project_descent_max_dist;
    
    alpha_min = config.project_descent_min_alpha;

    if nargin == 5
        DEBUG = 0;
    end
    
    alpha = 1;
    
    theta = config.project_descent_theta;
    
%% initialization

    while 1
        [~, ~, k, ~, ~, ~, ~, ~, ~, drho_dc] = get_dz_dc(A, b, c);
        distance = abs(k' * (b * c));
        
        if DEBUG
            fprintf('  Projection dist=%f alpha=%f\n', distance, alpha);
        end
        
        if distance < eps_tolerance
            break
        end
        
        drho_dc = drho_dc / norm(drho_dc);
        
        while 1
            %c_new = c - alpha * (normals * normals') * drho_dc;
            c_new = c - alpha * drho_dc;
            [~, ~, k, ~, ~, ~, ~, ~, ~, ~] = get_dz_dc(A, b, c_new);
            distance_new = abs(k' * (b * c_new));
            if distance > distance_new
                c = c_new;
                break
            end
            alpha = alpha * theta;
            
            if alpha < alpha_min
                error('Too small alpha');
            end
        end
    end
    
    c_new = c / norm(c);
    distance = abs(distance);
end
