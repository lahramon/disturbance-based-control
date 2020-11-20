transition = inf (20, 20, 3);

B_1 = repmat([0.9 0.05 0.05], 20, 1);
B_2 = repmat([0.05 0.9 0.05], 20, 1);
B_3 = repmat([0.05 0.05 0.9], 20, 1);


transition(:,:,1) = -log(full(spdiags(B_1, [-1 0 1], 20, 20)));
transition(:,:,2) = -log(full(spdiags(B_2, [-1 0 1], 20, 20)));
transition(:,:,3) = -log(full(spdiags(B_3, [-1 0 1], 20, 20)));

treye = full(spdiags(repmat([1 1 1],20,1),[-1 0 1],20,20));
transition2D = zeros(400,400,3);
transition2D(:,:,1) = kron(treye,transition(:,:,1));
transition2D(:,:,2) = kron(treye,transition(:,:,2));
transition2D(:,:,3) = kron(treye,transition(:,:,3));

transition2D(isnan(transition2D)) = Inf;
transition2D(transition2D == 0) = Inf;

transition2D(isinf(transition2D)) = 10000;

c2d = Control2D(20,20,3,transition2D);
validatorOccupancyMap(c2d);
c2d_val = validatorOccupancyMap(c2d);
planner = plannerRRT(c2d,c2d_val);
planner.MaxConnectionDistance = 1;
c2d_val.ValidationDistance = 1;

[path, solution_info] = plan(planner,[1.1 1.1 1.1],[10 10 1]);