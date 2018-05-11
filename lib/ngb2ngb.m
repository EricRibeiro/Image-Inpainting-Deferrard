function [n2n] = ngb2ngb(MAP, region)

label = region;  % label of object to find neighbours of
object = MAP == label;
se = ones(3);   % 8-connectivity for neighbours - could be changed
neighbours = imdilate(object, se) & ~object;
n2n = unique(MAP(neighbours));
disp(n2n);