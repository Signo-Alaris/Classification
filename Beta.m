%%%%%%%%%%%
%
% Project: Vehicle Classification
%
% Dylan Delaney, Evan Morgan and Sam Evans
%
% Date: 23/04/17
%
% Introduction: The purpose of the code is to identify a vehicle
% classification from a side view of a vehicle. To do this the code will
% isolate the number of tyres in an image and calculate the ratio of
% distance between wheels against radius of wheels. This is achieved by
% using image processing techniques such as edge detection, morphology,
% segmentation masking and HSV. 
% 
% Algorithm:    - User selects image.
%               - Image cropped to bottom half (wheels).
%               - Vertical edge detection (removes shadow).
%               - Binarize image for morphology.
%               - Remove small pixel areas (bwareaopen()).
%               - Dilate the image to emphasise tyres.
%               - Concatenate third dimension onto dilated image.
%               - Segment mask the cropped image colour onto the image.
%               - Convert masked image into HSV colour space.
%               - Check each pixel against S and V thresholds. Save pixels
%               that pass to outputHSV image.
%               - Remove small pixel areas again (bwareaopen()).
%               - Close the image to emphasise the presence of tyres
%               - Find the number of circles in the image
%               (imfindcircles()).
%               - If two circles (tyres):
%                   - If wheel distance: wheel radius < 14.6 then CAR.
%                   - If wheel distance: wheel radius > 14.6 then BUS.
%               - If more than two circles (tyres) then TRUCK
%               - If one or less circles (tyres) then PHOTO OBSCURED.
%               - Output original image to user with vehicle classification
%               title.
% 
% The test images used were the 7 vehicle images provided and new photos we
% took ourselves.
%%%%%%%%%%%
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Initialisation  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Clear the command window, workspace and figures.
 
clc; 
clear all;
close all;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Filters  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Initialise the filters: Vertical edge detection filter.
 
edgeVertical = [-1 0 1; -1 0 1; -1 0 1] / 3;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Select Image  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The user is prompted to select a vehicle image of type .png, .jpg or
% .bmp. File explorer is then opened for the user to select the image file.
% The chosen image is saved as 'input'
 
disp('WELCOME! PLEASE SELECT YOUR VEHICLE IMAGE FILE!(.png, .jpg or .bmp)');
disp('NOTE: PLEASE MAKE SURE THE VEHICLE IN YOUR IMAGE IS COMPLETELY INSIDE THE IMAGE AND IS NOT DISTORTED.');
 
inputFile = uigetfile('*.jpg; *.bmp; *.png');
input = imread(inputFile);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Prepare Image  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The input image is then converted to double which is necessary for 
% matrix operations. 
% The height and width of the image is found to crop the top half of the 
% image. This is done because the wheels in the image will be in the 
% bottom half if the photo is not obscured. The height, width and depth of
% the new cropped image is then saved for later use.
% The image is then converted into a greyscale image for edge detection.
 
image = im2double(input);
 
[H, W] = size(image);
croppedImage = imcrop(image, [0 round(H / 2) W H]);
[H, W, D] = size(croppedImage);
 
g = rgb2gray(croppedImage);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Filtering  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The greyscale image is then filtered through a vertical edge filter to
% find the vertical edges. This helps to remove any shadow underneath the
% vehicle. This is an key step as any shadow will be similar to a tyre.
% This vertical edge output is then binarized for morphology. Any pixels 
% with brightness above 5% are turned white.
 
outputVertical = conv2(g, edgeVertical, 'same');
 
bwLimit = 0.05;
outputVertical = outputVertical > bwLimit;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Morphology 1  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Morphology a range of image processing techniques that process an image
% based on shapes.
% The first morphology operation removes any pixel areas under a specified
% threshold (in this case 40). This removes a lot of smaller areas from the
% image we're not interested in.
% The image is then dilated using a disk structuring element to emphasise 
% the presence of the tyres in the image.
 
pixelArea = 40;
outputMorph1 = bwareaopen(outputVertical, pixelArea);
 
SE = strel('disk', 6);
outputMorph1 = imdilate(outputMorph1, SE);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%  Segment mask  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% To mask the colour back onto the image a third dimension must be
% concatenated onto the morphology output. The colour of the image is then 
% masked back onto the morphology output from the cropped image.
 
outputMorph1 = cat(3, outputMorph1, outputMorph1, outputMorph1);
outputMask = outputMorph1 .* croppedImage;
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  HSV  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The tyres can now be found by searching in the HSV colour space. HSV 
% standing for Hue, Saturation and Value. This can be done by largely by 
% looking for low saturation values.
% The outputMask image is first converted to HSV. The tyres are then
% isolated by saturation and value (S < 0.15 & V < 0.6). These values are
% averages taken from multiple photos of tyres. 
% Each pixels S and V values are checked against the thresholds and if they
% are true then the pixel is saved in the outputHSV image.
 
HSV = rgb2hsv(outputMask);
 
S = 0.15;
V = 0.6;
outputHSV = zeros(H, W, 3);
 
for i = 1: H - 1
    for j = 1: W - 1
        if(HSV(i, j, 2) < S && HSV(i, j, 3) < V)
            outputHSV(i, j, 1) = HSV(i, j, 1);
            outputHSV(i, j, 2) = HSV(i, j, 2);
            outputHSV(i, j, 3) = HSV(i, j, 3);
        end
    end
end
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Morphology 2  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The first morphology operation removes any pixel areas under a specified
% threshold (in this case 40). This removes a lot of smaller areas from the
% image we're not interested in. The '+' changes the output from a logical
% to a double for imshow() later.
% The outputMorph2 image is then changed back to greyscale to perform 
% closing. The image is closed using a disk structuring element in order to
% further emphasise the presence of the tyres
 
pixelArea = 40;
outputMorph2 = +(bwareaopen(outputHSV, pixelArea));
 
outputMorph2 = rgb2gray(outputMorph2);
 
SE = strel('disk', 5);
outputMorph2 = imclose(outputMorph2, SE);
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%  Find Circles  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% imfindcircles() is used in order to find the circles (tyres) in the
% image. It finds the circles using the circular Hough transform. The 
% function requires several variables. First it takes the image to be 
% searched. Second it takes the minimum and maximum radius range of the 
% circles. Thirdly, it takes circles polarity (whether the circles are 
% bright or dark). Finally, it takes a sensitivity factor for the circular 
% Hough transform accumulator array.
% The centres and radii of the circles found are saved in the centres and
% radii variables.
 
sensivity = 0.94;
minR = 15;
maxR = 150;
[centres, radii] = imfindcircles(outputMorph2, [minR maxR], 'ObjectPolarity', 'bright', 'Sensitivity', sensivity);
 
%%%%%%%%%%%%%%%%%%%%%%%  Vehicle Classification  %%%%%%%%%%%%%%%%%%%%%%%%%%
% To classify a vehicle, we first look at how many centres (tyres) are there
% in an image. This is done by checking the size of the centres matrix. The
% size is then checked against several if statements.
% If the vehicle has two wheels it is either a bus or a car. The way to
% differentiate is by checking the ratio between the radius of a wheel
% against the distance between the wheels. The wheel distance is found by
% subtracting the two wheels centre column location from each other. The
% radius is found by averaging the two radius values found by
% imfindcircle(). These the radius then divides distance to get the
% ratio. If the ratio is less than 14.6 we have found it to be a car, if it
% is greater than 14.6 it is therefore a bus.
% If the vehicle has more than two tyres it is a truck.
% If the vehicle has one or less tyre than the image of the vehicle has
% been obscured.
% The vehicle classification is output to the command window and the #
% vehicleType variable is saved.
 
noCenters = size(centres);
 
if noCenters(1, 1) == 2
    wheelDistance = abs(centres(2, 1) - centres(1, 1));
    wheelRadius = (radii(1, 1) + radii(1, 1)) / 2;
 
    result = wheelDistance / wheelRadius;
 
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
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Output  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The input image is then displayed with the title equalling the vehicle
% classification.
 
figure, imshow(input), title(vehicleType);

%%%%%%%%%%%
% Conclusion: The code successfully achieves its goal of identifying a
% vehicles classification based on its wheels. The solution is general and
% works on multiple photos of different vehicles. The user's input is
% clearly identified and minimal making the solution almost completely
% automated. The code has been fully commented and is easy to follow. 
%%%%%%%%%%%