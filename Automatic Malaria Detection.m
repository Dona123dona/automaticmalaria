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
cc = bwconncomp(Ibin)
labeled = labelmatrix(cc);
figure,imshow(labeled,[]);

RGB_label = label2rgb(labeled);
imshow(RGB_label);
glcmin = graycomatrix(I,'Offset',[2 0;0 2]);
pairs=0;
close all;
format long e
if (pairs == 1)
    newn = 1;
    for nglcm = 1:2:size(glcmin,3)
        glcm(:,:,newn)  = glcmin(:,:,nglcm) + glcmin(:,:,nglcm+1);
        newn = newn + 1;
    end
elseif (pairs == 0)
    glcm = glcmin;
end

size_glcm_1 = size(glcm,1);
size_glcm_2 = size(glcm,2);
size_glcm_3 = size(glcm,3);

homop = zeros(1,size_glcm_3); % Homogeneity
dissi = zeros(1,size_glcm_3); % Dissimilarity

for k = 1:size_glcm_3 % number glcms
    for i = 1:size_glcm_1

        for j = 1:size_glcm_2

            homop(k) = homop(k) + (glcm(i,j,k)/( 1 + (i - j)^2));
            dissi(k) = dissi(k) + (abs(i - j)*glcm(i,j,k));
        end
        
    end
    maxpr(k) = max(max(glcm(:,:,k)));
end
x1=homop;
x2=dissi;
x=[x1(1);x2(2)]
w1=u;
w2=u1;
 figure
 title('Minimum Distance to Class Mean Classifier');
 hold on
 L1=plot(w1(:,1),w1(:,2),'*','MarkerEdgeColor','b');
 hold on;
 L2=plot(w2(:,1),w2(:,2),'*','MarkerEdgeColor','r');
 xlabel('X1');
 ylabel('X2');

 y1 = [ mean(w1(:,1)) mean(w1(:,2))];
 y2 = [ mean(w2(:,1)) mean(w2(:,2))];

 hold on
 L3=plot(y1(1),y1(2),'+','MarkerEdgeColor','b');
 hold on
 L4=plot(y2(1),y2(2),'+','MarkerEdgeColor','r');

 for n = 1:length(x)
 g1=x(n,:)*y1'-.5*(y1*y1');
 g2=x(n,:)*y2'-.5*(y2*y2');
 end

 minw=min(min(w1(:)),min(w2(:)));
 minall=min(minw,min(x(:)));
 maxw=max(max(w1(:)),max(w2(:)));
 maxall=max(maxw,max(x(:)));
 DBx1 = minall:0.1:maxall;
 coefficient=(y1-y2);
 constant=-0.5*det((y1'*y1-y2'*y2));

 for i=1:length(DBx1)
 DBx2(i,:) = (coefficient(1,1)*DBx1(:,i)+constant)/(-coefficient(1,2));
 end
 %{
 for i=1:length(DBx)
 DBx2(i,1) = (3*DBx1(1,i)+7.0312)/(1.5);
 end
 %}
 data=svmtrain([w1,w2]',['malaria';'malaria';'normal ';'normal ']);
 
 result=svmclassify(data,x);
 msgbox( sprintf('The detected result is : %s', string(result(1,:))));
