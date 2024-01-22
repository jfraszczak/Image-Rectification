clc;
clear;
close all;

img = imread('images/img3.png');

fprintf('F1 \n');
[imgWithLines, imgWithCorners] = FeatureExtraction(img);

fprintf('G1 \n');
[Hhorizontal, rectifiedHorizontalImg, imLinfty, ratio] = ReconstructionOfHorizontalSection(img, imgWithLines);
ratio

fprintf('G2 \n');
[K, absolute_conic] = CameraCalibration(img, Hhorizontal, imLinfty);
K

fprintf('G3 \n');
[Hvertical, rectifiedVerticalImg] = ReconstructionOfVerticalSection(img, absolute_conic);

fprintf('G4 \n');
cameraWrtPlanarFace = CameraLocalization(Hvertical, K);
cameraWrtPlanarFace