clc; %clears command window
clear all; %clears all variables
close all; %closes all windows

%Let the user select the image
%thresholdFile = uigetfile('*.jpg; *.bmp; *.png');

%Read in the selected image
% input = imread('Vehicles1.png');
% input = imread('Vehicles2.png');
% input = imread('Vehicles3.png');
input = imread('Vehicles4.png');
% input = imread('Vehicles5.png');
% input = imread('Vehicles6.png');
% input = imread('Vehicles7.png');

% Edge Filters
EdgeVertical = [-1 0 1; -1 0 1; -1 0 1]/3;
EdgeHorizontal = [-1 -1 -1; 0 0 0; 1 1 1]/3;

% Convert image to double to allow for processing
image = im2double(input);

% Show Original Image
subplot(3,2,1), imshow(image), title('Original');
disp('Show Original Image');

% Get height and width of image
[H,W,D] = size(image);

% Convert to Greyscale
g = rgb2gray(image);

% Find Vertical edges
outputVertical = conv2(g,EdgeVertical,'same');
subplot(3,2,2), imshow(outputVertical), title('Vertical Output');

% Find Horizontal edges
outputHorizontal = conv2(g,EdgeHorizontal,'same');
subplot(3,2,3), imshow(outputHorizontal), title('Horizontal Output');

% Combine both Edge outputs
output = outputVertical + outputHorizontal;
subplot(3,2,4), imshow(output), title('Combined Output');

% Find the average value of a pixel in the image and subtract that so only
% the hardest edges show
min = min(output(:));
output = output - min;
max = max(output(:));
output = output/max;
output = output - (mean2(output)+std2(output));
subplot(3,2,5), imshow(output), title('Filtered Output');
