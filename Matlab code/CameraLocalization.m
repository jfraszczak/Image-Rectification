function [cameraWrtPlanarFace] = CameraLocalization(H, K)

planarObject = inv(K) * H;
i = planarObject(:, 1);
j = planarObject(:, 2);
k = cross(i, j);
o = planarObject(:, 3);

cameraWrtPlanarFace = eye(4);
cameraWrtPlanarFace(1:3,1) = i;
cameraWrtPlanarFace(1:3,2) = j;
cameraWrtPlanarFace(1:3,3) = k;
cameraWrtPlanarFace(1:3,4) = o;
cameraWrtPlanarFace = inv(cameraWrtPlanarFace);

end