clear all; clc
% Init state variables
syms alpha1 beta1 real;
syms alpha1dot beta1dot real;
syms L real;

% Define state vector and derivative vector
q = [alpha1; beta1];
qdot = [alpha1dot; beta1dot];

% Transformation function, its derivative and convective acceleration.
Ti      = rotx(alpha1)*roty(beta1) * [0; 0; -L];
Ti_k    = jacobian(Ti, q);
gconv   = jacobian(Ti_k * qdot, q) * qdot;

% Save symbolic derivation to script file.
if exist('symb_Ti.m', 'file')
    ! del symb_Ti.m
end
diary symb_Ti.m
    disp('Ti = ['), disp(Ti), disp('];');
diary off

if exist('symb_Ti_k.m', 'file')
    ! del symb_Ti_k.m
end
diary symb_Ti_k.m
    disp('Ti_k = ['), disp(Ti_k), disp('];');
diary off

if exist('symb_gconv.m', 'file')
    ! del symb_gconv.m
end
diary symb_gconv.m
    disp('gconv = ['), disp(gconv), disp('];')
diary off