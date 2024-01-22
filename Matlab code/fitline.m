function [l] = fitline(pts)
x = pts(1, :);
y = pts(2, :);
p = polyfit(x, y, 1);
l = [p(1) -1 p(2)];
l = l./norm(l);
end