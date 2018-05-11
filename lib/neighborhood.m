function [searchRegion] = neighborhood(img, sgm, r1, c1, adjacency)

% neighborhood generates a new inpainting search region
%   Input parameters :
%       img   : original masked image 
%       smg   : segmented img
%   Output parameters :
%       searchRegion : new pixel list for search
%
% Author:Sarah Carneiro
% Date: December 2017
% -------------------------------------------------------------------------
% For this funtion to work the original and segmented image need to be the
% exact same size. Otherwise the inpainting algorithm will show errors
% because of pixels mismatch.
%--------------------------------------------------------------------------
Original = img;
Segmented = sgm;

[heightO, widthO, dimO] = size(Original);
[heightN, widthN, dimN] = size(Segmented);
%--------------------------------------------------------------------------
% Best if enters only Else condition. If condition is only to verify if 
% image width and height are the same in both original and segmented image,
% modify segmented image size can cause border information loss and by 
% consequence algorithm failure. 
%--------------------------------------------------------------------------

% if heightO ~= heightN || widthO ~= widthN
%     heightScale = max(heightO,heightN)/min (heightO,heightN);
%     var = 1/heightScale;
%     ScaledSegmented = imresize(Segmented, var);
%     imshow (ScaledSegmented);
%     I = rgb2gray(ScaledSegmented);
%     Segmented = I;
%     Threshold = adaptthresh(Segmented, 0.4);
%     Binarizada = imbinarize(Segmented,Threshold);
%     ImagemComplemento = imcomplement (Binarizada);
% else
   ImagemComplemento = imcomplement (Segmented);
% end

% Transform image to a white background with black lines for bwlabel
% imshow(ImagemComplemento);

% Label the segmented image complement
LabelMap = bwlabel(ImagemComplemento);

%--------------------------------------------------------------------
s = regionprops(LabelMap, 'Centroid');
%imshow(ImagemComplemento)
% Show image labels only for visual porpose
hold on
for k = 1:numel(s)
    c = s(k).Centroid;
    text(c(1), c(2), sprintf('%d', k), ...
        'HorizontalAlignment', 'center', ...
        'VerticalAlignment', 'middle');
end
hold off
%-------------------------------------------------------------------
LabelMap1 = LabelMap;

se = strel('square',4);
% Label image map 
BW2 = imdilate(LabelMap1,se); 



%-----------------------------------------------------------------------
% Find inpainting mask pixels and map the label in the segmented image
%-----------------------------------------------------------------------

% r1 and c1 values can be changed acording to mask size (e.g. small masks
% may not have the 9th array position to check);
% Define the label that references the mask
LabelInpaint = BW2(r1(9),c1(9)); 

%-----------------------------------------------------------------------
% Find inpainting mask first neighbors
%-----------------------------------------------------------------------

% Label of the inpainting mask
label = LabelInpaint;  
 
object = BW2 == label;
% 8-connectivity for neighbours
se = ones(3);   
neighbours = imdilate(object, se) & ~object;
neighbourLabels = unique(BW2(neighbours));

disp(neighbourLabels);



%-----------------------------------------------------------------------
% Comment section if mask adjascency region only equals to 1
%-----------------------------------------------------------------------
nbToLabels = [];

% Modify to have a greater adjacent region list (1:2, 1:3,...)
for li = 1:adjacency
    for linhas = 1:size(neighbourLabels)
        % Does the same thing as find neighbors method
        nb = ngb2ngb (BW2, neighbourLabels(linhas,1));
        % Adds new regions to list
        nbToLabels = cat (1, nbToLabels, nb );  
    end
     % Adds first neighbours to list 
    nbToLabels = cat (1, nbToLabels, neighbourLabels );
    neighbourLabels = unique (nbToLabels);
end
disp(neighbourLabels);



%-----------------------------------------------------------------------
% Create new search region for the inpainting algorithms
%-----------------------------------------------------------------------
pos = 1;
searchRegion = [];
rows = size(BW2,1);
columns = size(BW2,2);

% Gathers all pixels from all neighbour regions in neighbourLabels in BW2 and 
% creates the new search region (searchRegion) for the algorithm's search
for j = 1:rows
    for s = 1:columns
        if ismember(BW2(j,s), neighbourLabels) && BW2(j,s) ~= 0
             pxl = j*s;
             searchRegion(pos,1) = pxl;
             pos = pos+1;
        end
    end
end

%disp(size(neighbourLabels));
