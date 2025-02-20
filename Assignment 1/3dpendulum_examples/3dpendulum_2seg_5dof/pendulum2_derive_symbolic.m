clear all; clc
% Init state variables
syms alpha1 beta1 gamma1 alpha2 beta2 real;
syms alpha1dot beta1dot gamma1dot alpha2dot beta2dot real;
syms L1 L2 real;

% Define state vector and derivative vector
q = [alpha1; beta1; gamma1; alpha2; beta2];
qdot = [alpha1dot; beta1dot; gamma1dot; alpha2dot; beta2dot];

% Transformation function, its derivative and convective acceleration.
% Ti1m    = rotx(alpha1) * roty(beta1) * rotz(gamma1) * [0; 0; -L1/2];
% Ti1j    = rotx(alpha1) * roty(beta1) * rotz(gamma1) * [0; 0; -L1];              % position joint 1 (end of segment 1)
% Ti2m    = Ti1j + rotx(alpha1) * roty(beta1) * rotz(gamma1) * rotx(alpha2) * roty(beta2) * [0; L2/10; -L2];     % position mass 2 (end of segment 2)
Ti1     = rotx(alpha1) * roty(beta1) * rotz(gamma1) * [0; 0; -L1/2];            % position mass 1 (halfway segment 1)
Ti2m1     = Ti1 + rotx(alpha1) * roty(beta1) * rotz(gamma1) * rotx(alpha2) * roty(beta2) * [0; L2/10; -L2];
Ti2m2     = Ti1 + rotx(alpha1) * roty(beta1) * rotz(gamma1) * rotx(alpha2) * roty(beta2) * [0; -L2/10; -L2];
Ti      = [Ti1; Ti2m1; Ti2m2]; 
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