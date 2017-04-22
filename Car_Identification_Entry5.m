%%%%%%%%%%%
%
% Vehicle Identification Entry 5
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
% Initilise the filters: low pass filter filter, horizontal edge filter and
% vertical edge filter.
     
lpf = [1 1 1;
       1 1 1;
       1 1 1] / 9;
     
Sx = [1 0 -1;
      2 0 -2;
      1 0 -1] / 4;

Sy = [-1 -2 -1;
      0  0  0;
     1 2 1] / 4; 
 
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

[H, W] = size(Gstr);
Gthr = Gstr;
n = 2;
half = floor(n / 2);

for i = half + 1:H - half
    for j = half + 1:W - half
        Cookie = Gstr(i - half:i + half, j - half:j + half);
        Gthr(i, j) = Gstr(i, j) > mean(Cookie(:)) - 12 / 255;
    end
end

ROI = (1-Gthr);

R = I(:,:,1);
G = I(:,:,2);
B = I(:,:,3);

SE = strel('square',1);

% ROI = bwmorph(edgex,'clean');
% ROI = imerode(edgex, SE); % Maybe wont find wally!!!
% ROI = imdilate(edgex, SE);
% ROI = imopen(edgex, SE);
% ROI = imclose(edgex, SE);
% ROI = bwmorph(edgex,'branchpoints');
% ROI = bwmorph(edgex,'bridge');
ROI = bwmorph(ROI,'fill');
ROI = bwmorph(ROI,'bridge');
ROI = bwareaopen(ROI, 100);

% SE = strel('disk',2);
% edge = ROI - imerode(ROI, SE);
% ROI = edge;
Output(:,:,1) = ROI .* R;
Output(:,:,2) = ROI .* G;
Output(:,:,3) = ROI .* B;
figure,imshow(Output)

%%% Crop image if solution doesnt work... %%%
croppedImage = imcrop(Output);
imshow(croppedImage);

[H, W] = size(croppedImage);
first = find(croppedImage, 1, 'first');
last = find(croppedImage, 1, 'last');

firstans = floor(first/H);
firstcol = first - (firstans*H);

if firstcol == 0 
    firstrow = firstans;
    
    else 
    firstrow = firstans + 1;
end

% lastans = floor(last/W);
% lastcol = last - (lastans*W);
% 
% if lastcol == 0 
%     lastrow = lastans;
%     
%     else 
%     lastrow = lastans + 1;
% end

    
