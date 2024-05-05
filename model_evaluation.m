%% DO NOT USE THIS FUNCTION IN THE PCE MODEL

function model_response = model_evaluation(E, Vr, R)
    % This function return the value of the capacitance given the
    % non-normalized input.
    model_response = Vr / (100 * pi * R * sqrt(E ^ 2 - Vr ^ 2));
end