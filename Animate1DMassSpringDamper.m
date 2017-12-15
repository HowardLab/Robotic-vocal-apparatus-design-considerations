function Animate1DMassSpringDamper(xIn,  target, t, p, kickFlag, titleMessage)
% animate Mass Spring Damper
% Author: Dr. Ian Howard
% Associate Professor (Senior Lecturer) in Computational Neuroscience
% Centre for Robotics and Neural Systems ?
% Plymouth University
% A324 Portland Square?
% PL4 8AA
% Plymouth, ? Devon, ?UK
% howardlab.com
% 25/11/2017

% cart vertical position
y = 0;

% location of kick arrow
kickLocation =  p.H;

% if finlename for mpvie supplied
if(length(p.fname) > 0)
    wantMovie=1;
    % init movie
    M=[];
    % Prepare the new file.
    vidObj = VideoWriter(p.fname,'MPEG-4');
    open(vidObj);
    set(gca,'nextplot','replacechildren');
    
else
    wantMovie=0;
end

% animate the results for all time point
points = length(t);
for k=2: points
    
    % calculate the time step
    timeStep = t(k) - t(k-1);
    
    % get posiiton of mass
    x = xIn(k);
    
    % draw the rails
    h = plot([p.xrange(1) p.xrange(2)],[0 0],'w');
    set(h,'LineWidth', 2);
    
    % turn hold on
    hold on;
    
%     % scale the arrow
%     arrowSizeScaled = p.arrowSize * sqrt(abs(kickFlag(k)));
%     
%     % draw excitation arrow to represent initial kick
%     if (kickFlag(k) > 0)
%         % place at top of pendulum on RHS
%         h = text(0, kickLocation ,'\rightarrow', 'HorizontalAlignment', 'right');
%         set(h,'FontSize', arrowSizeScaled, 'Color','w');
%     elseif(kickFlag(k) < 0)
%         % place at top of pendulum on LHS
%         h = text(0, kickLocation ,'\leftarrow', 'HorizontalAlignment', 'left');
%         set(h,'FontSize', arrowSizeScaled, 'Color','w');
%     end
    
    % print the frame count
    message = sprintf('Frame: %d/%d ', k, points);
    h = text(1, 0.5 ,message);
    set(h,'FontSize', p.fontSize, 'Color','w');
    
    % write the title
    % h = title(titleMessage);
    h = title(titleMessage);
    set(h,'FontSize', p.fontSize, 'Color','w');
    
    % draw the carriage
    rectangle('Position',[x-p.W/2, y-p.H/2, p.W, p.H],'Curvature',[ 1 1],'FaceColor',[1 0.1 0.1],'EdgeColor',[1 1 1]);
        
    if(p.limitAxes)
        % set the axes range (in cm)
        xlim([p.xrange(1) p.xrange(2)]);
        ylim([p.yrange(1) p.yrange(2)]);
    end
    
    % maintain scaling
    axis equal;
    
    % draw the target
    h = drawYLine(target(k), p.xrange(1), p.xrange(2), 'y:')
    set(h,'LineWidth', 2);
    
    %axis([-45 45 -75 75]);
    
    
    % set the colours of the plot
    set(gca,'Color','k','XColor','w','YColor','w');
    if(wantMovie==0)
        % set position and size of diplay window bigger than default
        x0=10;
        y0=200;
        width=1000;
        height=700;
        set(gcf,'Position',[x0,y0,width,height]); 
    end
    
    % set outside to black
    set(gcf,'Color','k');
    
    % label the x-axis
    h = xlabel('Horizontal position [m]');
    set(h,'FontSize', p.fontSize);
    
    % set size of axis numbering
    set(gca,'FontSize', p.fontSize);
    
    % negative style
    set(gcf,'InvertHardcopy','off') ;
    
    if(wantMovie)
        % Write each frame to the file
        currFrame = getframe;
        writeVideo(vidObj, currFrame);
    end
    
        % wait for time Step to give approximately real-time animation
    % ony works  time step roughly > 1/20 second
    pause(timeStep);
    
    % box off
    drawnow;
    
    % now turn off hold
    hold off;    
end

if(wantMovie)
    
    % Close the file.
    close(vidObj);
    
end
