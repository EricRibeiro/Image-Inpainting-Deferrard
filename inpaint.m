function [ sol ] = inpaint( imname, cut, extinction, adjacency, psize )
%INPAINT Retrieve the missing pixels of an image.
%   Usage :
%       vertices = giin_image('vertical'); 
%       inpaint('vertical');
%
%   Input parameters :
%       imname    : name of the image file
%       cut       : parameter used in watershed
%       extinction: 'areas', 'dynamics', 'volumes' or 'superpixels'
%       adjacency : adjancency used in neighborhood functions 
%       psize     : patch size
%
%   Output parameters :
%       sol    : the inpainted image
%
% The goal of this script is to inpaint the missing pixels of an image. It
% does so by constructing a patch graph of the known pixels. According to
% some priority, it then iteratively connect unknown patches to the graph.
% A global optimization is run in the end.

% Author: Michael Defferrard
% Date: February 2015

gsp_start();

%% Image loading

img = double(imread([imname,'.png'])) / 255;

img1 = img;
sgm = imread([imname,'_', cut, '_', extinction, '.png']);

Nx = size(img,1);
Ny = size(img,2);
Nc = size(img,3);

% Extract the mask.
if Nc == 1
    mask = img == 1;
else
    mask = img(:,:,1)==0 & img(:,:,2)==1 & img(:,:,3)==0;
    mask = repmat(mask, [1,1,3]);
end

% Unknown pixels are negative (known ones are in [0,1]). Negative enough
% such that they don't connect to anything else than other unknown patches.
unknown = -1e3;
img(mask) = unknown;

%% Inpainting algorithm
gparam = giin_default_parameters(psize);

% Check if there's a file with the graph to make execution faster 
varfile = ['var/', imname, '_p', num2str(psize), '.mat'];

if (exist(varfile) == 2)
    disp("Patch graph file founded, loading...");
    load(varfile);
else
    disp("Patch graph file doesn't exist, creating...")
    [G, pixels, patches] = giin_patch_graph(img, gparam, false);
    save(['var/', imname '_p', num2str(psize)], 'G', 'pixels', 'patches');
end

[r1, c1] = maskhelper(img1);
nbh = neighborhood(img, sgm, r1, c1, adjacency);
[G, pixels, Pstructure, Pinformation] = giin_inpaint(G, pixels, patches, gparam, false, nbh);

% Global optimization.
sol = zeros(size(pixels));
G = gsp_estimate_lmax(G);
for ii = 1:Nc
    sol(:,ii) = giin_global(G, img(:,:,ii), reshape(pixels(:,ii),Nx,Ny), gparam);
end

%% Results saving

% Uncomment the line below to save entire workspace after processing.
% save(['var/', imname, '_', cut, '_', extinction, '_', num2str(adjacency), '_inpainted']);

filename = ['/home/ericribeiro/Documents/MATLAB/Deferrard/results/', imname, '_', cut, '_', extinction, '_', num2str(adjacency), '_p', num2str(psize)];

imwrite(reshape(sol,size(img)), ...
    [filename, '_inpainted.png'], 'png');

%% Visualization

% load([filename,'.mat']);
% giin_plot_signal(G, pixels(:,1), false);
% giin_plot_priorities(vertices, G, gparam, filename);