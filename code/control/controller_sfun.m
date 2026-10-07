function controller_sfun(block)
block.NumDialogPrms=0;
block.NumInputPorts=5;block.NumOutputPorts=5;
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;
inputSize=[12 2 1 6 1];outputSize=[6 2 3 6 1];
for k=1:5
 block.InputPort(k).Dimensions=inputSize(k);
 block.InputPort(k).DatatypeID=0;
 block.InputPort(k).Complexity='Real';
 block.InputPort(k).SamplingMode='Sample';
 block.InputPort(k).DirectFeedthrough=true;
end
for k=1:5
 block.OutputPort(k).Dimensions=outputSize(k);
 block.OutputPort(k).DatatypeID=0;
 block.OutputPort(k).Complexity='Real';
 block.OutputPort(k).SamplingMode='Sample';
end
cfg=parameters();block.SampleTimes=[cfg.dt 0];
block.SimStateCompliance='DefaultSimState';
block.RegBlockMethod('PostPropagationSetup',@allocate);
block.RegBlockMethod('InitializeConditions',@initialize);
block.RegBlockMethod('Outputs',@outputs);
block.RegBlockMethod('Update',@update);
end
function allocate(block)
names={'Memory','Candidate','CachedOutput','CachedInput','CachedTime'};
sizes=[54 54 18 22 1];block.NumDworks=numel(names);
for k=1:numel(names)
 block.Dwork(k).Name=names{k};block.Dwork(k).Dimensions=sizes(k);
 block.Dwork(k).DatatypeID=0;block.Dwork(k).Complexity='Real';
 block.Dwork(k).UsedAsDiscState=k==1;
end
end
function initialize(block)
for k=1:4,block.Dwork(k).Data=zeros(block.Dwork(k).Dimensions,1);end
block.Dwork(5).Data=-inf;
network_policy(true);
end
function outputs(block)
input=vertcat(block.InputPort(1).Data,block.InputPort(2).Data, ...
 block.InputPort(3).Data,block.InputPort(4).Data,block.InputPort(5).Data);
if block.CurrentTime~=block.Dwork(5).Data||~isequaln(input,block.Dwork(4).Data)
 x=input(1:12);mu=input(13:14);station=input(15);base=input(16:21);
 mode=input(22);
 assert(ismember(mode,[1 2]),'Mode must be 1 (NMPC) or 2 (NGIL).');
 memory=unpack(block.Dwork(1).Data);
 if mode==2,policy=network_policy(false);else,policy=[];end
 [torque,delta,memory,~,reference]=controller_step(x,mu,station,base,memory,policy);
 action=zeros(3,1);fallback=0;
 if ~isempty(memory)
  action=memory.a;
  fallback=double(memory.fallback);
 end
 block.Dwork(2).Data=pack(memory);
 block.Dwork(3).Data=[torque;delta;action;reference;fallback];
 block.Dwork(4).Data=input;block.Dwork(5).Data=block.CurrentTime;
end
out=block.Dwork(3).Data;
block.OutputPort(1).Data=out(1:6);block.OutputPort(2).Data=out(7:8);
block.OutputPort(3).Data=out(9:11);block.OutputPort(4).Data=out(12:17);
block.OutputPort(5).Data=out(18);
end
function update(block)
block.Dwork(1).Data=block.Dwork(2).Data;
end
function p=network_policy(reload)
persistent policy
if isempty(policy)||reload
 root=fileparts(fileparts(mfilename('fullpath')));
 d=load(fullfile(root,'data','policy.mat'),'policy');policy=d.policy;
end
p=policy;
end
function value=pack(m)
value=zeros(54,1);if isempty(m),return;end
warm=zeros(18,1);valid=~isempty(m.warm);if valid,warm=m.warm;end
value=[1;double(m.expert);m.ticks;m.I;m.T;m.commonT;m.delta;m.a; ...
 m.lastV;m.decel;double(m.fallback);double(m.ruleFallback); ...
 m.roadCurrent;m.roadPrior;m.roadEdge;double(valid);warm];
end
function m=unpack(value)
m=[];if value(1)==0,return;end
warm=[];if value(36)~=0,warm=value(37:54);end
m=struct('expert',logical(value(2)),'ticks',value(3),'I',value(4:9), ...
 'T',value(10:15),'commonT',value(16:21),'delta',value(22), ...
 'a',value(23:25),'lastV',value(26),'decel',value(27), ...
 'fallback',logical(value(28)),'ruleFallback',logical(value(29)), ...
 'roadCurrent',value(30:31),'roadPrior',value(32:33),'roadEdge',value(34:35),'warm',warm);
end
