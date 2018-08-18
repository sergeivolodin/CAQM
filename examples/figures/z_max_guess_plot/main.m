clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('../../maps/article_example06_R4_R4.mat');

z_array = linspace(0, 0.1, 10);

[A_, b_, ~, y0] = change_basis(A, b, c_plus);

load('../../maps/article_example06_R4_R4.mat');
rng(10);
c_plus = get_max_c_plus(A);
for i = 1:100
rng(i);
z_max = get_z_max(A, b, c_plus, 0.1, 10);
if z_max < Inf
    disp(i);
    break
end
end

return;

for z = z_array
    disp(z);
    y = point_inside(A_, b_, c_plus, z);
    try
        c = get_c_minus(A_, b_, y, 1, 0);
    catch
        c = [];
    end
end