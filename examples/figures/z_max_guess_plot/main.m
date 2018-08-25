clear all;

% changing cwd to directory of .m file
cd(fileparts(which(mfilename)));

% loading map
load('../../maps/article_example05_R4_R4.mat');

% name for the output file
name = 'bigger4';

% number of trials per one z
trials = 1500;

% array of zs (change with name)
z_array = linspace(0, 500000, 30);

%% fixing the random seed
rng(10);

% array of number of nonconvexities
ncvx = [];

% array with nonconvexities
ncvx_c = [];

% loop over z values
for z = z_array
    % point y_boundary + z * c_plus
    y = point_inside(A, b, c_plus, z);
    
    % nonconvexities for this y
    ncvx_this = [];
    
    % loop over trials
    for i = 1:trials
        % trying to get a nonconvexity
        try
            c = get_c_minus(A, b, y, 1, 0);

            % saving it if found
            ncvx_this(:, end + 1) = c;
        catch
            c = [];
        end
    end

    % saving the size of nonconvexities
    ncvx(end + 1) = size(ncvx_this, 2);

    % displaying the number of nonconvexities for this z
    fprintf(' z=%6f ncvx=%d\n', z, ncvx(end));
end

% saving data
save(sprintf('results_%s.mat', name), 'ncvx', 'z_array', 'trials');

%% plotting the array
scatter(z_array, ncvx);
