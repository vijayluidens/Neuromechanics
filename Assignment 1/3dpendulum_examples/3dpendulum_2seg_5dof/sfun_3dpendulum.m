function [sys,x0,str,ts] = sfuntmpl(t,x,u,flag)
switch flag,

  %%%%%%%%%%%%%%%%%%
  % Initialization %
  %%%%%%%%%%%%%%%%%%
  case 0,
    [sys,x0,str,ts]=mdlInitializeSizes;

  %%%%%%%%%%%%%%%
  % Derivatives %
  %%%%%%%%%%%%%%%
  case 1,
    sys=mdlDerivatives(t,x,u);

  %%%%%%%%%%
  % Update %
  %%%%%%%%%%
  case 2,
    sys=mdlUpdate(t,x,u);

  %%%%%%%%%%%
  % Outputs %
  %%%%%%%%%%%
  case 3,
    sys=mdlOutputs(t,x,u);

  %%%%%%%%%%%%%%%%%%%%%%%
  % GetTimeOfNextVarHit %
  %%%%%%%%%%%%%%%%%%%%%%%
  case 4,
    sys=mdlGetTimeOfNextVarHit(t,x,u);

  %%%%%%%%%%%%%
  % Terminate %
  %%%%%%%%%%%%%
  case 9,
    sys=mdlTerminate(t,x,u);

  %%%%%%%%%%%%%%%%%%%%
  % Unexpected flags %
  %%%%%%%%%%%%%%%%%%%%
  otherwise
    error(['Unhandled flag = ',num2str(flag)]);

end

% end sfuntmpl

%
%=============================================================================
% mdlInitializeSizes
% Return the sizes, initial conditions, and sample times for the S-function.
%=============================================================================
%
function [sys,x0,str,ts]=mdlInitializeSizes

sizes = simsizes;

sizes.NumContStates  = 10; % alpha1, beta1, gamma1, alpha2, beta2, alpha1_dot, beta1_dot, gamma1dot, alpha2dot, beta2dot.
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 9; % x1, y1, z1, x2, y2, z2, x3, y3, z3 
sizes.NumInputs      = 0;
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1; % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
alpha1         = pi/6;
beta1          = 0;
gamma1         = 0;
alpha2         = 0;
beta2          = 0;
alpha1dot      = 0;
beta1dot       = 0;
gamma1dot      = 0;
alpha2dot      = 0;
beta2dot       = 0; 

x0  = [   alpha1,    beta1,    gamma1,    alpha2,    beta2, ...
       alpha1dot, beta1dot, gamma1dot, alpha2dot, beta2dot].';

%
% str is always an empty matrix
%
str = [];

%
% initialize the array of sample times
%
ts  = [0 0];

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u)
% System parameters
m1          = 2; % [kg]
m2          = 1; % [kg]
mass        = diag([m1, m1, m1, m2/2, m2/2, m2/2, m2/2, m2/2, m2/2]); % Mass matrix
L1          = 1; % [m]
L2          = 1; % [m]
g           = 9.81; % [m/s^2]
damping     = [0;0;0;0;0]; % [Ns/m] 
stiffness   = [1;1;1;0;0]; % [Nm/rad]

% State variables
q           = x(1:5);
qdot        = x(6:10);
alpha1      = q(1);
beta1       = q(2);
gamma1      = q(3);
alpha2      = q(4);
beta2       = q(5);
alpha1dot   = qdot(1);
beta1dot    = qdot(2);
gamma1dot   = qdot(3);
alpha2dot   = qdot(4);
beta2dot    = qdot(5);

% Obtain transformation vector Ti and its derivatives Ti_k and Ti_km
symb_Ti;
symb_Ti_k;

% Calculate reduced mass matrix Mred (eq. 10)
Mred = Ti_k.' * mass * Ti_k;

% Calculate convective acceleration (eq. 8)
symb_gconv;

% Reduced force vector (eq. 10)
f = mass * [0, 0, -g, 0, 0, -g, 0, 0, -g].';
Fred = Ti_k.' * (f - mass * gconv) - (damping .* qdot) - (stiffness .* q);

% Calcultate derivatives qddot (eq. 10)
qddot = Mred \ Fred;
sys = [qdot ; qddot];

% end mdlDerivatives

%
%=============================================================================
% mdlUpdate
% Handle discrete state updates, sample time hits, and major time step
% requirements.
%=============================================================================
%
function sys=mdlUpdate(t,x,u)

sys = [];
% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)
alpha1      = x(1);
beta1       = x(2);
gamma1      = x(3);
alpha2      = x(4);
beta2       = x(5);
L1          = 1; % [m]
L2          = 1; % [m]

% Get transformation vector Ti
symb_Ti;

% Create output
sys = Ti; % Locations of masses

% end mdlOutputs

%
%=============================================================================
% mdlGetTimeOfNextVarHit
% Return the time of the next hit for this block.  Note that the result is
% absolute time.  Note that this function is only used when you specify a
% variable discrete-time sample time [-2 0] in the sample time array in
% mdlInitializeSizes.
%=============================================================================
%
function sys=mdlGetTimeOfNextVarHit(t,x,u)

sampleTime = 1;    %  Example, set the next hit to be one second later.
sys = t + sampleTime;

% end mdlGetTimeOfNextVarHit

%
%=============================================================================
% mdlTerminate
% Perform any end of simulation tasks.
%=============================================================================
%
function sys=mdlTerminate(t,x,u)

sys = [];

% end mdlTerminate
