function ref = Get1DTargetPtoP(maxRange)
% every sub-loop specify position target
% set otner state variable reference value to zero

% back and fourth
ref(:, 1) = [0; 0;];
ref(:, 2) = [maxRange; 0;];
ref(:, 3) = [maxRange; 0;];
ref(:, 4) = [0; 0;];
ref(:, 5) = [0; 0;];
% ref(:, 5) = [-maxRange; 0;];
% ref(:, 6) = [0; 0;];
% ref(:, 7) = [maxRange; 0;];
% ref(:, 8) = [0; 0;];
    

