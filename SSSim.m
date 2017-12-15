function xDot = SSSim(X, A, B, u, maxControl)
% state space model
% Author: Dr. Ian Howard
% Associate Professor (Senior Lecturer) in Computational Neuroscience
% Centre for Robotics and Neural Systems ?
% Plymouth University
% A324 Portland Square?
% PL4 8AA
% Plymouth, ? Devon, ?UK
% howardlab.com
% 25/11/2017

% X is state
% A,B are state space matrices
% u is ther control input
% xdot is the returned 1st time derivative of state

% clip the control
% u = Clip(u, maxControl);

% implement model
xDot = A * X + B * u;




