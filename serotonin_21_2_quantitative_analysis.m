%The goal of this analysis is to investigate possbile quantitative measures
%of collagen content.
%Project: IBD-serotonin (onedrive)
%Experiment:serotonin-21-2 (onedrive)
%Samples: rat intestines from Atle van Belen Granlund.
%Data:serotonin-21-2 (aurora)

close all %close all figures

%Place data (.lif file) in  folder .\data
%Load data
if ~(exist('data','var')) %load data unless already loaded
    data = bfopen('.\data\serotonin-21-2.lif');
end
%data is an nx4 cell array of n rows of images where the image data are stored in
%the first position of the second argument. The other columns are metadata.

%Choose image
n = 8;
img = data{n,1};

%Select individual channels
dapi = img{1,1};
shg = img{2,1};
af = img{3,1};

image(shg,'CDataMapping','scaled')

%Otsus thresholding method
figure
level = graythresh(shg);
shg_bw = imbinarize(shg,level);
figure
imshowpair(shg_bw,shg,'montage')

%Multilevel Otsus
figure
levels = multithresh(shg,2);
shg_seg = imquantize(shg,levels);
shg_seg_rgb = label2rgb(shg_seg);
imshowpair(shg_seg_rgb,shg,'montage')

%Adaptive threshold
figure
adaptive_threshold = adaptthresh(shg);
shg_adapt = imbinarize(shg,adaptive_threshold); %Only when features throughout image
imshowpair(shg_adapt,shg,'montage')

%Crop for ROI
figure
shg_rot = imrotate(shg,12,'bilinear','loose');
height = 200;
width = 200;
shg_rot_crop = imcrop(shg_rot, [98 434-height width height]); %height set to 200
image(shg_rot_crop,'CDataMapping','scaled')
