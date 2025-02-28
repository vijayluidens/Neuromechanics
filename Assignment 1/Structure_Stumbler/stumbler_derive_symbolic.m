clear all; clc
%% Initialize symbolic variables
% Create symbolic variables for the angles, angular velocities, limb lengths
% and CoG locations. 
% 1) Angles
syms alpha2 beta2 gamma1 gamma2 gamma3 gamma4 real;
% 2) Angular velocities
syms alpha2dot beta2dot gamma1dot gamma2dot gamma3dot gamma4dot real;
% 3) Limb lengths
syms Lfoot Lshank Lthigh Lhip Lstance real;
% 4) Centers of gravity of limbs
syms cgStance cgThigh cgShank cgFoot; 

%% Define joint and mass locations
% Make sure that the required rotation matrices are saved as a function
% in the same folder as this file. (rotz, roty, rotx)
%finish the locations yourself. How many should you define?

% Xmstance    = rotz(gamma1) * [0; 0.553*L_stance; 0];
Xlefthip    = rotz(gamma1) * [0; Lstance; 0];
Xrighthip   = Xlefthip + [0; 0; Lhip];
Xmhip       = 0.5*(Xlefthip + Xrighthip);
Xmthigh     = Xrighthip + rotz(gamma1) * rotz(gamma2) * rotx(alpha2) * roty(beta2) * [0; -0.433*Lthigh; 0];
Xknee       = Xrighthip + rotz(gamma1) * rotz(gamma2) * rotx(alpha2) * roty(beta2) * [0; -Lthigh; 0];
Xmshank     = Xknee + rotz(gamma1) * rotz(gamma2) * rotx(alpha2) * roty(beta2) * rotz(gamma3) * [0; -0.433*Lshank; 0];
Xankle      = Xknee + rotz(gamma1) * rotz(gamma2) * rotx(alpha2) * roty(beta2) * rotz(gamma3) * [0; -Lshank; 0];
Xmfoot      = Xankle + rotz(gamma1) * rotz(gamma2) * rotx(alpha2) * roty(beta2) * rotz(gamma3) * rotz(gamma4) * [Lfoot/2; 0; 0];
Xtoe        = Xankle + rotz(gamma1) * rotz(gamma2) * rotx(alpha2) * roty(beta2) * rotz(gamma3) * rotz(gamma4) * [Lfoot; 0; 0];

%% Define state vector and state derivative vector

q       = [gamma1; alpha2; beta2; gamma2; gamma3; gamma4];
qdot    = [gamma1dot; alpha2dot; beta2dot; gamma2dot; gamma3dot; gamma4dot];

%% Transformation function Ti, its derivative Ti_k and convective acceleration.
Ti      = [Xlefthip; Xmhip; Xrighthip; Xmthigh; Xknee; Xmshank;
Xankle; Xmfoot; Xtoe];
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