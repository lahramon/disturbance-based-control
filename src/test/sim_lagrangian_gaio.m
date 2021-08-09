lat_start = 52.52;
lon_start = 13.405;
y0 = [lat_start; lon_start];

% [tout,yout] = ode45(@odefun_latlon,[0 1e6],y0);
h = 0.05;
n = 5;
f = @(x) rk4(@(x) odefun_latlon(0,x)',x,h,n); 

% get grid at 1st time step
nc=ncgeodataset('C:\Users\amonl\Repositories\disturbance-based-control\data\gfsanl_4_2017070100.g2\gfs_4_20170701_0000_000.grb2');
dirvar_u=nc.geovariable('u-component_of_wind_height_above_ground');
dirvar_v=nc.geovariable('v-component_of_wind_height_above_ground');
g=dirvar_v.grid_interop(1,:,:);
[X_lon,Y_lat] = meshgrid(g.lon,g.lat);
Xpositions = [ X_lon(:) Y_lat(:)];

% only one sample point
% X = y0';
X = y0' + (10*rand(100,2)-5); 

c = [180 0]; 
r = [180, 90]; 
t = Tree(c,r);   % the box collection

% computing the covering (here, by continuation)
depth = 10; 
t.insert([y0'; -y0']', depth);         % initialization
gum(t, f, X, depth);                             % global unstable manifold

for i = 1:size(Xpositions,1)
    t.insert(Xpositions(i,:)',0)
end
P = tpmatrix(t, f, X, depth, 1);
[w,lambda] = eigs(P,2,'lr');                % eigenvectors

wp = log10(max(w(:,2),1e-16))-log10(max(-w(:,2),1e-16)); % 2nd eigenvector 
clf; boxplot3(t,'depth',depth,'density', wp,'alpha',0.1);   
% load lorenz_cmap; colormap(cmap); colorbar       % special colormap
% view(20,20); axis square; axis tight;
% xlabel('x'); ylabel('y'); zlabel('z'); 

open_grb2;
% plot(yout(:,2),yout(:,1),'LineWidth',5,'Color','red')

function dangle = odefun_latlon(t,angle)
    lat = angle(1);
    lon = angle(2);
    [vel_u, vel_v] = wind_velocity(lat,lon,1,t);
    [lat_vel,lon_vel] = velocity_degrees(lat,lon,vel_u,vel_v);
    dangle = [lat_vel; lon_vel];
end

