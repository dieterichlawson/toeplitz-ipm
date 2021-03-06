rng(9058);

% set up
m = 10;
n = 20;
A = rand(m,n);
x = rand(n,1);
b = A*x;
c = rand(n,1);
fprintf('Creating a feasible starting point...\n')
% create a feasible starting point
tic
cvx_begin quiet
    variable X(n,n) Toeplitz Semidefinite
    minimize 0
    subject to
        A*X(1,:)' == b
cvx_end
toc
X = (X + diag(diag(X)));
x_0 = X(1,:)';

fprintf('Solving with the barrier method.\n')
mu=20;
tic
x_bm = fs_barrier_method(c, A, b, x_0, 1e-4, mu, @barrier, n+1);
toc

fprintf('Solving with cvx.\n')
tic
cvx_begin quiet
    variable X(n,n) Toeplitz Semidefinite
    minimize (c'*X(1,:))
    subject to
        A*X(1,:)' == b
cvx_end
toc
x_cvx = X(1,:)

norm