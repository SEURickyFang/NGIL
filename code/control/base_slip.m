function base=base_slip(mu)
persistent table
if isempty(table)
 root=fileparts(fileparts(mfilename('fullpath')));
 d=load(fullfile(root,'data','parameters.mat'),'feedforward');table=d.feedforward;
end
assert(numel(mu)==2);
base=zeros(6,1);
if any(~isfinite(mu))||any(mu<=0),return;end
left=min(table.muL(end),max(table.muL(1),mu(1)));
right=min(table.muR(end),max(table.muR(1),mu(2)));
for k=1:6
 base(k)=interp2(table.muR,table.muL,table.lambda(:,:,k),right,left,'linear');
end
end
