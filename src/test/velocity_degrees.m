function [lat_vel,lon_vel] = velocity_degrees(lat,lon,vel_u,vel_v)
    % velocity in m/s
    R = 6371000.785;
    R_lat = R * cos(lat/180*pi);
    % output in degree/s
    lat_vel = vel_v / R * 180 / pi;
    lon_vel = vel_u / R_lat  * 180 / pi;
end