%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot of 1D mass-spring-damper position control across conditons
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

clear all
close all
clc

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data for undamped system
load('OPENLOOP_Cwn=10zeta=0.2.mat');
OPENLOOP = results;

load('SFCINLINE_Cwn=10zeta=0.2.mat');
SFC_INLINE = results;

titleMessage = 'Controlling underdamped mass spring damper system';

% target(1, :)/p.k
PlotUncontrolledAndControlled(OPENLOOP, SFC_INLINE, titleMessage);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load data for overdamped system
load('OPENLOOP_Cwn=10zeta=3.mat');
OPENLOOP = results;

load('SFCINLINE_Cwn=10zeta=3.mat');
SFC_INLINE = results;

titleMessage = 'Controlling overdamped mass spring damper system';

% target(1, :)/p.k
PlotUncontrolledAndControlled(OPENLOOP, SFC_INLINE, titleMessage);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% loaddata for uncontrolled system
load('OPENLOOP_Cwn=10zeta=3.mat');
OVERDAMPED = results;

load('OPENLOOP_Cwn=10zeta=1.mat');
CRITICALLYDAMPED = results;

load('OPENLOOP_Cwn=10zeta=0.2.mat');
UNDERDAMPED = results;

titleMessage = 'Uncontrolled mass spring damper system';

p = OPENLOOP.p;

figure
hold on
% Target
h = plot(OPENLOOP.time, OPENLOOP.target(1, :)/p.k, 'k-');
set(h,'LineWidth', 2);

% OPENLOOP
h = plot(OPENLOOP.time, OPENLOOP.xDirect(1, :), 'k:');
set(h,'LineWidth', 3);

% CRITICALLYDAMPED
h = plot(CRITICALLYDAMPED.time, CRITICALLYDAMPED.xDirect(1, :), 'k-.');
set(h,'LineWidth', 3);

% UNDERDAMPED
h = plot(UNDERDAMPED.time, UNDERDAMPED.xDirect(1, :), 'k--');
set(h,'LineWidth', 3);

% label the x-axis
h = xlabel('Time [s]');
set(h,'FontSize', p.fontSize);

% label the y-axis
h = ylabel('Target position');
set(h,'FontSize', p.fontSize);

h = title(titleMessage);
set(h,'FontSize', p.fontSize);

% draw y-axis zero line
h = drawXLine(0, 0, CRITICALLYDAMPED.time(end), 'k:');
set(h,'LineWidth', 2);

% set size of axis numbering
set(gca,'FontSize', p.fontSize);
h = legend('Target', OVERDAMPED.titleMessage, CRITICALLYDAMPED.titleMessage, UNDERDAMPED.titleMessage);
set(h,'FontSize', p.fontSize);






