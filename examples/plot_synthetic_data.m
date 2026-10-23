function plot_synthetic_data(csvFile)
% Plot the illustrative CSV; no controller or paper result is reproduced.
if nargin < 1
    csvFile = fullfile(fileparts(mfilename('fullpath')), 'synthetic_episode.csv');
end
T = readtable(csvFile);
assert(all(string(T.source) == "SYNTHETIC"),'This example accepts synthetic data only.');
figure('Color','w');
tiledlayout(1,2,'Padding','compact');
nexttile;
plot(T.x_m,T.y_m,'LineWidth',1.5);
axis equal;
xlabel('X [m]'); ylabel('Y [m]');
nexttile;
plot(T.t_s,T.vx_mps,'LineWidth',1.5);
xlabel('Time [s]'); ylabel('V_x [m/s]');
end
