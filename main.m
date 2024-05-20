%% Sampling the experimental design

% Define number of training samples
N_samples = 60;

% Generate the training set
[U_e_train, U_v_train, U_r_train] = samples(N_samples, 'random');
C_train = model_evaluation_normalized(U_e_train, U_v_train, U_r_train);

%% Construction of the PCE model
max_degree = 5;
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

semilogy(degree_range, errors, 'o-','LineWidth',1.5)
grid on
xlabel('Polynomial degree','FontSize',14)
ylabel('Empirical error','FontSize',14)

% Evaluate the models on the test data
loo_errors = zeros(max_degree+1, 1);
for degree = degree_range
    loo_errors(degree+1) = surrogate_models{degree+1}.compute_leave_one_out_error([U_e_train, U_v_train, U_r_train], C_train);
end

hold on;
semilogy(degree_range, loo_errors, 'o-','LineWidth',1.5)
legend('Relative mean squared error', 'Leave one out error','FontSize',14)
hold off;

%% Moments comparison
mean_test = mean(C_test)
mean_vs_degree = zeros(length(degree_range), 1);
for degree = degree_range
    mean_vs_degree(degree+1) = surrogate_models{degree+1}.coefficients(1)
end
figure
plot(degree_range, mean_vs_degree,'LineWidth',1.5)
grid on
xlabel('degree','FontSize',14)
ylabel('mean','FontSize',14)

var_test = var(C_test)
var_vs_degree = zeros(length(degree_range), 1);
for degree = degree_range
    var_vs_degree(degree+1) = sum(surrogate_models{degree+1}.coefficients(2:end).^2)
end

figure
hold on
plot(degree_range, var_test,'--' ,'LineWidth',1.5)
plot(degree_range, var_vs_degree,'LineWidth',1.5)
grid on
xlabel('degree','FontSize',14)
ylabel('variance','FontSize',14)
hold off
%% Variation of training set size

degree = 3;
degree_2 = 4;

% Define number of training samples
training_set_size = linspace(10,60,25);

surrogate_models_vs_train_size = cell(length(training_set_size), 1);
surrogate_models_2 = cell(length(training_set_size), 1);
for i = 1:length(training_set_size)
    % Generate the training set
    [U_e_train, U_v_train, U_r_train] = samples(int32(training_set_size(i)), 'random');
    C_train = model_evaluation_normalized(U_e_train, U_v_train, U_r_train);

    %% Construction of the PCE model
    PCE = PolynomialChaosExpension(degree);
    PCE = PCE.train([U_e_train, U_v_train, U_r_train], C_train);
    surrogate_models{i} = PCE;

    PCE = PolynomialChaosExpension(degree_2);
    PCE = PCE.train([U_e_train, U_v_train, U_r_train], C_train);
    surrogate_models_2{i} = PCE;
end

%% Moments comparison
mean_vs_training_set = zeros(length(training_set_size), 2);
for i = 1:length(training_set_size)
    mean_vs_training_set(i,1) = surrogate_models{i}.coefficients(1);
    mean_vs_training_set(i,2) = surrogate_models_2{i}.coefficients(1);
end
figure
semilogy(training_set_size, mean_vs_training_set,'-o','LineWidth',1.5)
grid on
xlabel('size of experimental design','FontSize',14)
ylabel('mean','FontSize',14)
legend(['PCE degree ' int2str(degree)], ['PCE degree ' int2str(degree_2)],'FontSize',14)

figure

var_vs_training_set = zeros(length(training_set_size), 2);
for i = 1:length(training_set_size)
    var_vs_training_set(i, 1) = sum(surrogate_models{i}.coefficients(2:end).^2);
    var_vs_training_set(i, 2) = sum(surrogate_models_2{i}.coefficients(2:end).^2);
end

semilogy(training_set_size, var_vs_training_set,'-o','LineWidth',1.5)
grid on
xlabel('size of experimental design','FontSize',14)
ylabel('variance','FontSize',14)
legend(['PCE degree ' int2str(degree)], ['PCE degree ' int2str(degree_2)],'FontSize',14)
