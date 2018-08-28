clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('../../maps/article_example06_R4_R4.mat');

% for minimizing z
[A_, b_, ~, y0] = change_basis(A, b, c_plus);

% name for the output file
name = 'ex06_zc_big';

% number of trials per one z
trials = 1500;

% array of zs (change with name)
z_array = linspace(0, 0.5, 20);

%% fixing the random seed
rng(10);

% array of number of nonconvexities
ncvx = [];

% array with nonconvexities
ncvx_c = [];

% min_branch z(c)
z_min_array = [];

% iterator
k = 1;

% loop over z values
for z = z_array
    % point y_boundary + z * c_plus
    y = point_inside(A, b, c_plus, z);
    
    % nonconvexities for this y
    ncvx_this = [];
    
    % minimal z for this y
    z_this = [];
    
    % loop over trials
    for i = 1:trials
        % trying to get a nonconvexity
        try
            % obtaining c
            c = get_c_minus(A, b, y, 1, 0);

            % saving it if found
            ncvx_this(:, end + 1) = c;
            
            % doing gradient descent, saving result
            z_this(end + 1) = minimize_z_c(A_, b_, c, c_plus, 1, 1, 1);
        catch
            c = [];
        end
    end

    % number of nonconvexities discovered
    sz = size(ncvx_this, 2);
    
    % saving the size of nonconvexities
    ncvx(end + 1) = sz;
    
    % saving cs
    ncvx_c(k, :, 1 : sz) = ncvx_this;
    
    % saving min z
    z_min_array(k, 1 : sz) = z_this;

    % displaying the number of nonconvexities for this z
    fprintf(' z=%6f ncvx=%d\n', z, ncvx(end));
    
    % increasing counter
    k = k + 1;
end

% saving data
save(sprintf('results_%s.mat', name), 'ncvx', 'z_array', 'z_min_array', 'ncvx_c', 'trials');

%% plotting the array
scatter(z_array, ncvx / trials);
