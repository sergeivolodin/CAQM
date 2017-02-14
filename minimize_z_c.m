function [z, c_array, z_array, success] = minimize_z_c(A_, b_, c, c_plus, coefficient, max_step_sin)
    success = 1;
    % dimensions
    n = size(A_, 1);
    m = size(A_, 3);
    
    % lambda for c'
    lambda = 0;
    % angle between normal and dz_dc
    cos_theta = 0;

    % resulting z
    z = inf;
    
    % iteration counter
    iteration = 1;
    
    % array for resulting c_s
    c_array = zeros(m, 1);
    z_array = zeros(1);
    
    step = 1;
    
    while 1
        % calculating gradient
        [Q, Q_inv, x_0, ~, ~, z, dz_dc, normal] = get_gradient(A_, b_, c);
        
        % storing data
        c_array(:, iteration) = c;
        z_array(iteration) = z;
        
        eps0 = 1e-7;

        if abs(z) >= 1e9
            display('z value too big!');
            break;
        end
        
        % check for rank(Q) == n - 1
        if ~(rank(Q, 1e-5) == n - 1)
            success = 0;
            display('Rank Q error');
            break;
        end

        % (b_c, x_0)
        cbad_distance = x_0' * (b_ * c);
        
        fprintf('Gradient step cos=%f Q_norm=%f Rank_Q=%d z(c)=%f c=[%f %f %f] lambda=%f distance=%f step=%f\n', cos_theta, ...
            norm(Q_inv), rank(Q, 1e-5), z, c(1), c(2), c(3), lambda, cbad_distance, step);

        % too small gradient check
        if (norm(dz_dc) < eps0) || (norm(normal) < eps0)
            display('norm too small (end)')
            break
        end

        cos_theta = dot(dz_dc, normal) / norm(dz_dc);
        
        if abs(cos_theta) >= (1-1e-5)
            display('gradient parallel to normal vector (end)')
            break;
        end
        
        % projecting c + delta_c to c_bad
        shrink_base = 0.5;
        shrink_max = 50;
        shrink_i = 0;
        
        grad_tangent = dz_dc - normal * dot(dz_dc, normal);
        grad_tangent = grad_tangent / norm(grad_tangent);
        
        while shrink_i <= shrink_max
            step = (shrink_base ^ shrink_i) * coefficient;
            delta_c = -grad_tangent * step;
            [c_new, lambda] = project(A_, b_, c, x_0, delta_c, normal, 1);
        
            if size(c_new, 1) > 0
                [~, ~, ~, ~, ~, z_new, ~, ~] = get_gradient(A_, b_, c_new);
                ok = 0;
                if z_new < z && coefficient > 0
                    ok = 1;
                end
                if z_new > z && coefficient < 0
                    ok = 1;
                end
                
                if ok && min_sin_cbad(c_new, c_plus, c) <= max_step_sin
                    break;
                end
            end
            
            shrink_i = shrink_i + 1;
        end
        
        if size(c_new, 1) == 0
            success = 0;
            display('Projection failed');
            return;
        end
        
        c = c_new;
        iteration = iteration + 1;
    end
end