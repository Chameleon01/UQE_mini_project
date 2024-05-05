% Validation: evaluation of the metamodel on a new set of points

validationSampleSets = 1e4;
numberOfVariables = 3;
degreeOfPCE = 5;

% Let's sample the space with LHS methods
uniDistribValidationSet = lhsdesign(validationSampleSets, numberOfVariables);

% Let's convert our freshly generated validation set into a normal distribution
normalizedValidationSet = cdf('Normal',uniDistribValidationSet, 0, 1);


function error = get_error(PCE_model, validationSets)
% GET_ERROR  Compute the empirical error between the model and the given surrogate model based on the given validation set.

    % Now we just need to apply those value to the analitical model to find the values of the original model:
    yValidation = model_evaluation_normalized(physicalValidationSet);

    % Let's get now the values returned by the surogate model:
    ySurogate = PCE(uniDistirbValidationSet, degreeOfPCE);

    error = sum((yValidation - ySurogate)**2)/length(yValidation)
end


error = zeros(degreeOfPCE,1)

for degree = 1:degreeOfPCE
    error(degree) = get_error(PCE(degree), normalizedValidationSet);
end

plot(error)


%%%% LOO




