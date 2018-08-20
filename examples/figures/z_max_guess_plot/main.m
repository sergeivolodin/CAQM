clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('../../maps/article_example05_R4_R4.mat');

z_array = linspace(0, 0.01, 10);

[A_, b_, ~, y0] = change_basis(A, b, c_plus);

rng(10);
trials = 1500;

ncvx=[];

for z = z_array
    y = point_inside(A_, b_, c_plus, z);
    
    ncvx_this = [];
    
    for i=1:trials
        try
            c = get_c_minus(A_, b_, y, 1, 0);
            ncvx_this(:, end + 1) = c;
            %fprintf('!');
        catch
            c = [];
            %fprintf('X');
        end
    end
    ncvx(end + 1) = size(ncvx_this, 2);
    fprintf(' z=%6f ncvx=%d\n', z, ncvx(end));
end

%%
save('results_neg.mat', 'ncvx', 'z_array', 'trials');
