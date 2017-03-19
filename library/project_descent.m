function [c_new, distance] = project_descent(A, b, c, normal_1, normal_2, DEBUG)
%% [c_new, lambda] = project(A, b, c, x_0, delta_c, normal, search_area_size)
% do the projection of point c to c_minus using bisection method

%% parameters

    normals = zeros(size(normal_1, 1), 2);
    normals(:, 1) = normal_1;
    normals(:, 2) = normal_2;

    eps_tolerance = 1e-10;
    
    alpha_min = 1e-20;

    if nargin == 5
        DEBUG = 0;
    end
    
    alpha = 1;
    
    theta = 0.4;
    
%% initialization

    while 1
        [~, ~, k, ~, ~, ~, ~, ~, ~, drho_dc] = get_dz_dc(A, b, c);
        distance = abs(k' * (b * c));
        
        if DEBUG
            fprintf('Project Descent dist = %f alpha = %f\n', distance, alpha);
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
    
    c_new = c;
    distance = abs(distance);
end