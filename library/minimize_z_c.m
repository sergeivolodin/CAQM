function [z, c_array, z_array] = minimize_z_c(A, b, c, c_plus, beta_initial, max_step, DEBUG)
%% [z_result, c_path_array, z_array] = minimize_z_c(A, b,
% c_minus_start, c_plus, step_coefficient, max_step)
% minimize z(c) over C_minus using gradient descent with projection

%% parameters

    if nargin == 6
        DEBUG = 0;
    end

    % tolerance for ||dz_dc|| =0
    eps_norm = get_config().descent_min_norm;
    
    % maximal value for abs(z)
    eps_z = get_config().descent_max_z;
    
    % tolerance for rank(Q) == n - 1
    eps_rank = get_config().descent_rank_Q;
    
    % minimal value for beta
    % after which iterations stop
    beta_min = get_config().descent_min_beta;
    
    % theta multiplier for beta
    theta = get_config().descent_theta;
    
    %% initializing
    % dimensions
    n = size(A, 1);
    m = size(A, 3);
    
    % lambda for c'
    lambda = 0;
    
    % angle between normal and dz_dc
    cos_theta = 0;
    % second normal
    cos_theta_1 = 0;
    
    % thresold value for dz_dc || n
    cos_theta_max = get_config().descent_max_cos;

    % resulting z
    z = inf;
    
    % iteration counter
    i = 1;
    
    % array for resulting c_s
    c_array = zeros(m, 1);
    
    % array for resulting z(c)
    z_array = zeros(1);
    
    % step (beta parameter)
    beta = beta_initial * theta;
    
    % is task in real numbers?
    is_real = isreal(A) && isreal(b);
    
    while 1
        % calculating gradient
        [Q, Q_inv, x_0, ~, ~, z, dz_dc, normal, normal_1] = get_dz_dc(A, b, c);
        
        % storing data
        c_array(:, i) = c;
        z_array(i) = z;

        % checking if z is too big
        if abs(z) >= eps_z
            if DEBUG
                fprintf('Gradient descent finished: z(c)=%f value too big\n', z);
            end
            break;
        end

        % checking for dimensionality
        if (is_real && m <= 3) || (~is_real && m <= 4)
            if DEBUG
                fprintf('Gradient descent unnecessary: discrete C_-\n', z);
            end
            break;
        end
        
        % check for rank(Q) == n - 1
        if ~(rank(Q, eps_rank) == n - 1)
            if DEBUG
                fprintf('Gradient descent finished: %d = rankQ != n - 1 = %d; z=%f\n', rank(Q, eps_rank), n - 1, z);
            end
            break;
        end

        % distance to c_minus (b_c, x_0)
        c_minus_distance = x_0' * (b * c);
        
        if is_real
            bad_dz_dc = [normal c_plus];
        else
            bad_dz_dc = [normal normal_1 c_plus];
        end
        
        good_dz_dc = null(bad_dz_dc');
        dz_dc_tangent = good_dz_dc * good_dz_dc' * dz_dc;
        
        % intermediate result
        if DEBUG
            fprintf('Gradient descent cosRe=%.5f cosIm=%.5f grad_tan=%.5f |Q|=%.2f RgQ=%d z=%.6f lam=%.2f dist=%.10f beta=%.10f\n', ...
                abs(cos_theta), abs(cos_theta_1), norm(dz_dc_tangent),...
                norm(Q_inv), rank(Q, eps_rank), z, lambda, abs(c_minus_distance), beta);
        end

        % small gradient check
        if (norm(dz_dc) < eps_norm) || (norm(normal) < eps_norm) ||...
                (~is_real && norm(dz_dc_tangent) < eps_norm)
            if DEBUG
                disp('Gradient descent finished: tangent part of the gradient is too small, or the normal is too small')
            end
            break
        end

        % cos between dz_dc and normal
        cos_theta   = dot(dz_dc, normal) / norm(dz_dc);
        cos_theta_1 = dot(dz_dc, normal_1) / norm(dz_dc);
        
        % checking if dz_dc parallel normal
        if (abs(cos_theta) >= cos_theta_max) || (~is_real && (abs(cos_theta_1) >= cos_theta_max))
            if DEBUG
                disp('Gradient descent finished: gradient parallel to normal vector')
            end
            break;
        end

        % projecting c + delta_c to c_minus
        beta = beta / theta;
        
        dz_dc_tangent = dz_dc_tangent / norm(dz_dc_tangent);
        
        c_new = [];

        % found a new c?
        new_c_found = 0;
        
        % cycle over beta
        while abs(beta) >= beta_min
            % initial non-projected delta c
            delta_c = -dz_dc_tangent * beta;
            
            try
                % trying projection for given delta_c
                if is_real
                    [c_new, ~] = project(A, b, c, x_0, delta_c, normal, 1);
                else
                    c_new = project_descent(A, b, c + delta_c, normal, normal_1);
                end
                
                % checking new value z_new(c_new)
                [~, ~, ~, ~, ~, z_new, ~, ~] = get_dz_dc(A, b, c_new);
                
                % checking if value is smaller (bigger)
                % and if c_new is not too far from c
                if ((z_new - z) * beta < 0) && ...
                    cminus_distance(c_new, c_plus, c) <= max_step
                    new_c_found = 1;
                    break;
                end
            catch
                
            end
            
            % decreasing beta
            % in case projection failed
            beta = beta * theta;
        end
        
        % projection succeeded but the constraints were not met
        if new_c_found == 0
            if DEBUG
                disp('Gradient descent finished: projection leads too far or the value of z(c) increased');
            end
            break;
        end
        
        % projection failed for all beta
        if size(c_new, 1) == 0
            if DEBUG
                disp('Gradient descent finished: Projection failed');
            end
            break;
        end
        
        c = c_new;
        i = i + 1;
    end
end
