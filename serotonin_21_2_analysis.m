%This files processes data from experiment serotonin-21-2 for
%visualization.
%%%
%Data on aurora: serotonin-21-2
%Experiment notes on github 
%https://github.com/NLOM-NTNU-PI/labbook/blob/fceed934a88b045be3612a74409b89a18d587cda/IBD-serotonin
%%%

%Place data (.lif file) in  folder .\data
%Load data
if ~(exist('data','var')) %load data unless already loaded
    data = bfopen('.\data\serotonin-21-2.lif');
end
%data is an nx4 cell array of n images where the image data are stored in
%the first position of the second argument. The other rows are metadata.

%Pick out a particular image
%n = {1,2} are test images with less than 3 channels.
n = 5; %image number in series
img = data{n,1}; 
display(img{1,2}) %show image project information

%Project naming information in imag{x,2}
%Select individual channels
dapi = img{1,1};
shg = img{2,1};
af = img{3,1};
%Process images
    %DAPI
    Pdapi = medfilt2(dapi); %median filter %other options: gaussian, wiener..
    Pdapi(Pdapi<4000) = 0; %threshold to remove autofluorescence leakage

    %SHG
    Pshg = medfilt2(shg);
    Pshg(Pshg<2000) = 0; %threshold to remove autofluorescence leakage
    %Pshg(Pdapi~=0) = 0; %threshold where cell nuclei is present
    
    %AF
    Paf = medfilt2(af);
    Paf(Paf<400) = 0;
    %imshowpair(af,Paf,'montage')

    %Adjust intensity levels
    Pdapi = imadjust(Pdapi);
    Pshg = imadjust(Pshg);
        Paf_high =  double(max(Paf(:)))/65536;
    Paf = imadjust(Paf,[0,Paf_high],[0,.3]);
    
%Create rgb image
%r = uint8(zeros(512,512));
r = Paf;
g = Pshg;
b = Pdapi;
rgb = cat(3,r,g,b);
imwrite(rgb, './results/img.png')
%image(rgb)