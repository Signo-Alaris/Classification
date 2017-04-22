%%%%%%%%%%%
%
% Car Identification Week 2
%
% Sam Evans
%
% Date: 23rd March 2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%  Initilisation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear the command window, workspace and figures.
clc;
clear all;  
close all;  

% Reads in the image for testing and converts it to double which is
% neccessary for matrix operations. The image is then converted into a
% greyscale image.

% I = imread('Vehicles1.png');
% I = imread('Vehicles2.png');
% I = imread('Vehicles3.png');
% I = imread('Vehicles4.png');
% I = imread('Vehicles5.png');
I = imread('Vehicles6.png');
% I = imread('Vehicles7.png');
I = im2double(I);
G = rgb2gray(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%  Contrast Streching  %%%%%%%%%%%%%%%%%%%%%%%%%%
% Contrast streching widens the range of intensity values of an image. The
% number of times a certain intensity value occurs  in G, is set as COUNTS, 
% and the intensity value itself is set in X. The minimum and maximum 
% intesity values are found, excluding intesity values that appear less 
% than 100 times in the image. This is done to avoid small intesity value 
% peaks from affecting the streching. The contrast is then streched using a 
% simple linear transform.

[COUNTS, X] = imhist(G);

for i = 1:length(X)
    if COUNTS(i) > 300
        Gmin = X(i);
        break
    end
end

for i = length(X):-1:1
    if COUNTS(i) > 300
        Gmax = X(i);
        break
    end
end

Gstr = (G - Gmin) / (Gmax - Gmin);

subplot(2,2,1), imshow(G);
subplot(2,2,2), imhist(G);
subplot(2,2,3), imshow(Gstr);
subplot(2,2,4), imhist(Gstr);