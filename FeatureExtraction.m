close all;
r = dir('/Users/adityarai/Documents/MATLAB/kids/*.jpg');

for i = 1 : length(r)
 filename = strcat('/Users/adityarai/Documents/MATLAB/kids/',r(i).name);



        k=imread(filename); 
%k =imread('C:\Users\hp\Desktop\Vth Sem\Project Related Stuff\Faces\img_o161.jpg'); %image to be 
%z = imfinfo('C:\Users\hp\Desktop\Vth Sem\Project Related Stuff\Faces\im38.jpg');
%z = imcrop(k);
%figure;
%h = imshow(k);
%imageinfo(h,z);
%imshow(z);
%k = imresize(aa,[450 300]);
I=k(:,:,1);
faceDetect = vision.CascadeObjectDetector();
bbox=step(faceDetect,I);
face=imcrop(I,bbox);
centerx=size(face,1)/2+bbox(1);
centery=size(face,2)/2+bbox(2);
eyeDetect = vision.CascadeObjectDetector('RightEye');
eyebox=step(eyeDetect,face);
n=size(eyebox,1);
e=[];
d = 0;
for it=1:n
    for j=1:n
        if (j > it)
          if ((abs(eyebox(j,2)-eyebox(it,2))<68)&& (abs(eyebox(j,1)-eyebox(it,1))>40))
            e(1,:)=eyebox(it,:);
            e(2,:)=eyebox(j,:);
            d=1;break;
          end
        end
    end
    if(d == 1)
        break;
    end
end
eyebox(1,:)=e(1,:);
eyebox(2,:)=e(2,:);
c=eyebox(1,3)/2;
d=eyebox(1,4)/2;
eyeCenter1x=eyebox(1,1)+c+bbox(1);
eyeCenter1y=eyebox(1,2)+d+bbox(2);
e=eyebox(2,3)/2;
f=eyebox(2,4)/2;
eyeCenter2x=eyebox(2,1)+e+bbox(1);
eyeCenter2y=eyebox(2,2)+f+bbox(2);
ndetect=vision.CascadeObjectDetector('Nose','MergeThreshold',16);
nosebox=step(ndetect,face);
noseCenterx=nosebox(1,1)+(nosebox(1,3)/2)+bbox(1);
noseCentery=nosebox(1,2)+(nosebox(1,4)/2);
m=[1,noseCentery,size(face,1),((size(face,2))-noseCentery)];
mouth=imcrop(face,m);

mdetect=vision.CascadeObjectDetector('Mouth','MergeThreshold' ,20);
mouthbox=step(mdetect,mouth);
for it=1:size(mouthbox,1)
    if(mouthbox(it,2)>20)
        mouthbox(1,:)=mouthbox(it,:);
        break;
    end
end
mouthbox(1,2)=mouthbox(1,2)+noseCentery;
noseCentery=noseCentery+bbox(2);
%ind=find(mb(:,1)==max(mb(:,1)));
%mb=mb(ind,:);
mouthCenterx=mouthbox(1,1)+(mouthbox(1,3)/2)+bbox(1);
mouthCentery=mouthbox(1,2)+(mouthbox(1,4)/2)+bbox(2);
shape=[centerx centery;eyeCenter1x eyeCenter1y;eyeCenter2x eyeCenter2y;noseCenterx noseCentery;mouthCenterx mouthCentery];
%imshow(I);hold on;plot(shape(:,1),shape(:,2),'+','MarkerSize',10);
%To get the bound boxes as shown in the figure uncomment the below code and 
%comment the imshow(I);hold on;plot(shape(:,1),shape(:,2),'+',... line
% eyebox(1,1:2)=eyebox(1,1:2)+bbox(1,1:2);
% eyebox(2,1:2)=eyebox(2,1:2)+bbox(1,1:2);
% nosebox(1,1:2)=nosebox(1,1:2)+bbox(1,1:2);
% mouthbox(1,1:2)=mouthbox(1,1:2)+bbox(1,1:2);
% all_points=[eyebox(1,:);eyebox(2,:);nosebox(1,:);mouthbox(1,:)];
% dpoints=size(all_points,1);
% label=cell(dpoints,1);
% i=1;
% for i = 1: dpoints
% label{i}=[num2str(i)];
% i=i+1;
% end
% videoout=insertObjectAnnotation(I,'rectangle',all_points,label,'TextBoxOpacity',0.3,'Fontsize',9);
% imshow(videoout);hold on;plot(shape(:,1),shape(:,2),'+','MarkerSize',10);
%To get triangles uncomment the below code
%dt=DelaunayTri(shape(:,1),shape(:,2));
%imshow(videoout);hold on;triplot(dt);hold off

X1 = [0,eyeCenter1y;0,mouthCentery];
Y1 = [0,eyeCenter1y;0,noseCentery];
X2 = [0,eyeCenter1y;0,mouthCentery];
Y2 = [eyeCenter1x,eyeCenter1y;eyeCenter2x,eyeCenter2y];
X3 = [0,eyeCenter1y;0,noseCentery];
Y3 = [eyeCenter1x,eyeCenter1y;eyeCenter2x,eyeCenter2y];
d1 = pdist(X1,'euclidean');
d2 = pdist(Y1,'euclidean');
d3 = pdist(X2,'euclidean');
d4 = pdist(Y2,'euclidean');
d5 = pdist(X3,'euclidean');
d6 = pdist(Y3,'euclidean');
divide1 = d2/d1;
divide2 = d4/d3;
divide3 = d6/d5;
ratio_multiply = divide1*divide2*divide3 ;
disp(divide1);
disp(divide2);
disp(divide3);
disp(ratio_multiply);
%figure;
%imshow(z);
%I2 = imcrop(k,[noseCenterx+30 eyeCenter2y+15 90 70]);
%figure;
%imshow(I2);
%h = imrect(gca, [50 50 50 50]);
%message = sprintf('Drag, set position of the rectangle cropping box and double click on the rectangle box');
%uiwait(msgbox(message));
%position = wait(h); % get position
%I_crop = imcrop(k,position); % crop image
%imshow(I_crop)
%message = sprintf('Image has been croped');
%msgbox(message);
i2 = imcrop(k,[noseCenterx+30 eyeCenter2y+15 90 70]);
imshow(i2);
BW1 = edge(i2,'Canny',0.05); 
figure;
%imshow(BW1);
edgePixels = nnz(BW1);
disp(edgePixels)  %     this is the wrinkle analysis result    %


figure;
imshow(I3);


end
