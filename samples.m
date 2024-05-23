function [U_e, U_v, U_r] = samples(N_samples, strategy)
    % GET_SAMPLES Generate samples for the input variables.
    %
    % Parameters:
    %   N_samples : the number of samples to generate.
    %   strategy : The sampling strategy : 'lhs' for Latin Hypercube Sampling and 'random' for random sampling.
    %
    % Returns:
    %   U_e : The samples for the normalized input variable U_e.
    %   U_v : The samples for the normalized input variable U_v.
    %   U_r : The samples for the normalized input variable U_r.
    
    % Probabilistic model parameters (means and standard deviations for U_e, U_v, U_r)
    mu = [0, 0, 0]; % Mean zero for normalization
    sigma = [1, 1, 1]; % Standard deviation of 1 for all

    % Generate samples for the input variables
    switch strategy
        case 'lhs'
            % Latin Hypercube Sampling
            % samples = norminv(lhsdesign(N_samples, 3));
            samples = 1;
        case 'random'
            % Random sampling
            samples = randn(N_samples, 3);
        otherwise
            error('Invalid sampling strategy. Please choose either "lhs" or "random".')
    end
    
    % Normalize the samples
    U_e = mu(1) + sigma(1) * samples(:, 1);
    U_v = mu(2) + sigma(2) * samples(:, 2);
    U_r = mu(3) + sigma(3) * samples(:, 3);
    
end
