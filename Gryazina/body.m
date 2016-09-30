clear all

% uses certificate_default.m, certificate_z.m, c_search.m
% gen_rand_image.m 

%% PARAMS

n = 3;
m = 3;

x0 = randn(n,1); x0 = 2*x0/norm(x0);   % point
z = 1;          % default starting value 
total = 1e+3;   % the number of random directions for certification
tot_count = 10; % the number of bisection iterations
%%
% load/gen data

%[A, b] = gen_rand_image(n, m, 'c'); 
%A(:, :, 1) = eye(n); b(:, 1) = zeros(n,1); % to guarantee c_plus

% ==== MY ARTIFICIAL EXAMPLE =====================
% three nonconvexities 
A(:, :, 1) = [1 1 1; 1 2 0; 1 0 2];
A(:, :, 2) = [3 -1 0; -1 0 -1; 0 -1 1];
A(:, :, 3) = eye(n);

b(:, 1) = [1; 1; 1];
b(:, 2) = [1; 0; -1];
b(:, 3) = [0; 0; 0];
% =================================================

y = zeros(n+1, n+1, m);
for k = 1:m
    y(:,:,k) = real([A(:,:,k), b(:,k); b(:,k)', 0]);
end

% ==================================================

% y(:,:,1) = [-2 .5+.5i .5; .5-.5i 0 0; .5 0 0];
% y(:,:,2) = [1 -.5+.5i .5i; -.5-.5i 0 0; -.5i 0 0];
% y(:,:,3) = [0 .5-.5i 0; .5+.5i -1 0; 0 0 0];
% y(:,:,4) = [0 -.5-.5i 0; -.5+.5i 1 0; 0 0 0];


%% default certificate: random starting point


y0 = zeros(m,1);
for k = 1:m
    y0(k,1) = real([x0; 1]'*y(:,:,k)*[x0; 1]);
end

cert = certificate_default(y, y0, total);
cert.result

disp('press any key...')
pause

%% specify c+ and find z: F \cap {(c+, f) < z} is convex

if cert.detect == 1
    %c_plus = c_search(y);
    c_plus = [0; 0; 1];
    count = 0;
    flag = 0;
    z_up = []; z_low = [];
    
while ~flag
    count = count + 1;
    cert = [];
    cert = certificate_z(y, y0, total, c_plus, z);
    
    switch cert.detect
        case 0
            mess = sprintf('Runout of %d random directions. Convexity is assumed for (c+,f) = %g. Continute....', total, z);
            disp(mess)
            z_low = z;
            if isempty(z_up)
                z = 2*z;
            else
                z = (z_up + z)/2;
            end
        case 1
            mess = sprintf('Nonconvexity is detected for (c+,f) = %g. Continue...', z);
            disp(mess)
            z_up = z;
            if isempty(z_low)
                z = z/2;
            else
                z = (z_low + z)/2;
            end
        case 2
            disp(cert.result)
            flag = 1;        
        otherwise
            disp('Unexpected error')
            flag = 1;
    end
 
    
    if count == tot_count
         if isempty(z_low)
             mess = sprintf('The part of image is nonconvex for (c+,f) > %g.', z_up);
         elseif isempty(z_up)
             mess = sprintf('The part of image is convex for (c+, f) < %g.', z_low);
         else
             mess = sprintf('The part of image is convex for (c+, f) < %g and nonconvex for (c+,f) > %g.', z_low, z_up);
         end
         disp(mess)
         flag = 1;
    end
end


end