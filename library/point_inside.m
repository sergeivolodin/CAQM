function y = point_inside(A, b, c_plus, z)
%% y = point_inside(A, b, c_plus, z)
% calculate the point y inside the image F
% as y = y0 + z * c_plus
% where y0 is a touching point for c_plus

%% initialization
    x = -pinv(get_Ac(A, c_plus)) * (b * c_plus);
    y = quadratic_map(A, b, x) + z * c_plus;
end
