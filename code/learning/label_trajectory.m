function [samples,diagnostics]=label_trajectory(records,caseId)
root=fileparts(fileparts(mfilename('fullpath')));
d=load(fullfile(root,'data','training.mat'),'dataset');
assert(ismember(string(caseId),unique(d.dataset.caseId(d.dataset.split=="train"))), ...
 'DAgger relabeling is restricted to training cases.');
samples=struct('X',zeros(28,0),'Y',zeros(3,0),'split',strings(1,0), ...
 'caseId',strings(1,0),'sampleWeight',zeros(1,0),'isDagger',false(1,0), ...
 'inputNames',{d.dataset.inputNames});
warm=[];diagnostics=cell(1,numel(records));cfg=parameters();
for k=1:numel(records)
 z=records(k);
 assert(isequal(size(z.observation),[28 1])&&isequal(size(z.state),[12 1]));
 assert(isequal(size(z.environment),[19 1])&&isequal(size(z.previousAction),[3 1]));
 if z.state(1)<=cfg.minSpeed,continue;end
 [u,r,warm]=solve_nmpc(z.state,z.environment,z.previousAction,warm);
 diagnostics{k}=r;
 if ~r.accepted||r.feasibleBackup||~all(isfinite(u)),continue;end
 u=min([1;1;cfg.angleMax],max([0;0;-cfg.angleMax],u));
 samples.X(:,end+1)=z.observation;samples.Y(:,end+1)=u;
 samples.split(end+1)="train";samples.caseId(end+1)=string(caseId);
 edge=z.environment(15)-z.environment(16:17);
 samples.sampleWeight(end+1)=1+double(z.timeAfterBrake<.4)+double(any(edge>-.1&edge<3));
 samples.isDagger(end+1)=true;
end
end
