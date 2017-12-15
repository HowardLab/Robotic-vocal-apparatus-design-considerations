function Plot1DData(time, xDirect, vDirect, target, p)


figure
subplot(2,1,1);
hold on

% decode simulation mode
switch (p.simulationMode)
    
    case {p.MODE_SFC, p.MODE_SFC_INLINE}

        % inline SFC
        % with SFC
        h = plot(time, xDirect, 'b');
        set(h,'LineWidth', 3);
        % divide force inout by spring constant
        % to get position target
        h = plot(time, target, 'k:');
        %h = plot(time, target(1, :), 'k:');
        set(h,'LineWidth', 2);
        
    case  {p.MODE_OPENLOOP}
        % open loop
        h = plot(time, xDirect, 'b');
        set(h,'LineWidth', 3);
        
        % divide force inout by spring constant
        % to get position target
        h = plot(time, target/p.k, 'k:');
        %h = plot(time, target(1, :), 'k:');
        set(h,'LineWidth', 2);
end

h=legend('x[m]', 'target position');
set(h,'FontSize', p.fontSize);

% label the x-axis
h = xlabel('Time [s]');
set(h,'FontSize', p.fontSize);

% label the y-axis
h = ylabel('pos');
set(h,'FontSize', p.fontSize);

h = title(p.titleMessage);
set(h,'FontSize', p.fontSize);

% draw y-axis zero line
h = drawXLine(0, 0, time(end), 'k:');
set(h,'LineWidth', 2);

% set size of axis numbering
set(gca,'FontSize', p.fontSize);

subplot(2,1,2);
hold on
h = plot(time, vDirect, 'r');
set(h,'LineWidth', 3);

h=legend( 'xDot[m/s]');
set(h,'FontSize', p.fontSize);

% label the x-axis
h = xlabel('Time [s]');
set(h,'FontSize', p.fontSize);

% label the y-axis
h = ylabel('velocity');
set(h,'FontSize', p.fontSize);

h = title(p.titleMessage);
set(h,'FontSize', p.fontSize);

% draw y-axis zero line
h = drawXLine(0, 0, time(end), 'k:');
set(h,'LineWidth', 3);

% set size of axis numbering
set(gca,'FontSize', p.fontSize);
