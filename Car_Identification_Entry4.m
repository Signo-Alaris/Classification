%%%%%%%%%%%
%
% Vehicle Identification Entry 4
%
% Sam Evans
%
% Date: April 21st 2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%  Initilisation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear the command window, workspace and figures.
clc;
clear all;  
close all;  

% Reads in the image for testing and converts it to double which is
% neccessary for matrix operations. The image is then converted into a
% greyscale image.

% I = imread('Vehicles1.png');
I = imread('Vehicles2Paint.png');
% I = imread('Vehicles2.png');
% I = imread('Vehicles3.png');
% I = imread('Vehicles4.png');
% I = imread('Vehicles5.png');
% I = imread('Vehicles6.png');
% I = imread('Vehicles7.png');
I = im2double(I);
R = I(:, :, 1);
G = I(:, :, 2);
B = I(:, :, 3);

YCbCr = rgb2ycbcr(I);
Y = YCbCr(:, :, 1);
Cb = YCbCr(:, :, 2);
Cr = YCbCr(:, :, 3);

% ROI = (Cb > 125/255) & (Cb < 132/255) & (Cr > 119/255) &(Cr < 127/255);

figure, plot(Cb,Cr), ylabel('Cr'), xlabel('Cb');

% output = I;
% output(:,:,1) = ROI.*R;
% output(:,:,2) = ROI.*G;
% output(:,:,3) = ROI.*B;
% 
% imshow(output);