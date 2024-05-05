function error = empirical_error(YPCE, Y)
% EMPIRICAL_ERROR Calculate the empirical error of the PCE model.
%
% Parameters:
%   YPCE : The predicted values by the PCE model.
%   Y : The actual values of the output variable.
%
% Returns:
%   error : The empirical error of the PCE model.

    error = sum((Y - YPCE).^2)/length(Y);

end