clear all

% generating image
n = 4;
m = 4;

n = 4; m = 4;
% ==== MY ARTIFICIAL EXAMPLE =====================
A(:,:,1) = eye(n);
b(:,1) = zeros(n,1);   
y(:,:,1) = [A(:,:,1), b(:,1); b(:,1)', 0];

% for k = 2:n
%     A(:,:,k) = randn(n,n,1);
%     A(:,:,k) = 0.5*(A(:,:,k) + A(:,:,k)');
%     b(:,k) = randn(n, 1);
%     y(:,:,k) = [A(:,:,k), b(:,k); b(:,k)', 0];
% end
y(:,:,2) = [1  0  1  0 1;...
            0  2 -1  4 0;...
            1 -1  0  0 0;...
            0  4  0  0 0;...
            1  0  0  0 0];
        
y(:,:,3) = [ 0  0  0  -1 1;...
             0  3 -1   0 1;...
             0 -1 -1   0 0;...
            -1  0  0  -1 0;...
             1  1  0   0 0];
        
y(:,:,4) = [4  0  1   2 0;...
             0  0  0   4 0;...
             1  0  0   0 0;...
             2  4  0  -2 1;...
             0  0  0   1 0];


for i = 1:m
    A(:, :, i) = y(1:end-1, 1:end-1, i);
    b(:, i) = y(1:end-1, end, i);
end
         
%A = zeros(n, n, m);
%b = zeros(n, m);

%for i = 1:m
 %   A(:, :, i) = rand(n, n);
 %   A(:, :, i) = A(:, :, i) + A(:, :, i)';
  %  b(:, i) = rand(n, 1);
%end

%A(:, :, 1) = A(:, :, 1) + 2 * eye(n, n);

% c, s.t. c * A > 0
display('=== Looking for c+ ===');

%c_plus = get_c_plus(A);

c_plus = [1 0 0 0]';

% basis: c_+A=I, c_+b=0
[A_, b_] = change_basis(A, b, c_plus);

% a point inside F
x0_ = rand(n, 1);
y0_ = quadratic_map(A_, b_, x0_);

% c, s.t. Theorem 3.4 holds
display('=== Looking for c_bad ===');

c_bad_array = [];
c_color = [];

i = 1;
while i <= 1000
    c = get_nonconvex_c(A_, b_, y0_, 1000);
    
    % minimizing z(c)
    display('=== Minimizing z(c) ===');

    [z, c_array, z_array] = minimize_z_c(A_, b_, c, 1);
    
    %display(z);
%    color = 1-((z_array-z_min)/(z_max-z_min))';
    color = [1 0 0];

    s = size(c_array, 2);
    
    c_bad_array(:, end + 1 : end + s) = c_array;
    c_color(end + 1 : end + s, :) = repmat([0.8 1 0.8], s, 1);
    c_color(end, :) = [0 1 0];
    
    c_bad_array(:, end + 1) = c;
    c_color(end + 1, :) = [0 0 1];
    
    %c_bad_array(:, end + 1) = c_array(:, end);
    %c_color(end + 1, :) = [0 1 0];
    i = i + 1;

end

z_value = [];

for i = 1:size(c_bad_array, 2)
    z_value(i) = get_z(A_, b_, c_bad_array(:, i));
end

z_min = min(z_value);
z_max = max(z_value);

z_value = (z_value - z_min) / (z_max - z_min);


%c_color = (c_color' .* repmat(z_value, 3, 1))'


% drawing C_bad
% projecting 4D to 3D
R = [0 1 0 0; 0 0 1 0; 0 0 0 1];
j = R * c_bad_array;

for i = 1:size(j, 2)
    j(:, i) = j(:, i) / norm(j(:, i));
end

scatter3(j(1, :), j(2, :), j(3, :), 36, c_color);