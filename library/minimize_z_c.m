function [z, c_array, z_array] = minimize_z_c(A, b, c, c_plus, beta_initial, max_step, DEBUG)
%% [z_result, c_path_array, z_array] = minimize_z_c(A, b,
% c_minus_start, c_plus, step_coefficient, max_step)
% minimize z(c) over C_minus using gradient descent with projection

%% parameters

    if nargin == 6
        DEBUG = 0;
    end

    % tolerance for ||dz_dc|| =0
    eps_norm = 1e-7;
    
    % maximal value for abs(z)
    eps_z = 1e9;
    
    % tolerance for rank(Q) == n - 1
    eps_rank = 1e-5;
    
    % minimal value for beta
    % after which iterations stop
    beta_min = 1e-15;
    
    % theta multiplier for beta
    theta = 0.5;
    
    %% initializing
    % dimensions
    n = size(A, 1);
    m = size(A, 3);
    
    % lambda for c'
    lambda = 0;
    
    % angle between normal and dz_dc
    cos_theta = 0;

    % resulting z
    z = inf;
    
    % iteration counter
    i = 1;
    
    % array for resulting c_s
    c_array = zeros(m, 1);
    
    % array for resulting z(c)
    z_array = zeros(1);
    
    % step (beta parameter)
    beta = 0;
    
    while 1
        % calculating gradient
        [Q, Q_inv, x_0, ~, ~, z, dz_dc, normal] = get_dz_dc(A, b, c);
        
        % storing data
        c_array(:, i) = c;
        z_array(i) = z;

        % checking if z is too big
        if abs(z) >= eps_z
            error('z value too big!');
        end
        
        % check for rank(Q) == n - 1
        if ~(rank(Q, eps_rank) == n - 1)
            error('Rank Q error');
        end

        % distance to c_minus (b_c, x_0)
        c_minus_distance = x_0' * (b * c);
        
        % intermediate result
        if DEBUG
            fprintf('Gradient step cos=%.2f Q_norm=%.2f Rank_Q=%d z(c)=%.4f lambda=%.2f distance=%.2f beta=%.2f\n', abs(cos_theta), ...
                norm(Q_inv), rank(Q, eps_rank), z, lambda, abs(c_minus_distance), beta);
        end

        % too small gradient check
        if (norm(dz_dc) < eps_norm) || (norm(normal) < eps_norm)
            if DEBUG
                disp('norm too small (end)')
            end
            break
        end

        % cos between dz_dc and normal
        cos_theta = dot(dz_dc, normal) / norm(dz_dc);
        
        % checking if dz_dc parallel normal
        if abs(cos_theta) >= (1-1e-5)
            if DEBUG
                disp('gradient parallel to normal vector (end)')
            end
            break;
        end
        
        % projecting c + delta_c to c_minus
        beta = beta_initial;
        
        % removing normal projection of dz_dc
        dz_dc_tangent = remove_component(dz_dc, normal);
        dz_dc_tangent = dz_dc_tangent / norm(dz_dc_tangent);
        
        % cycle over beta
        while abs(beta) >= beta_min
            % initial non-projected delta c
            delta_c = -dz_dc_tangent * beta;
            
            try
                % trying projection for given delta_c
                [c_new, ~] = project(A, b, c, x_0, delta_c, normal, 1);
        
                % checking new value z_new(c_new)
                [~, ~, ~, ~, ~, z_new, ~, ~] = get_dz_dc(A, b, c_new);
                
                % checking if value is smaller (bigger)
                % and if c_new is not too far from c
                if ((z_new - z) * beta < 0) && ...
                    cminus_distance(c_new, c_plus, c) <= max_step
                    break;
                end
            catch
                
            end
            
            % decreasing beta
            % in case projection failed
            beta = beta * theta;
        end
        
        % projection failed for all beta
        if size(c_new, 1) == 0
            error('Projection failed');
        end
        
        c = c_new;
        i = i + 1;
    end
end