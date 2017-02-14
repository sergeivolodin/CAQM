function [c_array] = c_dot_travel_single(A_, b_, c, c_plus, coefficient, min_sin)
    % dimensions
    n = size(A_, 1);
    m = size(A_, 3);
    
    % lambda for c'
    lambda = 0;
    
    % iteration counter
    iteration = 1;
    
    % array for resulting c_s
    c_array = [];
    z_array = [];
    
    step = 1;
    
    eps0 = 1e-7;
    
    c_start = c;
    c_dot_prev = zeros(m, 1);
    
    while 1
        % calculating gradient
        [Q, Q_inv, x_0, ~, ~, z, dz_dc, normal] = get_gradient(A_, b_, c);
        
        % storing data
        c_array(:, iteration) = c;
        z_array(iteration) = z;
        
        % (b_c, x_0)
        cbad_distance = x_0' * (b_ * c);
        cos_theta = dot(normal, dz_dc) / norm(dz_dc) / norm(normal);

        c_dot = null([normal c_plus c]');
        
        fprintf('C_bad step cos=%f Q_norm=%f Rank_Q=%d z(c)=%f c=[%f %f %f] lambda=%f distance=%f step=%f\n', cos_theta, ...
            norm(Q_inv), rank(Q, 1e-5), z, c(1), c(2), c(3), lambda, cbad_distance, step);
        
        if iteration > 10 && min_sin_cbad(c_start, c_plus, c) < min_sin
            fprintf('circle min_sin %f\n', min_sin);
            break;
        end

        
        if abs(z) >= 1e9
            display('z value too big!');
            break;
        end
        
        % check for rank(Q) == n - 1
        if ~(rank(Q, 1e-5) == n - 1)
            display('Rank Q error');
            break;
        end
        
        if size(c_dot, 2) > 1
            fprintf('Wrong sz c_dot\n');
            break;
        end

        % too small gradient check
        if (norm(c_dot) < eps0) || (norm(normal) < eps0)
            display('norm too small (end)')
            break
        end
        
        % projecting c + delta_c to c_bad
        shrink_base = 0.5;
        shrink_max = 50;
        shrink_i = 0;
        
        c_dot = c_dot / norm(c_dot);
        if dot(c_dot, c_dot_prev) < 0
            c_dot = -c_dot;
        end
        c_dot_prev = c_dot;
        
        while shrink_i <= shrink_max
            step = (shrink_base ^ shrink_i) * coefficient;
            delta_c = c_dot * step;
            [c_new, lambda] = project(A_, b_, c, x_0, delta_c, normal, 1);
        
            if size(c_new, 1) > 0
                if min_sin_cbad(c_new, c_plus, c) <= min_sin
                    break;
                end
            end
            
            shrink_i = shrink_i + 1;
        end
        
        if size(c_new, 1) == 0
            display('Projection failed');
            return;
        end
        
        c = c_new;
        iteration = iteration + 1;
    end

end