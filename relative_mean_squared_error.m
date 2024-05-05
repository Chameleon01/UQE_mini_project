function error = relative_mean_squared_error(YPCE, Y)
% RELATIVE_MEAN_SQUARED_ERROR Calculate the relative mean squared error of the PCE model.
%
% Parameters:
%   YPCE : The predicted values by the PCE model.
%   Y : The actual values of the output variable.
%
% Returns:
%   error : The normalized empirical error of the PCE model.

    error = sum((Y - YPCE).^2) / sum((Y - mean(Y)).^2);

end