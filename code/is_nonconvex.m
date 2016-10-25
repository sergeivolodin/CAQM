function r = is_nonconvex(A, b, c)
    eps0 = 1e-7;

    n = size(A, 1);
    m = size(A, 3);

    assert(n>=3);
    assert(m>=3);
    r = 0;
    bc = b * c;
    Ac = get_Ac(A, c);
    [q1, q2] = eig(Ac);
    [q2, q3] = sort(diag(q2));
    q1 = q1(:, q3);
    inde = find(abs(eig(Ac)) < eps0);
    if size(inde,1) == 1
        %display('simple zero')
        e = q1(:, inde);
        if abs(dot(q1(:, 1), bc)) < eps0
            % remove parallel check
            r = 1;
            return;
            
            %display('bc*e=0')
            e0 = -pinv(Ac) * bc;
            f1 = zeros(m, 1);
            f2 = zeros(m, 1);

            for j = 1:m
                f1(j) = e' * A(:, :, j) * e0 + b(:, j)' * e;
                f2(j) = e' * A(:, :, j) * e;
            end

            costheta = abs(dot(f1, f2)/(norm(f1) * norm(f2)));
            if costheta < 1 - eps0
                r = 1;
                %display('nonconvex!');
            end
        end
    end
end