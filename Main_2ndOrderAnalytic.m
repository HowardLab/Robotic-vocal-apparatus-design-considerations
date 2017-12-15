%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot of analytica 2nd order system response to stepo
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

% build 2nd order transfer function
% for underdamped case
TDur=20;
Ta = 0:0.1:TDur;


wn=1;
zeta02=0.2;
zeta1=1;
zeta3=3;

% direct analytical simulation
Rt02 = Get2ndOrderResponse(wn, zeta02, Ta);
Rt1 = Get2ndOrderResponse(wn, zeta1, Ta);
Rt3 = Get2ndOrderResponse(wn, zeta3, Ta);


figure
hold on
h = plot(Ta,Rt02,'k-');
set(h,'LineWidth', 4);

h = plot(Ta,Rt1,'k:');
set(h,'LineWidth', 4);

h = plot(Ta,Rt3,'k--');
set(h,'LineWidth', 4);


h=legend('zeta=0.2', 'zeta=1', 'zeta=3');
set(h, 'FontSize', 25);
set(gca, 'FontSize', 25);
h = xlabel('Time{s)');
set(h, 'FontSize', 25);
h = ylabel('Response');
set(h, 'FontSize', 25);
title('Analytical step response')

