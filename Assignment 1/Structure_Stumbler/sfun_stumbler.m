function [sys,x0,str,ts] = sfun_stumbler(t,x,u,flag)
global model
%% Define model masses, lengths, stiffness, damping and gravity
% Find reasonable values for the following variables and store them in 
% the model structure, defined globally above. 
% example: model.mstance = <your value here> %[kg]; 
% (hint; consider the dimensions (single value/vectors) of the variables)

% Masses
model.mstance   = ;   % mass stance leg [kg]
model.mhip      = ;   % mass trunk on hip [kg
model.mthigh    = ;   % mass thigh swing leg [kg]
model.mshank    = ;   % mass shank swing leg [kg]
model.mfoot     = ;   % mass foot swing leg [kg]

% Lengths
model.Lstance   = ;% [m]
model.Lhip      = ;% [m]
model.Lthigh    = ;% [m]
model.Lshank    = ;% [m]
model.Lfoot     = ;% [m]

% Centres of gravity with respect to proximal joint
model.cgStance =  ;% [m]
model.cgThigh  =  ;% [m]
model.cgShank  =  ;% [m]
model.cgFoot   =  ;% [m]

% Joint stiffness
model.kjoint    = [0; 0; 0; 0; 0; 0];

% Joint damping
model.bjoint    = [0; 0; 0; 0; 0; 0];

% Gravity
model.g         = ; % [Nm/s^2]

% % Part B: brick dimensions
% xbrick          = 0;
% model.bx1       = xbrick;
% model.bx2       = xbrick + 0.06;
% model.by1       = 0;
% model.by2       = 0.10;
% model.bz1       = 0.17;
% model.bz2       = 0.45;
% model.bbrick    = 100;
% model.kbrick    = 1000;

%% 
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
    sys=mdlDerivatives(t,x,u,model);

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

% Init sizes
sizes = simsizes;
sizes.NumContStates  = ;     % Two times the number of generalized coordinates
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = ;       % All joint angles
sizes.NumInputs      = ;       % All joint torques
sizes.DirFeedthrough = 0;
sizes.NumSampleTimes = ;       % At least one sample time is needed
sys = simsizes(sizes);

% Initial angles [rad]
% Define what the initial values of the angles are
gamma1  = ;
alpha2  = ;
beta2   = ;
gamma2  = ;
gamma3  = ;
gamma4  = ;

% Initial angular velocities [rad/s]
% Define what the initial values of the angular velocities are
gamma1dot   = ;
alpha2dot   = ;
beta2dot    = ;
gamma2dot   = ;
gamma3dot   = ;
gamma4dot   = ;

% States and state derivatives
q       = ;
qdot    = ;

x0  = [q; qdot];


% str is always an empty matrix
str = [];


% initialize the array of sample times
ts  = [0 0];

% end mdlInitializeSizes

%
%=============================================================================
% mdlDerivatives
% Return the derivatives for the continuous states.
%=============================================================================
%
function sys=mdlDerivatives(t,x,u,model)
%% Get model parameters from model structure 
% Masses
mstance     = model.mstance;     % mass stance leg [kg]
mhip        = model.mhip;        % mass trunk on hip [kg
mthigh      = model.mthigh;      % mass thigh swing leg [kg]
mshank      = model.mshank;      % mass shank swing leg [kg]
mfoot       = model.mfoot;      % mass foot swing leg [kg]

% Lengths
Lstance     = model.Lstance;    % [m]
Lhip        = model.Lhip;       % [m]
Lthigh      = model.Lthigh;     % [m]
Lshank      = model.Lshank;     % [m]
Lfoot       = model.Lfoot;      % [m]

% Centres of gravity with respect to proximal joint
cgStance    = model.cgStance;   % [m]
cgThigh     = model.cgThigh;    % [m]
cgShank     = model.cgShank;    % [m]
cgFoot      = model.cgFoot;     % [m]

% Gravity
g           = model.g;

%% Determine mass matrix
mass = 
    
%% Get state variables from state vector x
q           = x(1:6);
qdot        = x(7:12);
gamma1      = q(1);
alpha2      = q(2);
beta2       = q(3);
gamma2      = q(4);
gamma3      = q(5);
gamma4      = q(6);
gamma1dot   = qdot(1);
alpha2dot   = qdot(2);
beta2dot    = qdot(3);
gamma2dot   = qdot(4);
gamma3dot   = qdot(5);
gamma4dot   = qdot(6);


%% Add dynamics stiffness and damping to prevent overstretching joints
% First get the stored values of passive stiffness and damping from 
% the model structure

% Passive Stiffness
kjoint      = model.kjoint;

% Passive Damping
bjoint      = model.bjoint;

% Active stiffness and damping
% Create if statement, which prevents the knee to overstretch by adapting
% the stiffness and damping
% if gamma3 > 0 % Knee overstretched
%     kjoint(5) = ;
%     bjoint(5) = ;
% end

%% Obtain transformation vector Ti and its derivatives Ti_k and Ti_km
symb_Ti;
symb_Ti_k;

%% Detect collision with brick
% Implement the collision with the brick and calculate the resulting force.

%% Determine state derivatives
% Calculate reduced mass matrix Mred 
Mred = ;

% Calculate convective acceleration 
symb_gconv;

% Reduced force vector 
f = ;
Fred = ;

% Calcultate derivatives qddot 
qddot = ;

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
% Empty matrix
sys = [];
% end mdlUpdate

%
%=============================================================================
% mdlOutputs
% Return the block outputs.
%=============================================================================
%
function sys=mdlOutputs(t,x,u)

% Create output
sys = x(1:6);

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
