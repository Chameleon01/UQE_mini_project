%% Sampling the experimental design

% Define number of training samples
N_samples = 1000;

% Generate the training set
[U_e_train, U_v_train, U_r_train] = samples(N_samples, 'random');
C_train = model_evaluation_normalized(U_e_train, U_v_train, U_r_train);

%% Construction of the PCE model
max_degree = 4;
degree_range = 0:max_degree;
% Create the surrogate surrogate_models for each degree
surrogate_models = cell(max_degree+1, 1);
for degree = degree_range
    PCE = PolynomialChaosExpension(degree);
    PCE = PCE.train([U_e_train, U_v_train, U_r_train], C_train);
    surrogate_models{degree+1} = PCE;
end

%% Numerical Experiment

% Generate the test set
N_samples_test = 1e4;
[U_e_test, U_v_test, U_r_test] = samples(N_samples_test, 'random');
C_test = model_evaluation_normalized(U_e_test, U_v_test, U_r_test);

%% Leave one out error

% Evaluate the models on the test data
errors = zeros(max_degree+1, 1);
for degree = degree_range
    C_pred = surrogate_models{degree+1}.eval([U_e_test, U_v_test, U_r_test]);
    errors(degree+1) = relative_mean_squared_error(C_pred, C_test);
end

semilogy(degree_range, errors, 'o-');
xlabel('Polynomial degree');
ylabel('Empirical error');

% Evaluate the models on the test data
loo_errors = zeros(max_degree+1, 1);
for degree = degree_range
    loo_errors(degree+1) = surrogate_models{degree+1}.compute_leave_one_out_error([U_e_train, U_v_train, U_r_train], C_train);
end

hold on;
semilogy(degree_range, loo_errors, 'o-');
hold off;

