function params = GetMassSpringDamperParams(params, wn, zeta, mass, phaseDuration)
% get parameters for mass-spring-damper

% plot parameters
params.fontSize=25;
params.plotLineWidth=3;

% build test signal - set to 1s between movements
params.dt=0.02;
params.Tfinal=phaseDuration;
params.t = 0:params.dt:params.Tfinal;
params.u = zeros(1, length(params.t)) ;

% pendulum mass
params.m = mass;

% spring constant
%params.k = 0.1;
params.k = wn^2 * mass;

% viscous friction
%params.mu = 0.1;
params.mu = 2*wn*zeta*mass;
