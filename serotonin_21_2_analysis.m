if ~(exist('data','var')) %load data unless already loaded
    data = bfopen('.\data\serotonin-21-2.lif');
end

n = 5; %image number in series
img = data{n,1};

r = uint8(zeros(512,512));
r = img{3,1};
g = img{2,1};
b = img{1,1};

r = imadjust(r,[0.005,0.01],[0,.3]);
b = imadjust(b);

rgb = cat(3,r,g,b);
image(rgb)