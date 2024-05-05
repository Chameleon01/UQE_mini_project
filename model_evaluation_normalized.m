function model_response = model_evaluation_normalized(U_e, U_v, U_r)
    % This function return the value of the capacitance given the
    % normalized inputs
    model_response = (30 + 0.12 .* U_v) ./ (100 .* pi .* (1000 + 1.5 .* U_r) .* sqrt((100 + 0.45 .* U_e) .^ 2 - (30 + 0.12 .* U_v) .^ 2));
end