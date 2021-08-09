lat_start = 52.52;
lon_start = 13.405;
y0 = [lat_start; lon_start];

[tout,yout] = ode45(@odefun_latlon,[0 1e6],y0);

open_grb2;
plot(yout(:,2),yout(:,1),'LineWidth',5,'Color','red')

function dangle = odefun_latlon(t,angle)
    lat = angle(1);
    lon = angle(2);
    [vel_u, vel_v] = wind_velocity(lat,lon,1,t);
    [lat_vel,lon_vel] = velocity_degrees(lat,lon,vel_u,vel_v);
    dangle = [lat_vel; lon_vel];
end

