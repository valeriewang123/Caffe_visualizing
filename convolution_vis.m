function varargout = convolution_vis(varargin)
% CONVOLUTION_VIS MATLAB code for convolution_vis.fig
%      CONVOLUTION_VIS, by itself, creates a new CONVOLUTION_VIS or raises the existing
%      singleton*.
%
%      H = CONVOLUTION_VIS returns the handle to a new CONVOLUTION_VIS or the handle to
%      the existing singleton*.
%
%      CONVOLUTION_VIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONVOLUTION_VIS.M with the given input arguments.
%
%      CONVOLUTION_VIS('Property','Value',...) creates a new CONVOLUTION_VIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before convolution_vis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to convolution_vis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help convolution_vis

% Last Modified by GUIDE v2.5 20-May-2017 09:14:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @convolution_vis_OpeningFcn, ...
                   'gui_OutputFcn',  @convolution_vis_OutputFcn, ...
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


% --- Executes just before convolution_vis is made visible.
function convolution_vis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to convolution_vis (see VARARGIN)
global g_modelRootPath;
%global num = 0;


handles.lastFileDirectory = g_modelRootPath;

% Choose default command line output for convolution_vis
handles.output = hObject;
% Set Caffe mode (no GPU needed for this program)
caffe.set_mode_cpu();
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes convolution_vis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = convolution_vis_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function Map=visualize_feature_maps(net,blob_name,space)


blob=net.blobs(blob_name).get_data();
blob_width=max(size(blob,1),size(blob,2));
ceil_width=blob_width+space;
channels=size(blob,3);
    if(channels>64)
        channels = 64;
    end
    ceil_num=ceil(sqrt(channels));
    Map=zeros(ceil_width*ceil_num,ceil_width*ceil_num);
    for u=1:ceil_num
        for v=1:ceil_num
            w=zeros(blob_width,blob_width);
            if (((u-1)*ceil_num+v)<=channels)
                w=blob(:,:,(u-1)*ceil_num+v,1)';
                w=w-min(min(w));
                w=w/max(max(w))*255;
            end
            Map(ceil_width*(u-1)+(1:blob_width),ceil_width*(v-1)+(1:blob_width))=w;
        end
    end     
Map=uint8(Map);


% figure();
%set(handles.axe2,'Units','pixels');
%handles = guihandles();
%cla(handles.axe2,'reset');
%set(handles.axe2,'NewxPlot','new')
%axes('position',[0.25,0.08,0.7,0.6],'tag','axe2','box','on','NextPlot','new','XGrid','on','ZGrid','on');
%obj=findobj('tag','axe2');
%axes(obj);


function Map=visualize_part_feature_maps(net,blob_name,crop_num,space)


blob=net.blobs(blob_name).get_data();
%axe = length(net.blobs(blob_name).shape());
blob_width=max(size(blob,1),size(blob,2));
ceil_width=blob_width+space;

%Map=zeros(ceil_width,ceil_width);
%w=zeros(blob_width,blob_width);
w=blob(:,:,crop_num,1)';
w=w-min(min(w));
w=w/max(max(w))*255;
%(ceil_width,ceil_width)
Map=w;
 
Map=uint8(Map);



% --- Executes on selection change in layerListBox.
function layerListBox_Callback(hObject, eventdata, handles)
% hObject    handle to layerListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns layerListBox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from layerListBox
% Set layer name
%global num;
global net;
global im;
global blob_name;
handles.output = hObject;
handles.layerName = hObject.String{hObject.Value};
% Get layer weights

input_data={prepare_image(im)};
%while(handles && num~=0)
    
scores=net.forward(input_data);
blob_name=handles.layerName;
%disp(scores)
disp(blob_name)

blob=net.blobs(blob_name).get_data();
axe = length(net.blobs(blob_name).shape());
fprintf('axe = %d\n',axe)
disp(net.blobs(blob_name).shape())
if(axe==4)
    Map=visualize_feature_maps(net,blob_name,1);
    set(handles.axe2,'HandleVisibility','ON');
    axes(handles.axe2);
    imshow(Map);
    colormap(jet);caxis([0 255]);
    colorbar;
    title(blob_name);
    set(handles.axe2, 'Visible', 'Off');
else
    axes(handles.axe2);
    bar(blob(:,:,1,1),0.8);
    colorbar;
    title(blob_name);
    
%axes('position',[0.25,0.08,0.7,0.6],'tag','axe2','box','on','NextPlot','new','XGrid','on','ZGrid','on');



guidata(hObject,handles);
end






% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%global size_flag;
[basename, dirname, ~] = uigetfile({'*.prototxt', 'Deployment model files (*.prototxt)'}, 'Model file', handles.lastFileDirectory);
if basename ~= 0
    % Update last file directory
    handles.lastFileDirectory = dirname;
    %size_flag=strcmp('/home/ic619/wxy/caffe-master/matlab_Visualization/VGG16/',dirname)
  
    % Set and display model path
    handles.modelFilePath = fullfile(dirname, basename);
    if(length(handles.modelFilePath) > 100)
        set(handles.modelFileLabel, 'String', handles.modelFilePath(length(handles.modelFilePath) - 99:end));
    else
        set(handles.modelFileLabel, 'String', handles.modelFilePath);
    end
    % Enable weight path button
    set(handles.pushbutton2, 'Enable', 'on');
else
    % Disable weight path button
    set(handles.pushbutton2, 'Enable', 'off');
    % Reset model path
    handles.modelFilePath = '';
    set(handles.modelFileLabel, 'String', 'None');
end
% Reset weight path
handles.modelWeightsPath = '';
set(handles.modelWeightsLabel, 'String', 'None');
% Reset layer name list
set(handles.layerListBox, 'String', {});
% Show instructions panel
% set(handles.instructionsPanel, 'Visible', 'On');
% Commit handle data
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[basename, dirname, ~] = uigetfile({'*.caffemodel', 'Weight files (*.caffemodel)'}, 'Weight file', handles.lastFileDirectory);
if basename ~= 0
    % Update last file directory
    handles.lastFileDirectory = dirname;
    
    
    % Set and display weight path
    handles.modelWeightsPath = fullfile(dirname, basename);
    if(length(handles.modelWeightsPath) > 100)
        set(handles.modelWeightsLabel, 'String', handles.modelWeightsPath(length(handles.modelWeightsPath) - 99:end));
    else
        set(handles.modelWeightsLabel, 'String', handles.modelWeightsPath);
    set(handles.pushbutton3, 'Enable', 'on');
    end
    % Show loading panel and render immediately
else
    % Disable Load Picture button
    set(handles.pushbutton3, 'Enable', 'off');
    % Reset weight path
    handles.modelWeightPath = '';
    set(handles.modelWeightLabel, 'String', 'None'); 
end    
drawnow;
    
% Get and store network weights
[orderedLayerNames] = createCaffeNet(handles.modelFilePath, handles.modelWeightsPath);
%set(handles.axe2, 'Visible', 'On');
% Update layer name list
set(handles.layerListBox, 'String', orderedLayerNames);


guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global im
[filename,pathname]=uigetfile({'*.*';'*.bmp';'*.jpg';'*.tif';'*.jpg'},'choose picture');
if isequal(filename,0)||isequal(pathname,0)
  errordlg('You have not choose picture','attention please');
  return;
else
    
    image =[pathname,filename];
    im = imread(image);
    set(handles.axe1,'HandleVisibility','ON');
    axes(handles.axe1);
    imshow(im);
    title('Test Picture');
end


    

% --- Executes when layerListBox is resized.
function layerListBox_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to layerListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function layerListBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to layerListBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function [orderedLayerNames] = createCaffeNet(modelFilePath, weightsFilePath)
disp(['Model file: ' modelFilePath]);
disp(['Model weights: ' weightsFilePath]);
% Clear previous nets
caffe.reset_all();
% Set handle to the net
global net;
net = caffe.Net(modelFilePath, weightsFilePath, 'test');

% Get layer information (names and weights)
layerNames = net.blob_names;

% Maintain order of layer names
orderedLayerNames = {};
for i=1:length(layerNames)
    layerName = layerNames{i};
    try
        
        orderedLayerNames{end+1} = layerName;
    catch
        warning('Could not load weights for %s', layerName);
    end
end
disp('Done loading net');


function crops_data = prepare_image(im)
% ------------------------------------------------------------------------
% caffe/matlab/+caffe/imagenet/ilsvrc_2012_mean.mat contains mean_data that
% is already in W x H x C with BGR channels
%global size_flag;
d = load('/home/ic619/wxy/caffe-master/matlab/+caffe/imagenet/ilsvrc_2012_mean.mat');
mean_data = d.mean_data;
IMAGE_DIM = 256;

CROPPED_DIM = 227;% alexnet=227, VGG16= 224

% Convert an image returned by Matlab's imread to im_data in caffe's data
% format: W x H x C with BGR channels
im_data = im(:, :, [3, 2, 1]);  % permute channels from RGB to BGR
im_data = permute(im_data, [2, 1, 3]);  % flip width and height
im_data = single(im_data);  % convert from uint8 to single
im_data = imresize(im_data, [IMAGE_DIM IMAGE_DIM], 'bilinear');  % resize im_data
im_data = im_data - mean_data;  % subtract mean_data (already in W x H x C, BGR)

% oversample (4 corners, center, and their x-axis
% flips)\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
crops_data = zeros(CROPPED_DIM, CROPPED_DIM, 3, 10, 'single');
indices = [0 IMAGE_DIM-CROPPED_DIM] + 1;
n = 1;
for i = indices
  for j = indices
    crops_data(:, :, :, n) = im_data(i:i+CROPPED_DIM-1, j:j+CROPPED_DIM-1, :);
    crops_data(:, :, :, n+5) = crops_data(end:-1:1, :, :, n);
    n = n + 1;
  end
end
center = floor(indices(2) / 2) + 1;
crops_data(:,:,:,5) = ...
  im_data(center:center+CROPPED_DIM-1,center:center+CROPPED_DIM-1,:);
crops_data(:,:,:,10) = crops_data(end:-1:1, :, :, 5);


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    global net;
    global im;
    input_data={prepare_image(im)};
    scores=net.forward(input_data);
    labels_file = ('/home/ic619/wxy/caffe-master/data/ilsvrc12/synset_words.txt');
    labels = importdata(labels_file)
    
    
    output_prob=net.blobs('prob').get_data();
    
   [C,I]=(sort(output_prob(:,1),'descend'))
   disp('Result is:')
   for index=1:1:5
       disp(C(index));
       disp(labels(I(index)));
       labels_name(index) = labels(I(index));
       labels_data(index) = C(index);
   end
   
   %disp(labels_name) 
   axes(handles.axes7);
   barh(labels_data) 
   set(gca,'yticklabel',{I(1),I(2),I(3),I(4),I(5)});
  
   %image=('/home/ic619/wxy/documents/output.png')
   %im = imread(image);
    title('Classification result');

    % --- Executes on button press in pushbutton8.
%function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   
     
 
      



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
crop_num = str2num(get(hObject,'String'));
global net;
global im;
global blob_name;
blob=net.blobs(blob_name).get_data();
%handles.output = hObject;
%handles.layerName = hObject.String{hObject.Value};
% Get layer weights
input_data={prepare_image(im)};
%while(handles && num~=0)
error = size(blob,3) 
disp(error)
if(crop_num> error)||(crop_num<0)
  errordlg('Input Error! Number should be smaller than channel!','attention please');
  return;
else    
scores=net.forward(input_data);
%blob_name=handles.layerName;
%disp(scores)
%disp(blob_name)


Map=visualize_part_feature_maps(net,blob_name,crop_num,1);
set(handles.axes8,'HandleVisibility','ON');
axes(handles.axes8);
imshow(Map);
colormap(jet);caxis([0 255]);
%title(blob_name);
%axes('position',[0.25,0.08,0.7,0.6],'tag','axe2','box','on','NextPlot','new','XGrid','on','ZGrid','on');

set(handles.axe2, 'Visible', 'Off');

guidata(hObject,handles);
end



% Hints: get(hObject,'String') returns contents of edit5 as text
%        str2double(get(hObject,'String')) returns contents of edit5 as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
