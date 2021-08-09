function [vel_u, vel_v] = wind_velocity(lat,lon,z_index,t,opts_input)
    nc=ncgeodataset('C:\Users\amonl\Repositories\disturbance-based-control\data\gfsanl_4_2017070100.g2\gfs_4_20170701_0000_000.grb2');
    dirvar_u=nc.geovariable('u-component_of_wind_height_above_ground');
    dirvar_v=nc.geovariable('v-component_of_wind_height_above_ground');
    dir_u=dirvar_u.data(1,z_index,:,:);
    dir_v=dirvar_v.data(1,z_index,:,:);
    dir_u = reshape(dir_u,size(dir_u,3),size(dir_u,4));
    dir_v = reshape(dir_v,size(dir_v,3),size(dir_v,4));
    
    % get grid at 1st time step
    g=dirvar_v.grid_interop(1,:,:);
    [X_lon,Y_lat] = meshgrid(g.lon,g.lat);
    
    % interpolate
    vel_u = interp2(X_lon,Y_lat,dir_u,lon,lat);
    vel_v = interp2(X_lon,Y_lat,dir_v,lon,lat);
    
%     % just take closest grid point
%     [~,lat_index] = min(abs(g.lat-lat));
%     [~,lon_index] = min(abs(g.lon-lon));
%     vel_u = dir_u(lat_index,lon_index);
%     vel_v = dir_v(lat_index,lon_index);
    
    % uotput in deg/s
    % length of a
end