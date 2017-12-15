function y = Get2ndOrderReponse(wn, zeta, T)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute analytical second order response
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

et = exp(-zeta*wn*T);

if(zeta==1)
    y = ones(size(T)) - et;
    
else
    dt = sqrt(1-zeta^2);
    st = sin(wn*dt*T + acos(zeta));
    y = ones(size(T)) - et .* (st / dt);
    
end

end

