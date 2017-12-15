function  phandle = drawYLine(xPos, yMin, yMax, lineProperties)
% draw ling along y-axis at specified xPos
xx = [xPos xPos];
yy = [yMin yMax];
phandle = plot(xx, yy,  lineProperties);
