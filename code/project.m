function [c_new, lambda] = project(A_, b_, c, x_0, delta_c, normal, search_area_size)
    lambda = 0;
    c_new = c;

    % calculating c' (c_1)
    c_1 = c + delta_c - normal * dot(delta_c, normal);

    % biggest lambda
    lambda_0 = norm(c_1 - c) * search_area_size;

    % binary search forr m(lambda) = 0
    % (projection)
    l = -lambda_0;
    r = lambda_0;
    
    enlarge_count = 0;
    enlarge_count_max = 10;
    enlarge_base = 2;
    
    i = 1;

    while (r - l) > 1e-8
        center = (r + l) / 2;
        sign_c = sign(get_m(A_, b_, c_1, normal, x_0, center));
        value_p = get_m(A_, b_, c_1, normal, x_0, r);
        sign_p = sign(value_p);
        value_m = get_m(A_, b_, c_1, normal, x_0, l);
        sign_m = sign(value_m);
        
        value = get_m(A_, b_, c_1, normal, x_0, center);
        %fprintf('   projection l = %f (%f %d) r = %f (%f %d) val = %f\n', l, value_m, sign_m, r, value_p, sign_p, value);
    
        if abs(value) < 1e-9
            break;
        end

        if ~(sign_c == sign_p)
            l = center;
        elseif ~(sign_c == sign_m)
            r = center;
        else
            parity = sign(rem(enlarge_count, 2) - 0.5);
            coefficient = enlarge_base ^ enlarge_count;
            if parity > 0
                coefficient = 1 / coefficient;
            end
            r = r * coefficient;
            l = l * coefficient;
            %fprintf('Enlarge l = %f %d r = %f %d c = %f i = %d\n', l, sign_m, r, sign_p, coefficient, i);
            enlarge_count = enlarge_count + 1;
            if enlarge_count >= enlarge_count_max 
                %display('Error: all signs equal');
                c_new = [];
                return;
            end
        end
    
        i = i + 1;
    end

    if abs(value) > 1e-3
        c_new = [];
        return;
    end
    
    % updating c
    lambda = (l + r) / 2;
    c_new = c_1 + lambda * normal;
    c_new = c_new / norm(c_new);
end