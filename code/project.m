function [c_new, lambda] = project(A_, b_, c, x_0, delta_c, normal)
    % calculating c' (c_1)
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
end