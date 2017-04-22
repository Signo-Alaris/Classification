clc; %clears command window
clear all; %clears all variables
close all; %closes all windows

%Let the user select the image
%thresholdFile = uigetfile('*.jpg; *.bmp; *.png');

%Read in the selected image
input1 = imread('Vehicles1.png');
input2 = imread('Vehicles2.png');
input3 = imread('Vehicles3.png');
input4 = imread('Vehicles4.png');
input5 = imread('Vehicles5.png');
input6 = imread('Vehicles6.png');
input7 = imread('Vehicles7.png');

% Edge Filters
EdgeVertical = [-1 0 1; -1 0 1; -1 0 1]/3;
EdgeHorizontal = [-1 -1 -1; 0 0 0; 1 1 1]/3;

% Convert image to double to allow for processing
image1 = im2double(input1);
image2 = im2double(input2);
image3 = im2double(input3);
image4 = im2double(input4);
image5 = im2double(input5);
image6 = im2double(input6);
image7 = im2double(input7);

% Show Original Image
% subplot(3,2,1), imshow(image), title('Original');
% disp('Show Original Image');

% Get height and width of images
[H1,W1,D1] = size(image1);
[H2,W2,D2] = size(image2);
[H3,W3,D3] = size(image3);
[H4,W4,D4] = size(image4);
[H5,W5,D5] = size(image5);
[H6,W6,D6] = size(image6);
[H7,W7,D7] = size(image7);

%Crop the top half of the image out as tyres will never be there
image1 = imcrop(image1,[0 round(H1/2) W1 H1]);
image2 = imcrop(image2,[0 round(H2/2) W2 H2]);
image3 = imcrop(image3,[0 round(H3/2) W3 H3]);
image4 = imcrop(image4,[0 round(H4/2) W4 H4]);
image5 = imcrop(image5,[0 round(H5/2) W5 H5]);
image6 = imcrop(image6,[0 round(H6/2) W6 H6]);
image7 = imcrop(image7,[0 round(H7/2) W7 H7]);

% Get height and width of images
[H1,W1,D1] = size(image1);
[H2,W2,D2] = size(image2);
[H3,W3,D3] = size(image3);
[H4,W4,D4] = size(image4);
[H5,W5,D5] = size(image5);
[H6,W6,D6] = size(image6);
[H7,W7,D7] = size(image7);

%Convert from RGB to greyscale
g1 = rgb2gray(image1);
g2 = rgb2gray(image2);
g3 = rgb2gray(image3);
g4 = rgb2gray(image4);
g5 = rgb2gray(image5);
g6 = rgb2gray(image6);
g7 = rgb2gray(image7);

% Find Vertical edges
outputVertical1 = conv2(g1,EdgeVertical,'same');
outputVertical2 = conv2(g2,EdgeVertical,'same');
outputVertical3 = conv2(g3,EdgeVertical,'same');
outputVertical4 = conv2(g4,EdgeVertical,'same');
outputVertical5 = conv2(g5,EdgeVertical,'same');
outputVertical6 = conv2(g6,EdgeVertical,'same');
outputVertical7 = conv2(g7,EdgeVertical,'same');

% Binarize the images
bwLimit = 0.05;
outputVertical1 = outputVertical1>bwLimit;
outputVertical2 = outputVertical2>bwLimit;
outputVertical3 = outputVertical3>bwLimit;
outputVertical4 = outputVertical4>bwLimit;
outputVertical5 = outputVertical5>bwLimit;
outputVertical6 = outputVertical6>bwLimit;
outputVertical7 = outputVertical7>bwLimit;

% Eliminate areas smaller than [pixelArea] pixels
pixelArea = 40;
outputVertical1 = bwareaopen(outputVertical1,pixelArea);
outputVertical2 = bwareaopen(outputVertical2,pixelArea);
outputVertical3 = bwareaopen(outputVertical3,pixelArea);
outputVertical4 = bwareaopen(outputVertical4,pixelArea);
outputVertical5 = bwareaopen(outputVertical5,pixelArea);
outputVertical6 = bwareaopen(outputVertical6,pixelArea);
outputVertical7 = bwareaopen(outputVertical7,pixelArea);

% Dilate the image to emphasise the presence of tyres
SE = strel('disk',6);
outputVertical1 = imdilate(outputVertical1, SE);
outputVertical2 = imdilate(outputVertical2, SE);
outputVertical3 = imdilate(outputVertical3, SE);
outputVertical4 = imdilate(outputVertical4, SE);
outputVertical5 = imdilate(outputVertical5, SE);
outputVertical6 = imdilate(outputVertical6, SE);
outputVertical7 = imdilate(outputVertical7, SE);

% Convert images from greyscale to rgb
outputVertical1 = cat(3,outputVertical1,outputVertical1,outputVertical1);
outputVertical2 = cat(3,outputVertical2,outputVertical2,outputVertical2);
outputVertical3 = cat(3,outputVertical3,outputVertical3,outputVertical3);
outputVertical4 = cat(3,outputVertical4,outputVertical4,outputVertical4);
outputVertical5 = cat(3,outputVertical5,outputVertical5,outputVertical5);
outputVertical6 = cat(3,outputVertical6,outputVertical6,outputVertical6);
outputVertical7 = cat(3,outputVertical7,outputVertical7,outputVertical7);

% Use segmentation mask 
output1 = outputVertical1.*image1;
output2 = outputVertical2.*image2;
output3 = outputVertical3.*image3;
output4 = outputVertical4.*image4;
output5 = outputVertical5.*image5;
output6 = outputVertical6.*image6;
output7 = outputVertical7.*image7;

%Convert to hsv
output1 = rgb2hsv(output1);
output2 = rgb2hsv(output2);
output3 = rgb2hsv(output3);
output4 = rgb2hsv(output4);
output5 = rgb2hsv(output5);
output6 = rgb2hsv(output6);
output7 = rgb2hsv(output7);

%Isolate 
sat = 0.15;
val = 0.6;
bw1 = zeros(H1,W1,3);
for i=1:H1-1
    for j=1:W1-1
        if(output1(i,j,2)<sat && output1(i,j,3)<val)
            bw1(i,j,1) = output1(i,j,1);
            bw1(i,j,2) = output1(i,j,2);
            bw1(i,j,3) = output1(i,j,3);
        end
    end
end

bw2 = zeros(H2,W2,3);
for i=1:H2
    for j=1:W2
        if(output2(i,j,2)<sat && output2(i,j,3)<val)
            bw2(i,j,1) = output2(i,j,1);
            bw2(i,j,2) = output2(i,j,2);
            bw2(i,j,3) = output2(i,j,3);
        end
    end
end

bw3 = zeros(H3,W3,3);
for i=1:H3
    for j=1:W3
        if(output3(i,j,2)<sat && output3(i,j,3)<val)
            bw3(i,j,1) = output3(i,j,1);
            bw3(i,j,2) = output3(i,j,2);
            bw3(i,j,3) = output3(i,j,3);
        end
    end
end

bw4 = zeros(H4,W4,3);
for i=1:H4
    for j=1:W4
        if(output4(i,j,2)<sat && output4(i,j,3)<val)
            bw4(i,j,1) = output4(i,j,1);
            bw4(i,j,2) = output4(i,j,2);
            bw4(i,j,3) = output4(i,j,3);
        end
    end
end

bw5 = zeros(H5,W5,3);
for i=1:H5
    for j=1:W5
        if(output5(i,j,2)<sat && output5(i,j,3)<val)
            bw5(i,j,1) = output5(i,j,1);
            bw5(i,j,2) = output5(i,j,2);
            bw5(i,j,3) = output5(i,j,3);
        end
    end
end

bw6 = zeros(H6,W6,3);
for i=1:H6
    for j=1:W6
        if(output6(i,j,2)<0.13 && output6(i,j,3)<val)
            bw6(i,j,1) = output6(i,j,1);
            bw6(i,j,2) = output6(i,j,2);
            bw6(i,j,3) = output6(i,j,3);
        end
    end
end

bw7 = zeros(H7,W7,3);
for i=1:H7
    for j=1:W7
        if(output7(i,j,2)<0.13 && output7(i,j,3)<val)
            bw7(i,j,1) = output7(i,j,1);
            bw7(i,j,2) = output7(i,j,2);
            bw7(i,j,3) = output7(i,j,3);
        end
    end
end

% Eliminate areas smaller than [pixelArea] pixels
pixelArea = 40;
bw1 = +(bwareaopen(bw1,pixelArea));
bw2 = +(bwareaopen(bw2,pixelArea));
bw3 = +(bwareaopen(bw3,pixelArea));
bw4 = +(bwareaopen(bw4,pixelArea));
bw5 = +(bwareaopen(bw5,pixelArea));
bw6 = +(bwareaopen(bw6,pixelArea));
bw7 = +(bwareaopen(bw7,pixelArea));

%Change back to greyscale to perform closing, dilation
bw1 = rgb2gray(bw1);
bw2 = rgb2gray(bw2);
bw3 = rgb2gray(bw3);
bw4 = rgb2gray(bw4);
bw5 = rgb2gray(bw5);
bw6 = rgb2gray(bw6);
bw7 = rgb2gray(bw7);

% Close the image to emphasise the presence of tyres
SE = strel('disk',5);
bw1 = imclose(bw1, SE);
bw2 = imclose(bw2, SE);
bw3 = imclose(bw3, SE);
bw4 = imclose(bw4, SE);
bw5 = imclose(bw5, SE);
bw6 = imclose(bw6, SE);
bw7 = imclose(bw7, SE);

% % Dilate the image to emphasise the presence of tyres
% SE = strel('disk',2);
% bw1 = imdilate(bw1, SE);
% bw2 = imdilate(bw2, SE);
% bw3 = imdilate(bw3, SE);
% bw4 = imdilate(bw4, SE);
% bw5 = imdilate(bw5, SE);
% bw6 = imdilate(bw6, SE);
% bw7 = imdilate(bw7, SE);

% Find circles
sensivity = 0.94;
minR = 15;
maxR = 150;
[centers1, radii1] = imfindcircles(bw1,[minR maxR],'ObjectPolarity','bright','Sensitivity',sensivity);
[centers2, radii2] = imfindcircles(bw2,[minR maxR],'ObjectPolarity','bright','Sensitivity',sensivity);
[centers3, radii3] = imfindcircles(bw3,[minR maxR],'ObjectPolarity','bright','Sensitivity',sensivity);
[centers4, radii4] = imfindcircles(bw4,[minR maxR],'ObjectPolarity','bright','Sensitivity',sensivity);
[centers5, radii5] = imfindcircles(bw5,[minR maxR],'ObjectPolarity','bright','Sensitivity',sensivity);
[centers6, radii6] = imfindcircles(bw6,[minR maxR],'ObjectPolarity','bright','Sensitivity',sensivity);
[centers7, radii7] = imfindcircles(bw7,[minR maxR],'ObjectPolarity','bright','Sensitivity',sensivity);

%Show all vehicle images
subplot(4,2,1), imshow(bw1), title('Vehicle1');
h1 = viscircles(centers1,radii1);
subplot(4,2,2), imshow(bw2), title('Vehicle2');
h2 = viscircles(centers2,radii2);
subplot(4,2,3), imshow(bw3), title('Vehicle3');
h3 = viscircles(centers3,radii3);
subplot(4,2,4), imshow(bw4), title('Vehicle4');
h4 = viscircles(centers4,radii4);
subplot(4,2,5), imshow(bw5), title('Vehicle5');
h5 = viscircles(centers5,radii5);
subplot(4,2,6), imshow(bw6), title('Vehicle6');
h6 = viscircles(centers6,radii6);
subplot(4,2,7), imshow(bw7), title('Vehicle7');
h7 = viscircles(centers7,radii7);