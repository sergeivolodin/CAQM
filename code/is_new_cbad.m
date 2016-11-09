function r = is_new_cbad(c_array, c_plus, c)
    s = size(c_array, 2);
    r = 1;
    c = remove_component(c, c_plus);
    c = c / norm(c);
    eps0 = 1e-3;
    for i = 1:s
        c_current = c_array(:, i);
        c_current = remove_component(c_current, c_plus);
        if norm(c_current) < eps0
            continue;
        end
        c_current = c_current / norm(c_current);
        cos_theta = dot(c_current, c);
        if abs(cos_theta) >= 1 - eps0
            %fprintf('found similar i = %d\n', i);
            r = 0;
            break;
        end
    end
end

