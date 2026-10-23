function obs=observation(original,env)
obs=[original;env(9:14);min(4,max(-2,env(15)-env(16:17)));env(18:19)];
assert(numel(obs)==28&&all(isfinite(obs)));
end
