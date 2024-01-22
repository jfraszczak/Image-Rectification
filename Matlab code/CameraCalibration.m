function [K, absolute_conic] = CameraCalibration(img, Hhorizontal, l)
figure;
imshow(img);
figure(gcf);
title('Draw Vanishing Point Orthogonal to Rectified Plane');
segment1 = drawline('Color', 'magenta');

figure(gcf);
title('Draw Vanishing Point Orthogonal to Rectified Plane');
segment2 = drawline('Color', 'magenta');

line1 = segToLine(segment1.Position);
line2 = segToLine(segment2.Position);

line1 = line1./norm(line1);
line2 = line2./norm(line2);

v = cross(line1, line2);
v = v/v(3);

h = inv(Hhorizontal);

syms 'a';
syms 'd';
syms 'e';
syms 'f';

eq1 = l(2)*v(1)*a + l(2)*v(3)*d/2 - l(1)*v(3)*e/2 - l(1)*v(2);
eq2 = l(3)*v(2) + l(3)*v(3)*e/2 - l(2)*v(1)*d/2 - l(2)*v(2)*e/2 - l(2)*v(3)*f;
eq3 = h(1,1)*h(1,2)*a + h(1,1)*h(3,2)*d/2 + h(2,1)*h(2,2) + h(2,1)*h(3,2)*e/2 + h(3,1)*h(1,2)*d/2 + h(3,1)*h(2,2)*e/2 + h(3,1)*h(3,2)*f;
eq4 = h(1,1)^2 * a + h(2,1)^2 + h(1,1)*h(3,1)*d + h(2,1)*h(3,1)*e + h(3,1)^2*f -(h(1,2)^2 * a + h(2,2)^2 + h(1,2)*h(3,2)*d + h(2,2)*h(3,2)*e + h(3,2)^2*f);

eqns = [eq1 ==0, eq2 ==0, eq3 ==0, eq4 ==0];
S = solve(eqns, [a,d,e,f]);

a = double(S.a(1));
d = double(S.d(1));
e = double(S.e(1));
f = double(S.f(1));

absolute_conic = zeros(3);
absolute_conic(1,1) = a;
absolute_conic(1,3) = d / 2;
absolute_conic(3,1) = d / 2;
absolute_conic(2,3) = e / 2;
absolute_conic(3,2) = e / 2;
absolute_conic(3,3) = f;

absolute_conic(2,2) = 1;

tic, Uj = nearestSPD(absolute_conic);
K = chol(inv(Uj));

K = K / K(3,3);

%absolute_conic = inv(K*K');

end