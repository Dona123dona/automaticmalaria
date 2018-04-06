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
