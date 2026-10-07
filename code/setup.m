function root=setup(casadiFolder)
root=fileparts(mfilename('fullpath'));
addpath(root,fullfile(root,'expert'),fullfile(root,'learning'), ...
 fullfile(root,'control'),fullfile(root,'models'));
if nargin>0
 assert(isfolder(casadiFolder),'CasADi folder does not exist.');
 addpath(casadiFolder);
 assert(exist('casadi.MX','class')==8,'CasADi MATLAB interface is unavailable.');
end
end
