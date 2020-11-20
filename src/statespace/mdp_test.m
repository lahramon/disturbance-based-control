nx = 5;
ny = 5;
niveau = zeros(nx,ny);

x = linspace(0,1,nx);
%y = linspace(0,1,ny);
y = linspace(1,0,ny);

[X,Y] = meshgrid(x,y);

target = [0.1; 0.1];

target_X_diff = target(1) - X;
target_Y_diff = target(2) - Y;

target_R_diff = sqrt(target_X_diff.^2 + target_Y_diff.^2);
niveau = 1 - target_R_diff;
niveau_vec = [reshape(niveau,numel(niveau),1); nan];
reward = (niveau_vec - niveau_vec');
reward = repmat(reward,1,1,3);
reward(isnan(reward)) = -1;
reward(end,end) = 0;

% transition matrix
transition_local_1 = randfixedsum(9,1,1,0,1);
transition_local_2 = randfixedsum(9,1,1,0,1);
transition_local_3 = randfixedsum(9,1,1,0,1);

nu = 3;
transition = inf (nx, ny, nu);
transition2D = zeros(nx^2+1,nx^2+1,nu);
transition2D(1:nx^2,1:nx^2,1) = spdiags(repmat(transition_local_1',nx^2,1), [-nx-1 -nx -nx+1 -1 0 1 nx-1 nx nx+1], nx^2, nx^2);
transition2D(1:nx^2,1:nx^2,2) = spdiags(repmat(transition_local_2',nx^2,1), [-nx-1 -nx -nx+1 -1 0 1 nx-1 nx nx+1], nx^2, nx^2);
transition2D(1:nx^2,1:nx^2,3) = spdiags(repmat(transition_local_3',nx^2,1), [-nx-1 -nx -nx+1 -1 0 1 nx-1 nx nx+1], nx^2, nx^2);
transition2D(end,:,:) = 1 - sum(transition2D,1);
transition2D = permute(transition2D,[2 1 3]);

% B_1 = repmat([0.9 0.05 0.05], nx, 1);
% B_2 = repmat([0.05 0.9 0.05], nx, 1);
% B_3 = repmat([0.05 0.05 0.9], nx, 1);
% 
% transition(:,:,1) = full(spdiags(B_1, [-1 0 1], nx, nx));
% transition(:,:,2) = full(spdiags(B_2, [-1 0 1], nx, nx));
% transition(:,:,3) = full(spdiags(B_3, [-1 0 1], nx, nx));
% 
% treye = full(spdiags(repmat([1 1 1],nx,1),[-1 0 1],nx,nx));
% transition2D = zeros(nx^2,nx^2,nu);
% transition2D(:,:,1) = kron(treye,transition(:,:,1));
% transition2D(:,:,2) = kron(treye,transition(:,:,2));
% transition2D(:,:,3) = kron(treye,transition(:,:,3));

% planning
[policy_val, iter_val, cpu_time_val] = mdp_value_iteration(transition2D, reward, 0.95);
[V_pol, policy_pol] = mdp_policy_iteration(transition2D, reward, 0.95);
[V_fin, policy_fin] = mdp_finite_horizon(transition2D, reward, 0.95, 30);

% plot
phi = linspace(0,2*pi-2*pi/8,8);
vec = exp(i*phi);
vec_x = real(vec);
vec_y = imag(vec);
vec = [vec_x; vec_y];

vec_1 = repmat(transition_local_1([1:4 6:9])',2,1).*vec;
vec_2 = repmat(transition_local_2([1:4 6:9])',2,1).*vec;
vec_3 = repmat(transition_local_3([1:4 6:9])',2,1).*vec;

