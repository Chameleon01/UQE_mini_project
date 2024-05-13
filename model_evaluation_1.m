%% Non-normalized original model

function model_response = model_evaluation_1(X)
    % This function return the value of the capacitance given the
    % non-normalized input.
    E = X(:, 1); % voltage across the voltage source (V)
    Vr = X(:, 2); % voltage across the shunt resistor (V)
    R = X(:, 3); % shunt resistance (ohm)
    model_response = Vr./(100*pi.*R.*sqrt(E.^2-Vr.^2));
end