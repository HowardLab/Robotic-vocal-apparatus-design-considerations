function PlotUncontrolledAndControlled(ol, sfc, titleMessage)
p = ol.p;

lWidth = 5;

figure
hold on
h = plot(sfc.time, sfc.target(1, :), 'k-');
set(h,'LineWidth', 1);

% OPENLOOP
h = plot(ol.time, ol.xDirect(1, :), 'k:');
set(h,'LineWidth', lWidth);

% inline SFC
h = plot(sfc.time, sfc.xDirect(1, :), 'k-.');
set(h,'LineWidth', lWidth);

% label the x-axis
h = xlabel('Time [s]');
set(h,'FontSize', p.fontSize);

% label the y-axis
h = ylabel('Target position');
set(h,'FontSize', p.fontSize);

h = title(titleMessage);
set(h,'FontSize', p.fontSize);

% draw y-axis zero line
h = drawXLine(0, 0, ol.time(end), 'k:');
set(h,'LineWidth', 2);

% set size of axis numbering
set(gca,'FontSize', p.fontSize);
h = legend('Target', ol.titleMessage, sfc.titleMessage);
set(h,'FontSize', p.fontSize);

% set the scale
axis([0 ol.time(end) -1 2]);



