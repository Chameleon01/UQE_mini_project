function H = eval_hermite(X, deg)
% Evaluate the Hermite polynomial of degree deg
% for x-values given in a vector X

% Ensure that the degree is non-negative
if deg < 0
    error('The degree should be at least 0!')
end

% Compute the Hermite polynomials
if deg == 0
    H = ones(size(X)); % H_0 = 1
elseif deg == 1
    H = 2*X; % H_1 = 2X
else
    % Initialize recursion
    H_nminus1 = ones(size(X)); % H_0
    H_n = 2*X; % H_1
    
    for n = 1:(deg-1)
        % Apply the recursion rule for deg >= 2
        H_nplus1 = 2*X.*H_n - 2*n*H_nminus1; % Element-wise multiplication
        % Update for the next iteration
        H_nminus1 = H_n; % Update H_nminus1 first
        H_n = H_nplus1; % Now update H_n
    end
    
    % H contains the evaluations of the Hermite polynomial of degree deg
    H = H_nplus1;
end
% Normalize polynomial
H = H/sqrt(factorial(deg));

end
