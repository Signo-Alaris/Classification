clc; %clears command window
clear all; %clears all variables
close all; %closes all windows

%Let the user select the image
inputFile = uigetfile('*.jpg; *.bmp; *.png');
input = imread(inputFile);

% Edge Filters
EdgeVertical = [-1 0 1; -1 0 1; -1 0 1]/3;
EdgeHorizontal = [-1 -1 -1; 0 0 0; 1 1 1]/3;

% Convert image to double to allow for processing
image = im2double(input);

% Get height and width of images
[H,W,D] = size(image);

%Crop the top half of the image out as tyres will never be there
image = imcrop(image,[0 round(H/2) W H]);

% Get height and width of images
[H,W,D] = size(image);

%Convert from RGB to greyscale to allow for processing
g = rgb2gray(image);

% Find Vertical edges
outputVertical = conv2(g,EdgeVertical,'same');

% Binarize the images
bwLimit = 0.05;
outputVertical = outputVertical>bwLimit;

% Eliminate areas smaller than [pixelArea] pixels
pixelArea = 40;
outputVertical = bwareaopen(outputVertical,pixelArea);

% Dilate the image to emphasise the presence of tyres
SE = strel('disk',6);
outputVertical = imdilate(outputVertical, SE);

% Convert images from greyscale to rgb
outputVertical = cat(3,outputVertical,outputVertical,outputVertical);

% Use segmentation mask 
output = outputVertical.*image;

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

arrayofCenters = {centers};
arrayofRadii = {radii};


for i = 1:7
    noCenters = size(arrayofCenters{i});
    
    if noCenters(1, 1) == 2
        centers = arrayofCenters{i};
        radii = arrayofRadii{i};
        
        if i > 1
            radii = radii{1};
        end
        
        wheelDistance = abs(centers(2,1) - centers(1,1));
        wheelRadius = (radii(1,1)+radii(1,1))/2;
        
        result = wheelDistance/wheelRadius;
        
        if result < 14.6
            disp('Car');
            vehicleType = 'Car';
        end
        
        if result > 14.6
            disp('Bus');
            vehicleType = 'Bus';
        end
    end
    
    if noCenters(1, 1) > 2
        disp('Truck');
        vehicleType = 'Truck';
    end
    
    if noCenters(1, 1) <= 1
        disp('Photograph Obscured');
        vehicleType = 'Photograph Obscured';
    end
end

%Show all vehicle images
figure, imshow(Original), title(VehicleType);