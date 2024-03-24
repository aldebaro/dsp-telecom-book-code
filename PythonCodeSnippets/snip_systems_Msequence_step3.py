import numpy as np
from scipy.linalg import convolution_matrix


def M_sequence_step_3(max_index, h, M, R, max_R):
    Rsegment = R[max_index - M, max_index + M]/max_R  # segment of R
    X = convolution_matrix(Rsegment, len(h))  # convolution matrix
    z3 = X*h  # convolution center of z3 is equal to center of z
    h_hat2 = z3[M+1:2*M+1]  # equal to h_hat
    A = np.tranpose(X)*X  # note it is approximately the identity matrix

    return h_hat2, A
