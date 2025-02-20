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

sizes.NumContStates  = 4; % alpha, beta, alpha_dot, beta_dot
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 3; % xmass, ymass, zmass
sizes.NumInputs      = 2; % Talpha, Tbeta (torques)
sizes.DirFeedthrough = 1;
sizes.NumSampleTimes = 1;   % at least one sample time is needed

sys = simsizes(sizes);

%
% initialize the initial conditions
%
alpha0      = pi/4;
beta0       = 0;
alphadot0   = 0;
betadot0    = 2;

x0  = [alpha0, beta0, alphadot0, betadot0].';

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
mass        = 1 * eye(3); % [kg]
L           = 1; % [m]
g           = 9.81; % [m/s^2]
damping     = [1;0]; % [Ns/m]
stiffness   = [0;0]; % [Nm/rad]

% State variables
q           = x(1:2);
qdot        = x(3:4);
alpha1      = q(1);
beta1       = q(2);
alpha1dot   = qdot(1);
beta1dot    = qdot(2);

% Obtain transformation vector Ti and its derivatives Ti_k and Ti_km
symb_Ti;
symb_Ti_k;

% Calculate reduced mass matrix Mred (eq. 10)
Mred = Ti_k.' * mass * Ti_k;

% Calculate convective acceleration (eq. 8)
symb_gconv;

% Reduced force vector (eq. 10)
f = mass * [0, 0, -g].';
Fred = Ti_k.' * (f - mass * gconv) - (damping .* qdot) - (stiffness .* q) + u;

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
L           = 1; % [m]

% Get transformation vector Ti
symb_Ti;

% Create output
sys = Ti; % [xmass; ymass; zmass]

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
