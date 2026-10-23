function metrics = summarize_synthetic_episode(csvFile,speedCutoff)
% Evaluate only the illustrative CSV supplied with this public repository.
if nargin < 1
    csvFile = fullfile(fileparts(mfilename('fullpath')), 'synthetic_episode.csv');
end
if nargin < 2
    speedCutoff = 1.5;
end
T = readtable(csvFile);
assert(all(string(T.source) == "SYNTHETIC"),'This example accepts synthetic data only.');
assert(all(diff(T.t_s) > 0),'Time must increase strictly.');
j = find(T.vx_mps <= speedCutoff,1,'first');
assert(~isempty(j),'Speed cutoff was not reached.');
I = 1:j;
metrics = struct;
metrics.distanceToCutoff_m = T.x_m(j)-T.x_m(1);
metrics.maxAbsOffset_m = max(abs(T.ey_m(I)));
metrics.meanAbsOffset_m = mean(abs(T.ey_m(I)));
metrics.maxAbsYawRate_radps = max(abs(T.yaw_radps(I)));
end
