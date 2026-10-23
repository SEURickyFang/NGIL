function y=mirror(x,kind)
if strcmp(kind,'observation')
 assert(size(x,1)==28);
 order=[1 2 3 4 5 7 6 8 12 13 14 9 10 11 16 15 17 18 22 23 24 19 20 21 26 25 28 27];
 signs=ones(28,1);signs([2:5 8 17])=-1;
 y=signs.*x(order,:);
else
 assert(strcmp(kind,'action')&&size(x,1)==3);
 y=x([2 1 3],:);y(3,:)=-y(3,:);
end
end
