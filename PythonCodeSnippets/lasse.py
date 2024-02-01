import numpy as np
import matplotlib.pyplot as plt
from scipy.signal import welch, get_window

def rectpuls(x,w = 1):
    if not isinstance(x, np.ndarray):
        print("x must be a NumPy array.")
    # pulse with duration [-0.5,0.5)
    y = 1.0*(x>0.5*w) - 1.0*(x<=-0.5*w)
    y = np.array(y,dtype = x.dtype)
    return y

# function bellow is adapted from wiki.python.org/moin/NumericAndScientificRecipes
"""
Find 2^n that is equal to or greater than.
"""
def nextpow2(i):
    n = 0
    while 2**n < i: n +=1
    return n

def ak_psd(x,Fs):
    #Returns the PSD SdBmHz of x in dBm/Hz in the frequency range
    #f=[-Fs/2,Fs/2[. Usage example:
    #Fs=100
    #x=np.exp(j*2*pi*7/Fs*np.arange(40000+1))
    #S,f=ak_psd(x,Fs)
    #plt.plot(f,S) #see peak at 7 Hz
    N=len(x)
    if N > 2048 :
        M = np.round(len(x)/8).astype(int) #number of samples per block for Welch's
    else: #use a single FFT in case N is not longer than 2048
        M=len(x)

    b=nextpow2(M)
    Nfft=2**b #choose a power of 2 for FFT-length 
    ham_window = get_window('hamming',M, fftbins = False)
    _,S = welch(x = x, fs = Fs, window = ham_window,nfft=Nfft, return_onesided = False)
    df=Fs/Nfft #FFT frequency spacing
    f=np.arange(-Fs/2,Fs/2,df) - df #frequency (abscissa) axis
    S=np.fft.fftshift(S) #move negative part to the left
    S=S*1000 #convert from Watts to mWatts
    SdBmHz = 10*np.log10(S) #provide PSD in dBm/Hz
    #plt.plot(f,SdBmHz)
    return SdBmHz,f

def ak_sinc_reconstruction(n, x, Ts, n_oversampled, xo, textra = 0):

    #function [x_reconstructed, x_parcels, t_oversampled, ...
    #    t_oversampled_expanded] = ak_sinc_reconstruction(n, x, Ts, ...
    #    n_oversampled, xo, textra)
    ## Illustrate perfect sinc reconstruction
    #Inputs:
    #n - vector with integers as abscissa of x
    #x - samples of signal to be reconstructed
    #Ts - sampling interval (in seconds)
    #n_oversampled - vector with integers as abscissa of oversampled x
    #xo - oversampled x, to be used for comparison purposes
    #textra - extra time (in s) to be added for visualization purposes
    #Outputs:
    #x_reconstructed - reconstructed signal
    #x_parcels - matrix with individual sincs used in x_reconstructed
    #t_oversampled - discrete-time in seconds, corresponding to
    #                input n_oversampled multiplied by the oversampled Ts
    #t_oversampled_expanded - similar to t_oversampled but with the
    # #                         addition of textra in the beginning and end

    # TODO: Implement checks in python
    # if nargin < 6
    #     textra = 0 #5*Ts
    # end
    # if sum(logical(rem(n,1))) ~= 0 #check if vector has only integers
    #     error('Elements of vector n must be integers!')
    # end
    # if sum(logical(rem(n_oversampled,1))) ~= 0 #check if integers
    #     error('Elements of vector n_oversampled must be integers!')
    # end

    num_discrete_samples = len(x)
    # if length(n) ~= num_discrete_samples
    #     error('Lengths of n and xn must be the same!')
    # end

    num_oversampled_samples = len(xo)
    # if length(n_oversampled) ~= num_oversampled_samples
    #     error('Lengths of n_oversampled and xo must be the same!')
    # end

    #oversampling factor can be found by
    #N_o = L (N-1) + 1, where N is the number of samples
    #in x and L is the oversampling factor
    oversampling_factor = (num_oversampled_samples-1) / (num_discrete_samples-1)
    # if mod(oversampling_factor,1) ~= 0
    #     error('Oversampling factor must be an integer!')
    # end
    oversampled_Ts = Ts/oversampling_factor

    ## Create expanded time axis to help visualation if requested
    #get number of samples to be added before and after original signal
    nextra = np.ceil(textra/oversampled_Ts).astype(int)

    n_oversampled_expanded = np.arange(n_oversampled[0] - nextra, n_oversampled[-1] + nextra)
    t_oversampled_expanded = n_oversampled_expanded*oversampled_Ts

    total_samples = len(t_oversampled_expanded)
    ## Find parcel corresponding to each sinc and sum them to
    # compose x_reconstructed
    x_parcels = np.zeros((num_discrete_samples, total_samples))
    x_reconstructed = np.zeros(total_samples)
    for ncounter in range(num_discrete_samples):
        this_n = n[ncounter] #value of n, for instance, n=-4
        #Sinc delayed by this_n*Ts:
        this_sinc=x[ncounter]*np.sinc((t_oversampled_expanded-this_n*Ts)/Ts)
        x_parcels[ncounter,:]=this_sinc #save this sinc
        x_reconstructed = x_reconstructed + this_sinc #add sinc contribution

    #create vector in case one wants to plot results
    t_oversampled = n_oversampled*oversampled_Ts
    # if nargout < 1
    #     #plot results
    #     ak_plot_sinc_reconstruction(n, x, Ts, t_oversampled, xo, ...
    #         t_oversampled_expanded,x_reconstructed,x_parcels)
    # end

    ak_plot_sinc_reconstruction(n, x, Ts, t_oversampled, xo,\
                                t_oversampled_expanded,x_reconstructed,x_parcels)
                                
    return x_reconstructed, x_parcels, t_oversampled, t_oversampled_expanded

def ak_plot_sinc_reconstruction(n, x, Ts, t_oversampled, xo,\
                                t_oversampled_expanded,x_reconstructed,x_parcels):
    #function ak_plot_sinc_reconstruction(n, x, Ts, t_oversampled, xo,...
    #    t_oversampled_expanded,x_reconstructed,x_parcels)
    #See ak_sinc_reconstruction.m

    plt.figure(1)
    plt.subplot(411)
    plt.plot(t_oversampled, xo)
    plt.xlabel('t (s)')
    plt.ylabel('Original x(t)')
    plt.tight_layout()

    plt.subplot(413)
    plt.stem(n, x)
    plt.xlabel('Discrete-time n')
    plt.ylabel('x[n]')
    plt.grid()
    plt.tight_layout()

    plt.subplot(412)
    t = n*Ts
    #T=0.2; ak_sampledsignalsplot(x,[],T,'color','r')
    ak_sampledsignalsplot(x, t, [])

    #plt.plot(t, np.zeros(len(t)),color = 'b')
    plt.xlabel('t (s)')
    plt.ylabel('x$_s$(t)')
    plt.tight_layout()
    plt.grid()

    plt.subplot(414)
    plt.plot(t_oversampled, xo)

    plt.plot(t_oversampled_expanded,x_reconstructed,'r-'); #,'--','LineWidth',1.5);

    xmin, xmax, ymin, ymax = plt.axis()
    support = t_oversampled[-1] - t_oversampled[0]
    xmin = t_oversampled[0] - support*0.05
    xmax = t_oversampled[-1] + support*0.05

    plt.axis([xmin, xmax, ymin, ymax])
    plt.legend(['Original','Reconstructed'])
    plt.tight_layout()
    plt.ylabel('x(t)')
    plt.xlabel('t (s)')

    #ak_changeFigureSize(1.5, 1.5) #expand figure

    ## Show the parcels (each sinc) in sinc reconstruction
    plt.figure(2)

    plt.plot(t_oversampled_expanded,x_reconstructed, linewidth = 1.5)

    # TODO: implement colors
    #C=colororder; #Octave does not recognize it
    # C=get(gca,"colororder");
    # newcolors = [0.83 0.14 0.14
    #     1.00 0.54 0.00
    #     0.47 0.25 0.80];
    # C=[C(1,:)
    #     newcolors
    #     C(2:end,:)];
    # #colororder(C); #Octave does not recognize it
    # set(gca,"colororder",C);
    # [num_colors, ~] = size(C);
    # hold on

    num_discrete_samples = len(x)
    for i in range(num_discrete_samples):
        plt.plot(t_oversampled_expanded,x_parcels[i,:],'--')
        plt.stem(n*Ts,x)
        plt.plot(n[i]*Ts,x[i], marker = 'x', markersize = 20, linewidth = 2.5)#,'x','MarkerSize',20,'Color',C(j,:),'LineWidth',2.5);

    y_zeros = np.arange(t_oversampled_expanded[0],t_oversampled_expanded[-1]+1,Ts)
    plt.stem(y_zeros , np.zeros(len(y_zeros)), markerfmt = 'ko')
    plt.xlabel('t (s)')
    plt.ylabel('Reconstructed x(t)')

    plt.tight_layout()
    #ak_changeFigureSize(1.5, 1.5) #expand figure

def ak_changeFigureSize(width_factor,height_factor):
    # function ak_changeFigureSize(width_factor, height_factor)
    #Change figure size by the factors width_factor and height_factor,
    #and position figure in center of screen.

    #From https://www.cs.cornell.edu/courses/cs100m/2007fa/Graphics/Position.pdf
    #set(gcf,'position',[a b H W])
    #places the lower left corner of an H-by-W figure window at (a, b).

    w,h = plt.gcf().get_size_inches()
    plt.gcf().set_size_inches(w*width_factor,h*height_factor)
    # pos=get(gcf, 'Position'); #get figure's position on screen
    # pos(3)=floor(pos(3)*width_factor); #adjust the width
    # pos(4)=floor(pos(4)*height_factor); #adjust the height
    # set(gcf,'Position',pos);
    # movegui(gcf,'center')

# TODO: implement 'varargin'
def ak_sampledsignalsplot(x,t,T):
    # function ak_sampledsignalsplot(x,t,T,varargin)
    #Plots the time series x as impulses. The abscissa is t as time-axis or
    #generated automatically with T as sampling interval.
    #The distinction with respect to ak_impulseplot is that this function does
    #not plot the zero values
    #Examples:
    # x=1:3; t=1:0.5:2; ak_sampledsignalsplot(x,t,[],'color','r')
    # T=0.5; ak_sampledsignalsplot(x,[],T,'color','r')

    # TODO: implement syntax check
    #Check syntax:
    # if isempty(t)
    #     if isempty(T)
    #         error(['You need to specify the time-axis t or the ' ...
    #         'sampling interval T']);
    #     end
    #     if ~isnumeric(T)
    #         error('Syntax error: T must be numeric (when specified)');
    #     end
    #     #generate time-axis
    #     t=0:T:(length(x)-1)*T;
    # else
    #     if nargin > 2 #allow the user specify only two parameters
    #         if ~isempty(T)
    #             error(['You cannot specify both the time-axis t and the ' ...
    #             'sampling interval T. Check the syntax']);
    #         end    
    #     end
    # end

    #AK April 24 - 2021
    #because negative impulses were having different colors than positive ones
    #I am defining a default color:
    # if isempty(varargin)
    #     varargin={'color','b'};
    # end

    #remember whether hold is on or off
    # holdison = 0;
    # if ishold
    #     holdison = 1;
    # end
    #add some extra comments to stem for plotting an arrowhead
    #do not forget to pass it the other parameters in varargin{:}

    indicesPos = np.where(x>0)
    indicesNeg = np.where(x<0)
    indicesZero = np.where(x==0)

    markersize = 9
    linewidth = 2
    
    pos_markerline, pos_stemline, pos_baseline = plt.stem(t[indicesPos],x[indicesPos])
    plt.setp(pos_markerline, marker = '^', markersize = markersize,\
             color = 'b')
    plt.setp(pos_stemline, color = 'b', linewidth = linewidth)
    plt.setp(pos_baseline,linestyle = '')

    neg_markerline, neg_stemline, neg_baseline = plt.stem(t[indicesNeg],x[indicesNeg])
    plt.setp(neg_markerline, marker = 'v', markersize = markersize,\
             color = 'b')
    plt.setp(neg_stemline, color = 'b', linewidth = linewidth)
    plt.setp(neg_baseline,linestyle = '')

    # if 0 #do not plot
    # stem(t(indicesZero),x(indicesZero),'marker','o','markersize',markersize,...
    #     'markerfacecolor','auto', ...
    #     'LineStyle','-', 'LineWidth',linewidth, ...
    #     varargin{:});
    # end

    plt.plot(t,np.zeros(np.size(t)), color = 'b', linestyle='-') #plot line to represent zeros
 

    #restore previous hold situation
    # hold off
    # if holdison==1
    #     hold on
    # end

    plt.xlabel('Time (s)')
    plt.ylabel('Amplitude')