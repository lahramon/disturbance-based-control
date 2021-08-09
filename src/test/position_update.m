function [lat_vel,lon_vel] = velocity_degrees(lat,lon,vel_u,vel_v)
    % velocity in m/s
    R = 6371000.785;
    R_lat = R * cos(lat/180*pi);
    % output in degree/s
    lat_vel = arctan(vel_v / R_lat) * 180 / pi;
    lon_vel = arctan(vel_u / R)  * 180 / pi;
end