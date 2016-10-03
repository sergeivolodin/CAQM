clear all
hold on

% simple 3D artificial example

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

%%
% CERTIFICATE -> SEARCH OF C

if 1
%x0 = randn(n,1); x0 = 2*x0/norm(x0); 
%y0 = zeros(n,1);
%for k = 1:n
%    y0(k,1) = [x0; 1]'*y(:,:,k)*[x0; 1];
%end

y0 = [4; 3.5292; 2.1885; 1.1991];
total = 5e+2;

%cert = certificate_default(y, y0, total);
cert = certificate(y, y0, total);

end

%% GRADIENT
if 0
    res = [];
    c = cert.c_bad(:,1);
    flag = 1;
    count = 0;
     
    while flag
    count = count + 1;
    yc = zeros(n+1, n+1);
    for k = 1:m
        yc = yc + c(k,1)*y(:,:,k);
    end
    
    %Yc = yc(1:n, 1:n);
    Yc = yc(1:n, 1:n)-min(eig(yc(1:n,1:n)))*eye(n)';
  
    [q1,q2] = eig(Yc);
    inde = find(abs(diag(q2))<1e-7);
    x0 = q1(:, inde);
    [U,S,V] = svd(Yc);
    t = diag(S);
    t(abs(t)>1e-7) = t(abs(t)>1e-7).^(-1);
    Ap = V*diag(t)*U';  % pseudo-inverse
    z = norm(Ap*yc(1:n, n+1))^2
    
    gradik = zeros(m,1);
    
    % gradik is c^dot
     no = zeros(m,1);
     no20 = zeros(m,1);
    for k = 1:m
        Adot = y(1:n,1:n,k);
        bdot = y(1:n, n+1, k);
        Ap_dot = -Ap*y(1:n,1:n,k)*Ap + x0*x0'*y(1:n,1:n,k)*Ap*Ap + Ap*Ap*y(1:n,1:n,k)*x0*x0';
        
        gradik(k,1) = yc(1:n, n+1)'*Ap*Ap*y(1:n, n+1, k) + y(1:n, n+1, k)'*Ap*Ap*yc(1:n, n+1)+...
            yc(1:n, n+1)'*(Ap*Ap_dot + Ap_dot*Ap)*yc(1:n, n+1);
        
        no(k,1) = x0'*(y(1:n, n+1, k)-Ap*(y(1:n, 1:n, k)*(eye(n)-x0*x0'))*yc(1:n, n+1));
       % no20(k,1) = x0'*(y(1:n, n+1, k)-Ap*y(1:n, 1:n, k)*yc(1:n, n+1));
    end
    gradik = gradik/norm(gradik);
    cnew = c - (.05/count)*gradik;
  
    y_upd = zeros(n+1, n+1);
       for k = 1:m
        y_upd = y_upd + no(k,1)*y(:,:,k);
    end
    
    keyboard
    c = cnew;
     res(count) = z;
    if count>60
        flag = 0;
    end
    end
end

%%
% post_proc & z_max
if 1
    c_plus = [1; 0; 0; 0];
    y_plus = zeros(n+1, n+1);
    for k = 1:m
        y_plus = y_plus + c_plus(k, 1)*y(:,:,k);
    end 
    x0_plus = -inv(y_plus(1:n, 1:n))*y_plus(1:n, n+1);

for ind = 1:cert.count
    
    cn = cert.c_bad(:,ind)/norm(cert.c_bad(:, ind));
    yc = zeros(n+1, n+1);
    for k = 1:m
        yc = yc + cn(k, 1)*y(:,:,k);
    end 
    
    [U,S,V] = svd(yc(1:n, 1:n));
    t = diag(S);
    t(abs(t)>1e-7) = t(abs(t)>1e-7).^(-1);
    Ap = V*diag(t)*U';
    
    d = -Ap*yc(1:n, n+1) + x0_plus;   
    zm(ind) = d'*y_plus(1:n, 1:n)*d;  
    
    % sphere coordinates
    
end

[zms, sortind] = sort(zm);
colors = colormap(jet);
painter = round(linspace(1, 64, cert.count));

for k = 1:cert.count
    ind = sortind(k);
    
    cn = cert.c_bad(2:end,ind)/norm(cert.c_bad(2:end, ind));
    %dir = cert.directions(:,ind);
    
%     alf = zeros(3,1);
%     alf(3, 1) = acos(cn(4,1));
%     alf(2, 1) = acos( cn(3,1)/sin(alf(3, 1)) );
%     alf(1, 1) = acos( cn(2,1)/( sin(alf(3, 1))*sin(alf(2, 1)) ) );
%     resC(:, ind) = alf;
%     
%     alf = zeros(3,1);
%     alf(3, 1) = acos(dir(4,1));
%     alf(2, 1) = acos( dir(3,1)/sin(alf(3, 1)) );
%     alf(1, 1) = acos( dir(2,1)/( sin(alf(3, 1))*sin(alf(2, 1)) ) );
%     resD(:, ind) = alf;
    
   % subplot(1,2,1); 
   hold on;
   plot3(cn(1,1), cn(2,1), cn(3,1), '.', 'Color', colors(painter(k),:) );
   % subplot(1,2,2); hold on;
   % plot3(resD(1,ind), resD(2,ind), resD(3,ind), '.', 'Color', colors(painter(k),:) );  
end
 
end
% subplot(1,2,1);
% plot3(resC(1,:), resC(2,:), resC(3,:), '.b');
% grid
% subplot(1,2,2);
% plot3(resD(1,:), resD(2,:), resD(3,:), '.r');
% grid;

