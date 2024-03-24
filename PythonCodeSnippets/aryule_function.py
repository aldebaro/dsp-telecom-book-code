from spectrum import LEVINSON, CORRELATION
import numpy as np

def aryule(X, order, norm='biased', allow_singularity=True):
    #assert norm in ['biased', 'unbiased']
    r = CORRELATION(X, maxlags=order, norm=norm)
    A, P, k = LEVINSON(r, allow_singularity=allow_singularity)
    A = np.insert(A, 0, 1)
    return A, P, k
