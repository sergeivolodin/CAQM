function [z, c_array] = minimize_z_c(A_, b_, c)
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
    
    while 1
        c_array(:, iteration) = c;
        % c * A
        Ac = get_Ac(A_, c);
        
        % calculating Q and x_0
        [q1, q2] = eig(Ac);
        [q2, q3] = sort(diag(q2));
        q1 = q1(:, q3);
        q2 = diag(q2);
        lambda_min = q2(1, 1);
        x_0 = q1(:, 1);
        Q = Ac - lambda_min * eye(n);
        
        % calculating v
        b_c = b_ * c;
        eps0 = 1e-7;
        Q_inv = pinv(Q, 1e-5);
        v = Q_inv * b_c;

        % z(c)
        z = norm(v) ^ 2;
        
        % (b_c, x_0)
        cbad_distance = x_0' * b_c;

        % check for rank(Q) == n - 1
        if ~(rank(Q, 1e-5) == n - 1)
            display('Rank Q error');
            break;
        end

        fprintf('Gradient step cos=%f Q_norm=%f Rank_Q=%d z(c)=%f c=[%f %f %f] lambda=%f distance=%f\n', cos_theta, norm(Q_inv), rank(Q, 1e-5), z, c(1), c(2), c(3), lambda, cbad_distance);

        % calculating normal and gradient
        dz_dc = zeros(m, 1);
        normal = zeros(m, 1);

        for i = 1:m
            R = A_(:, :, i) - eye(n) * (x_0' * A_(:, :, i) * x_0);
            dz_dc(i) = 2 * v' * Q_inv * (b_(:, i) - R * v);
            normal(i) = (b_(:, i)' - v' * R) * x_0;
        end

        % too small gradient check
        if norm(dz_dc) < eps0
            break
        end

        % calculating c' (c_1)
        delta_c = -dz_dc * 0.01;
        normal = normal / norm(normal);

        if abs(dot(delta_c, normal)) / norm(delta_c) >= (1-1e-5)
            display('gradient parallel to normal vector (end)')
            break;
        end
        
        cos_theta = dot(delta_c, normal) / norm(delta_c);

        c_1 = c + delta_c - normal * dot(delta_c, normal);

        % biggest lambda
        lambda_0 = norm(c_1 - c);

        % binary search forr m(lambda) = 0
        % (projection)
        l = -lambda_0;
        r = lambda_0;

        while (r - l) > 0
            center = (r + l) / 2;
            sign_c = sign(get_m(A_, b_, c_1, normal, x_0, center));
            sign_p = sign(get_m(A_, b_, c_1, normal, x_0, r));
            sign_m = sign(get_m(A_, b_, c_1, normal, x_0, l));

            value = get_m(A_, b_, c_1, normal, x_0, center);

            if abs(value) < 1e-9
                break;
            end

            if ~(sign_c == sign_p)
                l = center;
            elseif ~(sign_c == sign_m)
                r = center;
            else
                display('Error: all signs equal');
                return;
            end

            fprintf('   projection l = %f r = %f val = %f\n', l, r, value);
        end

        % updating c
        lambda = (l + r) / 2;
        c_new = c_1 + lambda * normal;
        c_new = c_new / norm(c_new);
        c = c_new;
        
        iteration = iteration + 1;
    end