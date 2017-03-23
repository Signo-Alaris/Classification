%%%%%%%%%%%
%
% Car Identification Edge Detection Test
%
% Sam Evans
%
% Date: 10th March 2017
%
% Introduction:
% Algorithm:

%%%%%%%%%%%%%%%%%%%%%%%%%%%  Initilisation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear the command window, workspace and figures.
clc;
clear all;  
close all;  

% Reads in the image for testing and converts it to double which is
% neccessary for matrix operations. The image is then converted into a
% greyscale image.

I = imread('Vehicles1.png');
% I = imread('Vehicles2.png');
% I = imread('Vehicles3.png');
% I = imread('Vehicles4.png');
% I = imread('Vehicles5.png');
% I = imread('Vehicles6.png');
% I = imread('Vehicles7.png');
I = im2double(I);
G = rgb2gray(I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Filters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initilise the filters: horizontal edge filter and vertical edge filter.

Sx = [-1 0 -1;
      -2 0 -2;
      -1 0 -1] / 4;

Sy = [1 -2 -1;
      0  0  0;
     -1 -2 -1] / 4; 

 
%%%%%%%%%%%%%%%%%%%%%%%%  Adaptive Thresholding  %%%%%%%%%%%%%%%%%%%%%%%%%%
% Form of segmentation that sets pixels to either a foreground or 
% background value based on an intesity value threshold. Adaptive differs 
% from global by setting unique thresholds for different sections of an 
% image. 
% 
% A square(cookie) of 7x7 pixels is thresholded for every pixel. the height
% and width of the filtered image are used so as not to go over the edge of
% the image. If the pixel is above the mean intensity value of the cookie -
% C (in this case 7/225) then it is set to 1(White). If not, it is set to 0
% (Black).

% [H, W] = size(G);
% Gthr = G;
% n = 3;
% half = floor(n / 2);
% 
% for i = half + 1:H - half
%     for j = half + 1:W - half
%         Cookie = G(i - half:i + half, j - half:j + half);
%         Gthr(i, j) = G(i, j) > mean(Cookie(:)) - 10 / 255;
%     end
% end
% 
% imshow(Gthr)

%%%%%%%%%%%%%%%%%%%%%%%%%%  Segment mask  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The colour of the image is then masked back onto the edges of the
% signature. The new image S is equal to the edges image dot producted with
% the original image three times for each colour(RGB).

% S = Gthr .* G;
% 
% 
% imshow(S)

%%%%%%%%%%%%%%%%%%%%%%%%%  Edge Detection  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Edges are the sections of images with most change between pixels. The
% horizontal and vertical edges of the thresholded image are found and then
% added toether to get an image with all the edges.

edgex = conv2(G, Sx, 'same');
edgex = abs(edgex);
edgey = conv2(G, Sy, 'same');
edgey = abs(edgey);
edges = edgex + edgey;
imshow(edges)

% S = edges .* G;

% for i = 1:3
%     S(:,:,i) = edges.* I(:,:,i);
% end
% imshow(S)

% [H, W] = size(S);
% Sthr = S;
% n = 7;
% half = floor(n / 2);
% 
% for i = half + 1:H - half
%     for j = half + 1:W - half
%         Cookie = S(i - half:i + half, j - half:j + half);
%         Sthr(i, j) = S(i, j) > mean(Cookie(:)) - 10 / 255;
%     end
% end

% imshow(Sthr)