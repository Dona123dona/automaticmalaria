clear all;
close all
clc
load('normdata.mat');
load('maldata.mat');
[filename,pathname]=uigetfile('*jpg');
I=imread([pathname,filename]);
figure,imshow(I);

red=I(:,:,1);red=imadjust(red);figure,imshow(red);
green=I(:,:,1);green=imadjust(green);figure,imshow(green);
blue=I(:,:,1);blue=imadjust(blue);figure,imshow(blue);
I=blue;
figure,imshow(I);
Iblur = imgaussfilt(I, 0.5); %smoothing image,default 0.5 can increase and decrease.gaussfilter function
figure,imshow(Iblur);
level=graythresh(I)
Ibin=imbinarize(I,norm(level/3)); %binarizing the image
figure,imshow(Ibin);
se1 = strel('disk',3,0) % it can  be other shapes too.
