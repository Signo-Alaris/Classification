clc;
clear all;  
close all;  

% I = imread('Vehicles1.png'); % Car 1
% I = imread('Vehicles5.png'); % Bus 2 
I = imread('Vehicles6.png'); % Truck 1

% I = imread('Vehicles2.png'); % Car 1
% I = imread('Vehicles3.png'); % Car 3
% I = imread('Vehicles4.png'); % Bus 1
% I = imread('Vehicles7.png'); % Truck 2

I = im2double(I);
R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

G = rgb2gray(I);

Sx = [1 0 -1;
      2 0 -2;
      1 0 -1] / 4;

Sy = [-1 -2 -1;
      0  0  0;
     1 2 1] / 4; 
% 
% edgex = conv2(G, Sx, 'same');
% edgex = abs(edgex);
% edgey = conv2(G, Sy, 'same');
% edgey = abs(edgey);
% edges = edgex + edgey;
% 
% figure, imshow(edgex);
% clean(:,:,1) = edgex .* R;
% clean(:,:,2) = edgex .* G;
% clean(:,:,3) = edgex .* B;
% figure, imshow(clean);
% 
% 
HSV = rgb2hsv(I);
H = HSV(:,:,1); 
S = HSV(:,:,2);
V = HSV(:,:,3);

tyre = (S < 0.12) & (V < 0.2) & (R <0.18) & (G < 0.18) & (B < 0.18);
% tyre2 = bwmorph(tyre,'skel');
% tyre2 = bwmorph(tyre,'bridge');
% tyre2 = bwareaopen(tyre, 10);
% Output(:,:,1) = tyre .* R;
% Output(:,:,2) = tyre .* G;
% Output(:,:,3) = tyre .* B;
figure,subplot(121),imshow(tyre);
subplot(122),imshow(tyre2);
