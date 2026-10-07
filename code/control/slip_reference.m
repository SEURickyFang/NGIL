function ref=slip_reference(u,base)
assert(size(u,1)==3);
ref=base.*[repmat(1-u(1),3,1);repmat(1-u(2),3,1)];
end
