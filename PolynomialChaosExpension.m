 classdef PolynomialChaosExpension
    properties
        polynomial_degree;
        coefficients;
        A_train;
    end

    methods

        function obj = PolynomialChaosExpension(degree)
            obj.polynomial_degree = degree;
        end


        function obj = train(obj, X_train, C_train)
        % TRAIN train the PCE model.
        %
        % Parameters:
        %   X_train (matrix): The input training points. Each column corresponds to a different input variable.
        %   C_train (vector): The output training points.

            % Build the regression matrix for training data
            alphas = create_alphas(3,obj.polynomial_degree);
            A_train = [];
            for i = 1:size(alphas,1)
                A_train = [A_train, eval_hermite(X_train(:,1), alphas(i,1)) .* eval_hermite(X_train(:,2), alphas(i,2)) .* eval_hermite(X_train(:,3), alphas(i,3))];
            end

            obj.A_train = A_train;

            % Solve for polynomial coefficients using least squares
            obj.coefficients = A_train \ C_train;

            disp('Training complete')
        end

        function C_pred = eval(obj, X_eval)
        % EVAL evaluate the PCE model at the given input points.
        %
        % Parameters:
        %   X_eval (matrix): The input points to evaluate the model at. Each column corresponds to a different input variable.
        %
        % Returns:
        %   C_pred (vector): The predicted values of the polynomial chaos expansion model at the input points.

            if isempty(obj.coefficients)
                error('The model is not trained yet. Please train it before evaluating.')
            end

            % Rebuild regression matrix for test data
            alphas = create_alphas(3,obj.polynomial_degree);
            A_eval = [];
            for j = 1:size(alphas,1)
                A_eval = [A_eval, eval_hermite(X_eval(:,1), alphas(j,1)) .* eval_hermite(X_eval(:,2), alphas(j,2)) .* eval_hermite(X_eval(:,3), alphas(j,3))];
            end


            % Get the predicted values
            C_pred = A_eval * obj.coefficients;
        end

        function error = compute_leave_one_out_error(obj, X_train, C_train)
        % COMPUTE_LEAVE_ONE_OUT_ERROR compute the leave-one-out error of the PCE model.
        %
        % Parameters:
        %   X_train : The input training points.
        %   C_train : The output training points.
        %
        % Returns:
        %   error : The leave-one-out error of the PCE model.

            % Initialize error
            h_mat = obj.A_train*pinv(obj.A_train'*obj.A_train)*obj.A_train';

            C_pred = obj.eval(X_train);
            error = sum(((C_train - C_pred)./(1-diag(h_mat))).^2)/length(C_train);
        end

    end
end
