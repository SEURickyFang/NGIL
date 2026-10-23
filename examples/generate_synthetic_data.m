function generate_synthetic_data(outputFile)
% Generate an illustrative episode; these numbers are not simulation results.
if nargin < 1
    outputFile = fullfile(fileparts(mfilename('fullpath')), 'synthetic_episode.csv');
end
t_s = (0:0.02:4)';
v0 = 15;
a = 4;
tStop = v0/a;
tMove = min(t_s,tStop);
vx_mps = max(0,v0-a*t_s);
x_m = v0*tMove-0.5*a*tMove.^2;
q = tMove/tStop;
ey_m = 0.04*sin(pi*q).^2;
y_m = ey_m;
yaw_radps = 0.008*sin(2*pi*q);
muL = 0.8*ones(size(t_s));
muR = 0.4*ones(size(t_s));
source = repmat("SYNTHETIC",numel(t_s),1);
T = table(t_s,x_m,y_m,vx_mps,ey_m,yaw_radps,muL,muR,source);
writetable(T,outputFile);
end
