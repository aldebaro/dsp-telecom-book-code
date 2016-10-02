function varargout = ak_window4gui(varargin)
% AK_WINDOW4GUI MATLAB code for ak_window4gui.fig
%      AK_WINDOW4GUI, by itself, creates a new AK_WINDOW4GUI or raises the existing
%      singleton*.
%
%      H = AK_WINDOW4GUI returns the handle to a new AK_WINDOW4GUI or the handle to
%      the existing singleton*.
%
%      AK_WINDOW4GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AK_WINDOW4GUI.M with the given input arguments.
%
%      AK_WINDOW4GUI('Property','Value',...) creates a new AK_WINDOW4GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ak_window4gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ak_window4gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ak_window4gui

% Last Modified by GUIDE v2.5 02-Sep-2014 17:02:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ak_window4gui_OpeningFcn, ...
                   'gui_OutputFcn',  @ak_window4gui_OutputFcn, ...
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


% --- Executes just before ak_window4gui is made visible.
function ak_window4gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ak_window4gui (see VARARGIN)

% Choose default command line output for ak_window4gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ak_window4gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ak_window4gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function xlength_Callback(hObject, eventdata, handles)
% hObject    handle to xlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlength as text
%        str2double(get(hObject,'String')) returns contents of xlength as a double


% --- Executes during object creation, after setting all properties.
function xlength_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlength (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xamp_Callback(hObject, eventdata, handles)
% hObject    handle to xamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xamp as text
%        str2double(get(hObject,'String')) returns contents of xamp as a double


% --- Executes during object creation, after setting all properties.
function xamp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xamp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

xamp = get(handles.xamp, 'String');
eval(['A = [' xamp '];']);

xlength = get(handles.xlength, 'String');
eval(['N = [' xlength '];']);

ssinc1 = get(handles.xsinc1, 'Value');
ssinc2 = get(handles.xsinc2, 'Value');
stone1 = get(handles.xtone1, 'Value');
stone2 = get(handles.xtone2, 'Value');
sreference = get(handles.xreference, 'Value');
sdtft = get(handles.xdtft, 'Value');
sfft = get(handles.xfft, 'Value');
speed = get(handles.slider2, 'Value');

axes(handles.axes1)
cla reset
deltaW=2*pi/N; %FFT resolution in rad
fftFrequencyGrid=-pi:deltaW:pi-deltaW; %FFT frequencies in rad
Nlarge=N*10; %use a frequency grid with a multiple of N
w=-pi:2*speed*pi/Nlarge:pi; %grid frequency: better resolution than FFT's grid
%% Create a sinc just for plotting, from -8*pi to 8*pi
wsinc=-8*pi:2*pi/Nlarge:8*pi-(2*pi/Nlarge); %frequency for sinc plots
if 0 %window is centered, with non-zero values from n=-M to M
    M=4; %total number of non-zero samples is 2*M+1
    mySinc = (A/2)*sin(((2*M+1)/2)*wsinc)./sin(wsinc/2);
else %window is not centered, with non-zero values from n=0 to N-1
    mySinc = (A/2)*sin((N/2)*wsinc)./sin(wsinc/2) .* ...
        exp(-j*((N-1)/2)*wsinc); %need to add linear phase component
end
if 0 %enable in case you want to see the sinc that will be used
    subplot(211); plot(wsinc/pi,abs(mySinc)), axis tight,
    title('Mag and phase of sinc');
    subplot(212); plot(wsinc/pi,angle(mySinc)), axis tight, pause
end

%% Show the result for a cosine with frequency wc
for k=1:length(w)  %loop over all frequencies in chosen grid
    cla, hold on; %clear figure and hold plots
    axes(handles.axes1)
    wc=w(k); %pick the cosine frequency
    %show the two sincs after convolving with the 2 impulses of the cosine
    %Use a trick and just shift the abscissa
    if ssinc1 == 1 
        plot((wsinc-wc)/pi,abs(mySinc),'b','DisplayName', 'Sinc 1'); %sinc at the right - sinc 1
    end
    if ssinc2 == 1
        plot((wsinc+wc)/pi,abs(mySinc),'y','DisplayName', 'Sinc 2'); %sinc at the left - sinc 2
    end
    if wc==-pi || wc==pi || wc==0 %in these cases FFT shows just one tone
        if stone1 == 1
            stem(wc/pi,A*N,'b','DisplayName', 'Tone 1'); %one tone with amplitude A*N - tone 1 
        end
        if stone2 == 1
            stem(wc/pi,A*N,'y','DisplayName', 'Tone 2'); %repeat it just to have the legend all right - tone 2
        end
        if sreference == 1
        plot([-1,1],[1 1]*A*N,'--k','DisplayName', 'Reference'); % - reference
        end
    else %there are the positive and negative frequency tones
        if stone1 == 1 
            stem(-wc/pi,A*N/2,'b','DisplayName', 'Tone 1');%amplitudes=A*N/2 - tone 1
        end
        if stone2 == 1
            stem(wc/pi,A*N/2,'y','DisplayName', 'Tone 2');%amplitudes=A*N/2 - tone 2
        end
        if sreference == 1
        plot([-1,1],[1 1]*A*N/2,'--k','DisplayName', 'Reference'); % - reference
        end
    end
    %Now, plot the summation of the two sincs (get their combined effect)
    w2=-pi:2*pi/512:pi; %want only in the range from -pi to pi rad
    wr=w2-wc; wl=w2+wc; %left and right frequencies
    sumSincs = (A/2)*sin((N/2)*wr)./sin(wr/2).*exp(-j*((N-1)/2)*wr) + ...
        (A/2)*sin((N/2)*wl)./sin(wl/2).*exp(-j*((N-1)/2)*wl); %summation
    if sdtft == 1
        plot(w2/pi,abs(sumSincs),'g-','DisplayName', 'DTFT') %plot only the magnitude - DTFT
    end 
    x=A*cos(wc*(0:N-1)); %generate the cosine
    if sfft == 1
        stem(fftFrequencyGrid/pi,fftshift(abs(fft(x))),'rx','DisplayName', 'FFT'); %show FFT result - FFT
    end
    title(['Cosine frequency \Omega_c = ' num2str(wc) ' rad.' ...
        ' FFT is sampling the DTFT (sum of sincs)']);
    axis([-1 1 A*N*[-0 1]]) %clip the graph
    xlabel('Normalized frequency \Omega / \pi');
    ylabel('FFT  X[k] and DTFT   {X(e^{j\Omega})} magnitudes');    
    legend show
    drawnow
end

% --- Executes on button press in xsinc1.
function xsinc1_Callback(hObject, eventdata, handles)
% hObject    handle to xsinc1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xsinc1


% --- Executes on button press in xsinc2.
function xsinc2_Callback(hObject, eventdata, handles)
% hObject    handle to xsinc2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xsinc2

% --- Executes on button press in xtone1.
function xtone1_Callback(hObject, eventdata, handles)
% hObject    handle to xtone1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xtone1

% --- Executes on button press in xtone2.
function xtone2_Callback(hObject, eventdata, handles)
% hObject    handle to xtone2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xtone2

% --- Executes on button press in xreference.
function xreference_Callback(hObject, eventdata, handles)
% hObject    handle to xreference (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xreference

% --- Executes on button press in xdtft.
function xdtft_Callback(hObject, eventdata, handles)
% hObject    handle to xdtft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xdtft

% --- Executes on button press in xfft.
function xfft_Callback(hObject, eventdata, handles)
% hObject    handle to xfft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xfft


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(akwindow4gui);

% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
stepval=get(handles.slider2,'Value');
set(handles.speedtext,'String',stepval);   

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on button press in pausebutton.
function pausebutton_Callback(hObject, eventdata, handles)
% hObject    handle to pausebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of pausebutton
