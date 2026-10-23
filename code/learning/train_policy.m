function [policy,history]=train_policy(updates,dataFile)
if nargin<1,updates=16000;end
root=fileparts(fileparts(mfilename('fullpath')));
if nargin<2,dataFile=fullfile(root,'data','training.mat');end
d=load(dataFile,'dataset','normalization');ds=d.dataset;
assert(updates>=1&&updates==fix(updates));
seeds=[101 202 303 404 505];
members=cell(1,numel(seeds));history=cell(size(members));
for k=1:numel(seeds)
 [members{k},history{k}]=train_member(ds,d.normalization,seeds(k),updates);
end
policy=struct('members',{members},'ensembleAggregation','mean','seeds',seeds);
policy.variant='NGIL';
end
