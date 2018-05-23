function varargout = FinalGUI(varargin)
% FINALGUI MATLAB code for FinalGUI.fig
%      FINALGUI, by itself, creates a new FINALGUI or raises the existing
%      singleton*.
%
%      H = FINALGUI returns the handle to a new FINALGUI or the handle to
%      the existing singleton*.
%
%      FINALGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINALGUI.M with the given input arguments.
%
%      FINALGUI('Property','Value',...) creates a new FINALGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FinalGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FinalGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FinalGUI

% Last Modified by GUIDE v2.5 13-Nov-2017 16:30:31

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FinalGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FinalGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FinalGUI is made visible.
function FinalGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FinalGUI (see VARARGIN)

% Choose default command line output for FinalGUI
handles.output = hObject;
a='The input image belongs to the following category:';
set(handles.text2,'String',a);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FinalGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FinalGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i im 
[path,user_cance]=imgetfile();
if user_cance  %if user cancels and does not select an image
    msgbox(sprintf('error'),'Error','Error');   
    return;
end;
im=imread(path);
i=imread(path);
im=im2double(im);

axes(handles.axes1);
imshow(im);

[rows columns numberOfColorBands] = size(i);
%set(gcf, 'Position', get(0,'Screensize'));    %if we want to set full
%screen image and GUI
redChannel = i(:, :, 1);
greenChannel = i(:, :, 2);
blueChannel = i(:, :, 3);
redMF = medfilt2(redChannel, [3 3]);   %performing median filtering
greenMF = medfilt2(greenChannel, [3 3]);
blueMF = medfilt2(blueChannel, [3 3]);

noiseImage = (redChannel == 0 | redChannel == 255);
% Get rid of the noise in the red by replacing with median.
noiseFreeRed = redChannel;
noiseFreeRed(noiseImage) = redMF(noiseImage);

noiseImage = (greenChannel == 0 | greenChannel == 255);
% Get rid of the noise in the green by replacing with median.
noiseFreeGreen = greenChannel;
noiseFreeGreen(noiseImage) = greenMF(noiseImage);

noiseImage = (blueChannel == 0 | blueChannel == 255);
% Get rid of the noise in the blue by replacing with median.
noiseFreeBlue = blueChannel;
noiseFreeBlue(noiseImage) = blueMF(noiseImage);

rgbFixed = cat(3, noiseFreeRed, noiseFreeGreen, noiseFreeBlue);

k=rgb2gray(rgbFixed);

I=k(:,:,1); %means all rows and all columns in the first image plane - in other words, the red channel of the image.

faceDetect = vision.CascadeObjectDetector(); %The cascade object detector uses the Viola-Jones algorithm to detect people’s features

bbox=step(faceDetect,I); %bounding box for face

face=imcrop(I,bbox);  %cropping the fave out of bounding box

centerx=size(face,1)/2+bbox(1);  %shifting of coordinates

centery=size(face,2)/2+bbox(2);

eyeDetect = vision.CascadeObjectDetector('RightEye');  %object for detection of eye

eyebox=step(eyeDetect,face);

n=size(eyebox,1);
%disp('test');
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

eyeCenter1x=eyebox(1,1)+c+bbox(1); %first eye box rows

eyeCenter1y=eyebox(1,2)+d+bbox(2);

e=eyebox(2,3)/2;

f=eyebox(2,4)/2;

eyeCenter2x=eyebox(2,1)+e+bbox(1);  %second eyebox rows

eyeCenter2y=eyebox(2,2)+f+bbox(2);

ndetect=vision.CascadeObjectDetector('Nose','MergeThreshold',16);  
% for MergeThreshold :  This value defines the criteria needed to declare a final detection in an area where there are multiple detections around an object. Groups of colocated detections that meet the threshold are merged to produce one bounding box around the target object
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

 

mouthCenterx=mouthbox(1,1)+(mouthbox(1,3)/2)+bbox(1);

mouthCentery=mouthbox(1,2)+(mouthbox(1,4)/2)+bbox(2);

shape=[centerx centery;eyeCenter1x eyeCenter1y;eyeCenter2x eyeCenter2y;noseCenterx noseCentery;mouthCenterx mouthCentery];

 

 

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

 

%disp(ratio_multiply);

 

i2 = imcrop(k,[noseCenterx+30 eyeCenter2y+15 90 70]);

%imshow(i2);

BW1 = edge(i2,'Canny',0.05); 

%figure;

%imshow(BW1);

edgePixels = nnz(BW1);

%disp(edgePixels)

 

Xtest = [ratio_multiply edgePixels];

X=[0.883300000000000,1237;1.05650000000000,632;0.992500000000000,1074;1.02450000000000,1070;0.812200000000000,1172;1.22080000000000,743;0.898400000000000,1084;1.25320000000000,919;0.884500000000000,1226;1.02430000000000,1399;0.862600000000000,591;0.972200000000000,823;0.901500000000000,379;0.980300000000000,850;0.816600000000000,1184;1.00750000000000,1083;1.03880000000000,1291;0.817600000000000,752;0.951500000000000,1049;0.763700000000000,1229;0.740700000000000,1272;0.574300000000000,1345;0.764800000000000,1080;0.855600000000000,1238;0.717200000000000,1178;0.672700000000000,1312;0.692100000000000,1318;0.936900000000000,1258;0.428600000000000,1114;0.706400000000000,1148;0.725000000000000,1290;0.737700000000000,1258;0.792400000000000,1403;0.648100000000000,1503;0.739900000000000,1332;0.846200000000000,1117;0.749500000000000,1123;0.888100000000000,1304];
Y=[0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;0;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1;1];

SVMModel=fitcsvm(X,Y);


label = predict(SVMModel,Xtest);
if label==0
    b='Minor';
    set(handles.edit1,'String',b);
    X = inputdlg('PLEASE ENTER THE PASSWORD TO PROCEED');
    x = str2double(X{1,1});
    password = 123;             % SET IT HERE MANUALLY
       if (x == password)
          uiwait(msgbox('Password Correct !!'));
          url = 'http://www.youtube.com';
          web(url)
       else 
           while (x ~= 123)
                if (x == password)
                     uiwait(msgbox('Password Correct !!'));
                      
                     break;
                else
                     uiwait(errordlg('Incorrect Password !!'));
                     X = inputdlg('PLEASE ENTER THE PASSWORD TO PROCEED');
                     x = str2double(X{1,1});
                end 
           end
 uiwait(msgbox('Password Correct !!'));
 url = 'http://www.youtube.com';
 web(url)
       end

else
    c='Adult';
  set(handles.edit1,'String',c);
  url = 'http://www.youtube.com';
  web(url)
end;

disp(label);




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
