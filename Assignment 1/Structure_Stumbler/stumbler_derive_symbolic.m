clear all; clc
%% Initialize symbolic variables
% Create symbolic variables for the angles, angular velocities, limb lengths
% and CoG locations. 
% 1) Angles
syms alpha2 beta2 gamma1 gamma2 gamma3 gamma4 real;
% 2) Angular velocities
syms alpha2dot beta2dot gamma1dot gamma2dot gamma3dot gamma4dot real;
% 3) Limb lengths
syms L_foot L_shank L_thigh L_hip L_stance H real;
% 4) Centers of gravity of limbs
syms M_thigh M_shank M_foot M_HAT; %Not sure what to do with this

%% Define joint and mass locations
% Make sure that the required rotation matrices are saved as a function
% in the same folder as this file. (rotz, roty, rotx)
%finish the locations yourself. How many should you define?

Xlefthip    = rotz(gamma1) * [0; L_stance; 0];
Xrighthip   = Xlefthip + [0; 0; L_hip];
Xmhip       = 0.5*(Xlefthip + Xrighthip);
Xmthigh     = Xrighthip + rotz(gamma2) * rotx(alpha2) * roty(beta2) * [0; -L_thigh/3; 0];
Xknee       = Xrighthip + rotz(gamma2) * rotx(alpha2) * roty(beta2) * [0; -L_thigh; 0];
Xmshank     = Xknee + rotz(gamma3) * [0; -L_shank/3; 0];
Xankle      = Xknee + rotz(gamma3) * [0; -L_shank; 0];
Xmfoot      = Xankle + rotz(gamma4) * [L_foot/3; 0; 0];
Xtoe        = Xankle + rotz(gamma4) * [L_foot; 0; 0];

%% Define state vector and state derivative vector

q       = [alpha2; beta2; gamma1; gamma2; gamma3; gamma4];
qdot    = [alpha2dot; beta2dot; gamma1dot; gamma2dot; gamma3dot; gamma4dot];

%% Transformation function Ti, its derivative Ti_k and convective acceleration.
Ti      = [Xmhip; Xmthigh; Xmshank; Xmfoot];
Ti_k    = jacobian(Ti, q);
gconv   = jacobian(Ti_k * qdot, q) * qdot;

%% Save symbolic derivation to script file.
% Use Diary function, save the symbolicly derived functions to file. 
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