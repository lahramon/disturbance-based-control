k = 2;
b = .5;
r = 1;
omega = 1.8;

f = @(t,x) [ x(2);
             -k * x(2) - x(3) + b; % r * cos(omega * t)
             3 * x(1).^2 * x(2) - x(2) ];



x_0 = [ 0;
        0;
        0];
    

t = linspace(0, 1000, 10000);

[TOUT, YOUT] = ode45(f, t, x_0);

plot3(YOUT(:,1),YOUT(:,2),YOUT(:,3));