function [H, rectifiedImg] = ReconstructionOfVerticalSection(img, absolute_conic)

figure;
imshow(img);

figure(gcf);
title('Draw Parallel Lines');
segment1 = drawline('Color', 'magenta');

figure(gcf);
title('Draw Parallel Lines');
segment2 = drawline('Color', 'magenta');

line1 = segToLine(segment1.Position);
line2 = segToLine(segment2.Position);

line1 = line1./norm(line1);
line2 = line2./norm(line2);

imgWithVanishingPoint = getframe;
imgWithVanishingPoint = imgWithVanishingPoint.cdata;
imwrite(imgWithVanishingPoint, 'output/imgWithVanishingPoint.png');

p1 = cross(line1, line2);
p1 = p1/p1(3);


figure(gcf);
title('Draw Parallel Lines');
segment1 = drawline('Color', 'blue');

figure(gcf);
title('Draw Parallel Lines');
segment2 = drawline('Color', 'blue');

line1 = segToLine(segment1.Position);
line2 = segToLine(segment2.Position);

line1 = line1./norm(line1);
line2 = line2./norm(line2);

imgWithParallelLinesVertical = getframe;
imgWithParallelLinesVertical = imgWithParallelLinesVertical.cdata;
imwrite(imgWithParallelLinesVertical, 'output/imgWithParallelLinesVertical.png');

p2 = cross(line1, line2);
p2 = p2/p2(3);

l = cross(p1, p2);
l = l./norm(l);


a = absolute_conic(1,1);
d = absolute_conic(1,3) * 2;
e = absolute_conic(2,3) * 2;
f = absolute_conic(3,3);

b=0;
c=1;

syms 'x';
syms 'y';

eq1 = a*x^2 + b*x*y + c*y^2 + d*x + e*y + f;
eq2 = l(1)*x + l(2)*y + l(3);

eqns = [eq1 ==0, eq2 ==0];
S = solve(eqns, [x,y]);
s1 = [double(S.x(1));double(S.y(1));1];
s2 = [double(S.x(2));double(S.y(2));1];

I = s1;
J = s2;

C = I * J' + J * I';
C = C./norm(C);
[U,S,~] = svd(C);
S(3,3) = 1;
H = inv(U * sqrt(S));

tform = projective2d(H');
rectifiedImg = imwarp(img,tform);

figure;
imshow(rectifiedImg);

imwrite(rectifiedImg, 'output/rectifiedVerticalImg.png');

end