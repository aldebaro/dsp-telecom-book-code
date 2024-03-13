import numpy as np
import matplotlib.pyplot as plt
import math
from scipy.special import sinc

def integers(vector):
    if vector.dtype == np.int64 or vector.dtype == np.int32:
        return True
    else:
        return False
    
def ak_sinc_reconstruction(n, xn, Ts, n_oversampled, xo, textra=0,go=False):
    # Verifications

    if integers(n) != True: #check if vector has only integerscode 
        raise ValueError('Elements of vector n must be integers!')
    
    
    if integers(n_oversampled)!= True: #check if integers
        raise ValueError('Elements of vector xn must be integers!')
    
    
    num_discrete_samples = len(xn)

    if len(n) != num_discrete_samples:
        raise ValueError('Lengths of n and xn must be the same!')
    
    
    num_oversampled_samples = len(xo)
    if len(n_oversampled) != num_oversampled_samples:
        raise ValueError('Lengths of n_oversampled and xo must be the same!')
    
    '''Oversampling factor can be found by N_o = L (N-1) + 1,
    where N is the number of samples in x and L is the oversampling factor'''
    
    oversampling_factor = (num_oversampled_samples-1) / (num_discrete_samples-1)

    if oversampling_factor % 1 != 0:
        raise ValueError('Oversampling factor must be an integer!')
    
    oversampled_Ts = Ts/oversampling_factor

    '''Create expanded time axis to help visualation if requested
    get number of samples to be added before and after original signal'''

    nextra = math.ceil(textra/oversampled_Ts)
    
    n_oversampled_expanded = np.arange(int(n_oversampled[0]- nextra),n_oversampled[-1]+nextra+1)
    t_oversampled_expanded = n_oversampled_expanded*oversampled_Ts
    total_samples= len(t_oversampled_expanded)
    
    '''Find parcel corresponding to each sinc and sum them to
    compose x_reconstructed'''

    x_parcels = np.zeros((num_discrete_samples, total_samples))
    x_reconstructed = np.zeros((1, total_samples))

    for ncounter in range(num_discrete_samples):
        this_n = n[ncounter] #value of n, for instance, n=-4
        #Sinc delayed by this_n*Ts:
        this_sinc=xn[ncounter]*sinc((t_oversampled_expanded-this_n*Ts)/Ts)
        x_parcels[ncounter,:] = this_sinc #save this sinc
        x_reconstructed = x_reconstructed + this_sinc #add sinc contribution
    
    #Plot results

    t_oversampled = n_oversampled*oversampled_Ts
    
    # Subplot 1
    plt.subplot(3, 1, 1)    
    plt.stem(n, xn)
    plt.title('Discret_Signal')
    plt.grid()
    # Subplot 2
    plt.subplot(3, 1, 2)  
    plt.plot(t_oversampled, xo)
    plt.title('Oversampled_Signal')
    plt.grid()
    # Subplot 3
    if go:
        plt.subplot(3, 1, 3)
        plt.plot(t_oversampled_expanded,x_reconstructed[0], label='Graph1')#Plot the oversampled signal and
        plt.plot(t_oversampled, xo, label='Graph2')                         # reconstructed signal at the same time
        plt.title('Reconstructed_Signal')
    else:
        plt.subplot(3, 1, 3)
        plt.plot(t_oversampled_expanded,x_reconstructed[0])
        plt.title('Reconstructed_Signal')
    plt.tight_layout()
    plt.grid()
    plt.show()

    return x_reconstructed[0],x_parcels,t_oversampled,t_oversampled_expanded
