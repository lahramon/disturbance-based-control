% create ncgeodataset object
nc=ncgeodataset('C:\Users\amonl\Repositories\disturbance-based-control\data\gfsanl_4_2017070100.g2\gfs_4_20170701_0000_000.grb2');

% list variables
nc.variables

% create geovariable object
dirvar_u=nc.geovariable('u-component_of_wind_height_above_ground');
dirvar_v=nc.geovariable('v-component_of_wind_height_above_ground');

dirvar_u_sigma=nc.geovariable('u-component_of_wind_sigma');
dirvar_v_sigma=nc.geovariable('v-component_of_wind_sigma');

% get data at 1st time step, 1st height (4D object)
dir_u=dirvar_u.data(1,1,:,:);
dir_v=dirvar_v.data(1,1,:,:);
dir_u = reshape(dir_u,size(dir_u,3),size(dir_u,4));
dir_v = reshape(dir_v,size(dir_v,3),size(dir_v,4));

dir_u_sigma=dirvar_u.data(1,1,:,:);
dir_v_sigma=dirvar_v.data(1,1,:,:);
dir_u_sigma = reshape(dir_u_sigma,size(dir_u_sigma,3),size(dir_u_sigma,4));
dir_v_sigma = reshape(dir_v_sigma,size(dir_v_sigma,3),size(dir_v_sigma,4));

% get grid at 1st time step
g=dirvar_v.grid_interop(1,:,:);

% magnitude wind velocity
mag = sqrt(dir_u.^2 + dir_v.^2);

% U = longitude, V = latitute
% plot
figure;
pcolorjw(g.lon,g.lat,mag);
hold on
quiver(g.lon,g.lat,0.5*dir_u./mag,0.5*dir_v./mag)
title(datestr(g.time))
