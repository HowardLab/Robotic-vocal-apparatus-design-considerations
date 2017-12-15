%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1D mass-spring-damper position control
% all rights reserved
% Author: Dr. Ian Howard
% Associate Professor (Senior Lecturer) in Computational Neuroscience
% Centre for Robotics and Neural Systems 
% Plymouth University
% A324 Portland Square
% PL4 8AA
% Plymouth, Devon, ?UK
% howardlab.com
% 25/11/2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all
clear all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get task
maxForce = 100;

% every sub-loop randomly perturb intial conditions and specify position target
ref = Get1DTargetPtoP(maxForce);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get parameters for point mass
% spoecify natural frequency
p.wn = 10;

% specify damping
% if zeta > 1 then overdamped
% if zeta = 1 then critically damped
% if zeta < 1 then underdamped

%p.zeta = 5;
%p.zeta = 1;
p.zeta = 0.1;

% set free parameter mass
p.mass = 1;

% get MSD parameters given constraints
phaseDuration=1;
p = GetMassSpringDamperParams(p, p.wn, p.zeta, p.mass, phaseDuration);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% clip level for control force
p.maxControl=10000;

% state space matrices
ssm.A = [0 1; -p.k/p.m -p.mu/p.m ];
ssm.B = [0; 1/p.m;];
ssm.C = [1 0;];
ssm.D = [];


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% define operational modes
p.MODE_OPENLOOP = 1;
p.MODE_SFC = 2;
p.MODE_SFC_INLINE = 3;

% select mode
p.simulationMode = p.MODE_OPENLOOP;

% decode simulation mode
switch (p.simulationMode)
    case p.MODE_SFC_INLINE
        % inline SFC - displacement input
        p.titleMessage = sprintf('INLINE SFC: ma = %gKg   wn=%gRad/s   zeta=%g', p.mass, p.wn, p.zeta);
        fileName = sprintf('SFCINLINE_Cwn=%gzeta=%g.mat',p.wn, p.zeta);
        % calculate max distance plot range
        maxRange = maxForce/p.k;
        ref = ref/p.k;        % set  intial condition t0 stating position
        % [x(0) xDot(0)]
        x0 = ref(:,1);
    case p.MODE_SFC
        % with SFC - displacement input
        p.titleMessage = sprintf('SFC: m = %gKg   wn=%gRad/s   zeta=%g', p.mass, p.wn, p.zeta);
        fileName = sprintf('SFC_Cwn=%gzeta=%g.mat',p.wn, p.zeta);
        % calculate max distance plot range
        maxRange = maxForce/p.k;
        ref = ref/p.k;
        % set  intial condition t0 stating position
        % [x(0) xDot(0)]
        x0 = ref(:,1);
    case  p.MODE_OPENLOOP
        % open loop - force input
        p.titleMessage = sprintf('OPENLOOP: m = %gKg   wn=%gRad/s   zeta=%g', p.mass, p.wn, p.zeta);
        fileName = sprintf('OPENLOOP_Cwn=%gzeta=%g.mat',p.wn, p.zeta);
        % calculate max distance plot range
        maxRange = maxForce/p.k;
        % set  intial condition t0 stating position
        % [x(0) xDot(0)]
        x0 = ref(:,1)/p.k;

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute eigenvectors for the open loop system
disp('get eigenvectors for the open loop system');
E_L = eig(ssm.A)

% estimate the controllability
disp('controllablity matrix for 2x2 A system matrix');
AB= ssm.A * ssm.B;
MXc=[ssm.B AB ];
rank(MXc)
disp('rank = 2 therefore controlable');

% estimate the observability
disp('observability matrix for 2x2 A system matrix');
CA = ssm.C*ssm.A;
MXo=[ssm.C; CA; ;]
rank(MXo)
disp('rank = 2 therefore observable');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% for state space model with x, xDot
% compute SFC gains to set eigenvalues
PX=8 * [-1 -1.1 ];
ssm.KPLACE = place(ssm.A, ssm.B, PX);
disp(ssm.KPLACE);

% state feedback controlled system matrices
sfc.A = ssm.A - ssm.B * ssm.KPLACE;
sfc.B = ssm.B;
sfc.C = ssm.C;
sfc.D = ssm.D;

% compute eigenvectors for the designed systems to check process was successful
disp('Now get eigenvectors for the PLACE designed systems to check');
E_L = eig(sfc.A)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate LQR gains
Q = ssm.C'*ssm.C;
R=1;
ssm.KLQR = lqr(ssm.A,ssm.B,Q,R);

% state feedback controlled system matrices
A_LQR = ssm.A - ssm.B * ssm.KLQR;
B_LQR = ssm.B;
C_LQR = ssm.C;
D_LQR = ssm.D;

% compute eigenvectors for the designed systems to check process was successful
disp('Now get eigenvectors for the LQR designed systems to check');
E_L = eig(A_LQR)

% use gain from PLACE
ssm.K = ssm.KPLACE;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get response of uncontrolled system
sys = ss(ssm.A,ssm.B,ssm.C,ssm.D);
figure
t = 0:0.01:3;
step(sys,t)
grid
title('Step Response with State-Feedback Controller')

% get response of SFC system
figure
sys_cl = ss(ssm.A-ssm.B*ssm.K,ssm.B,ssm.C,ssm.D);
step(sys_cl,t)
grid
title('Step Response with State-Feedback Controller')

% reference input scaling factor
[Nbar]=rscale(sys, ssm.K);

% use gain from KLQR
%ssm.K = ssm.KLQR;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % build observer just for angle and angular velocity states

% observer gain
PX= 1 * [-1 -1.2];
ssm.L = place(ssm.A, ssm.C',PX);
ssm.LT = ssm.L';
disp(ssm.L);

% % get (A-LC) matrix
A_L = ssm.A - ssm.L * ssm.C';

% % get eigenvectors for the designed systems to check
% disp('get eigenvectors for the designed systems to check');
E = eig(ssm.A)
E_L = eig(A_L)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
disp(p.titleMessage)

yDirect=[];
tDirect=[];
xDirect=[];
time=[];
kickFlag=[];
target = [];

% run for specified iterations
for kick=1:size(ref,2)
    
    % decode simulation mode
    switch (p.simulationMode)
        
        case p.MODE_SFC_INLINE
            % inline SFC
            [tSS, xDirectK] = ode45(@(t,x)((ssm.A-ssm.B*ssm.K)*(x-ref(:, kick))), p.t, x0);
            
        case p.MODE_SFC
            % with SFC
            targetState = (Nbar/ssm.K(1)) * [ref(1, kick); 0;];
            [tSS, xDirectK] = ode45(@(t,x)SSSim(x, ssm.A, ssm.B, -ssm.K * (x - targetState), p.maxControl), p.t, x0);
        
        case  p.MODE_OPENLOOP
            % open loop 
            uin = ref(1,kick);
            [tSS, xDirectK] = ode45(@(t,x)SSSim(x, ssm.A, ssm.B, uin, p.maxControl), p.t, x0);
    end
    
    % get time
    newTime = (kick-1) * p.t(end) + p.t;
    
    % just show kick arrow for short time after kick
    frames = length(p.t);

    % build the target
    targetK = ref(1, kick) .* ones(1,frames);
    
    % concatenate
    time = [time newTime];
    xDirect = [xDirect xDirectK'];
    %kickFlag = [kickFlag kickFlagK];
    target = [target targetK];
    
    % update intial condition for next run
    % [x(0) xDot(0)]
    x0 = [xDirect(1, end); xDirect(2, end);];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% save results
results.xDirect = xDirect;
results.time = time;
results.time = time;
results.target = target;
results.titleMessage = p.titleMessage;
results.p = p;
save(fileName, 'results');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
close all;
Plot1DData(time, xDirect(1, :), xDirect(2, :), target(1, :), p);

% for all time point animate the results
figure
params.xrange= [-maxRange* 0.5 maxRange* 1.1];   % displayed range
params.yrange= [-maxRange* 0.5 maxRange * 0.5];  % displayed range
params.limitAxes=1;     % limit the axes to range
params.fontSize = 20;   % set font size
params.arrowSize = 40;  % set arrow size
params.W = 0.1;         % width of the cart in m
params.H = 0.1;         % height of the cart in m
params.fname = '1d_MSD.avi';
params.fname = '';
Animate1DMassSpringDamper(xDirect(1, :), target,  time, params, kickFlag, p.titleMessage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% graph movement plot
figure
hold on
h=plot(target(1, :),  zeros(size(target(1, :))),'or');
set(h,'MarkerSize', 25);
h=plot(xDirect(1, :),  zeros(size(xDirect(1, :))),'b-x');
set(h,'MarkerSize', 15);

swp(1) = 1;
swp(2) = 51;
swp(3) = 102;
% swp(4) = 153;
% swp(4) = 204;
for idx = 1:length(swp)
    h=plot( xDirect(1, swp(idx)),  0,'*');
    set(h,'MarkerSize', 35);
end
axis([params.xrange(1) params.xrange(2) params.yrange(1) params.yrange(2)]);

