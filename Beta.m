%%%%%%%%%%%
%
% Project: Vehicle Classification
%
% Dylan Delaney, Evan Morgan and Sam Evans
%
% Date: 23/04/17
%
% Introduction: The purpose of the code is to identify a vehicle
% classification from a side view of a vehicle. This is achieved by...
% 
% Algorithm:    - User selects image.
%               - Image cropped to bottom half (wheels)
%               - Vertical edge detection (removes shadow)
%               - Binarize image for morphology
%               - Remove small pixel areas (bwareaopen())
%               - Dilate the image to emphasise tyres
% 
% The test images used were the 7 vehicle images provided and new photos we
% took ourselves.

%%%%%%%%%%%%%%%%%%%%%%%%%%%  Initilisation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear the command window, workspace and figures.

clc; 
clear all;
close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Filters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initilise the filters: Vertical edge detection filter.

edgeVertical = [-1 0 1; -1 0 1; -1 0 1] / 3;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Select Image  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The user is prompted to sleect a vehicle image of type .png, .jpg or
% .bmp. File explorer is then opened for the user to select the image file.
% The chosen image is saved as 'input'

disp('WELCOME! PLEASE SELECT YOUR VEHICLE IMAGE FILE!(.png, .jpg or .bmp)');
disp('NOTE: PLEASE MAKE SURE THE VEHICLE IN YOUR IMAGE IS COMPLETELY INSIDE THE IMAGE AND IS NOT DISTORTED.');

inputFile = uigetfile('*.jpg; *.bmp; *.png');
input = imread(inputFile);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Prepare Image  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The input image is then converted to double which is neccessary for 
% matrix operations. 
% The height and width of the image is found so as to crop the top half of 
% the image. This is done because the wheels in the image will be in the 
% bottom half if the photo is not obscured. The height, width and depth of
% the new cropped image is then saved for later use.
% The image is then converted into a greyscale image for edge detection.

image = im2double(input);

[H, W] = size(image);
croppedImage = imcrop(image, [0 round(H/2) W H]);
[H, W, D] = size(croppedImage);

g = rgb2gray(croppedImage);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Filtering  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The greyscale image is then filtered through a vertical edge filter to
% find the vertical edges. This helps to remove any shadow underneath the
% vehicle. This is an important step as any shadow will be similar to a 
% tyre.
% This vertical edge output is then binarized for morphology.

outputVertical = conv2(g, edgeVertical, 'same');

bwLimit = 0.05;
outputVertical = outputVertical>bwLimit;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Morphology  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Morphology a range of image processing techniques that process an image
% based on shapes.
% The first morphology operation removes any pixel areas under a specified
% threshold (in this case 40). This removes a lot of smaller areas from the
% image we're not interseted in.
% The image is then dilated using a disk structuring element to emphasise 
% the presence of the tyres in the image.

pixelArea = 40;
outputVertical = bwareaopen(outputVertical,pixelArea);

SE = strel('disk',6);
outputVertical = imdilate(outputVertical, SE);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  HSV  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The tyres can now be found by searching in the HSV colour space. HSV 
% standing for Hue, Saturation and Value. This can be done by largely by 
% looking for low saturation values.
% 
% The original image (large) is first converted to hsv and each dimension 
% saved to their own vairiable: H, S and V. The RGB values of the original
% image are saved to variables to be used for segmentation masking later.

% Convert images from greyscale to rgb
outputVertical = cat(3,outputVertical,outputVertical,outputVertical);

% Use segmentation mask 
output = outputVertical.*croppedImage;

%Convert to hsv
output = rgb2hsv(output);

%Isolate tyres using HSV values and place them in the bw image
sat = 0.15;
val = 0.6;
bw = zeros(H,W,3);
for i=1:H-1
    for j=1:W-1
        if(output(i,j,2)<sat && output(i,j,3)<val)
            bw(i,j,1) = output(i,j,1);
            bw(i,j,2) = output(i,j,2);
            bw(i,j,3) = output(i,j,3);
        end
    end
end

% Eliminate areas smaller than [pixelArea] pixels
pixelArea = 40;
bw = +(bwareaopen(bw,pixelArea));

%Change back to greyscale to perform closing, dilation
bw = rgb2gray(bw);

% Close the image to emphasise the presence of tyres
SE = strel('disk',5);
bw = imclose(bw, SE);

% Find circles in image using imfindcircles
sensivity = 0.94;
minR = 15;
maxR = 150;
[centers, radii] = imfindcircles(bw,[minR maxR],'ObjectPolarity','bright','Sensitivity',sensivity);


noCenters = size(centers);

if noCenters(1, 1) == 2
    wheelDistance = abs(centers(2,1) - centers(1,1));
    wheelRadius = (radii(1,1)+radii(1,1))/2;

    result = wheelDistance/wheelRadius;

    if result < 14.6
        disp('YOUR VEHICLE IS A CAR!');
        vehicleType = 'Car';
    end

    if result > 14.6
        disp('YOUR VEHICLE IS A BUS!');
        vehicleType = 'Bus';
    end
end

if noCenters(1, 1) > 2
    disp('YOUR VEHICLE IS A TRUCK!');
    vehicleType = 'Truck';
end

if noCenters(1, 1) <= 1
    disp('PHOTOGRAPH OBSCURED, PLEASE TRY AGAIN');
    vehicleType = 'PHOTOGRAPH OBSCURED';
end

%Show all vehicle images
figure, imshow(input), title(vehicleType);