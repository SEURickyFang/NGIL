function delta=steer_limit(command,~,cfg)
if isa(command,'casadi.MX')
 import casadi.*
 delta=fmin(cfg.angleMax,fmax(-cfg.angleMax,command));
else
 delta=min(cfg.angleMax,max(-cfg.angleMax,command));
end
end
