% stable dynamics
% A = [-2 0.5; 1 -1];
% B = [-1; 1];
% A1 = [0 0; 0 0];
% B1 = [0; 1];
% C = [1 0; 0 1];
% D = [0; 0];
% 

% % purely imaginary eigenvalues (no damping)
A = [0 1; -1 0];
B = [0; 1];
A1 = [0 0; 0 0];
B1 = [0; 0];
C = [1 0; 0 1];
D = [0; 0];

% observer gain
% L = place(A1',C',[-20;-20])';
L = zeros(2);

DL = [D zeros(2)];

% initial condition for actual system
x0 = [1.5; 1];
x0 = 10*x0; %.*(1+0.5*rand(2,1));

% initial condition for "known" system
x0_1 = 1.2 * x0;