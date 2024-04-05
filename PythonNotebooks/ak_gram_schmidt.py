"""
Gram-Schmidt function
"""

import numpy as np

def ak_gram_schmidt(x):
    """
    function [Ah,A]=ak_gram_schmidt(x,tol)
    Gram-Schmidt orthonormalization procedure (x is real)
    Inputs:  x - real matrix: each row is an input vector
            tol - tolerance for stopping procedure (and SVD)
    Outputs: Ah  - direct matrix, which is the Hermitian (transpose in
                  this case) of A
            A   - inverse matrix with basis functions as columns
    Example of usage:
    x=[1 1; 0 2; 1 0; 1 4]
    [Ah,A]=ak_gram_schmidt(x,1e-12) %basis functions are columns of A
    testVector=[10; 10]; %test: vector in same direction as first basis
    testCoefficients=Ah*testVector %result is [14.1421; 0]

    Notes about the code:
    1) The inner product sum(y(m,:).*x(k,:)) is alternatively
      calculated as y(m,:)*x(k,:)' (row vectors)       
    2) In general, a projection is projectionOverBasis=p_xy=
                ( <y,x> / ||y||^2 ) * y =
                ((y(m,:)*x(k,:)')/(y(m,:)*y(m,:)'))*y(m,:);
    but in the code y(m,:)*y(m,:)'=1 and the denominator is 1
    """
    
    print(np.finfo(max(x)))
    tol=min(max(np.transpose(np.shape(x)))*np.finfo(max(x))) #find tolerance

    m, dimension=np.shape(x)
    if dimension > m:
        print('Input dimension larger than number of vectors,\nwhich is ok if you are aware about')

    N = np.linalg.matrix_rank(x,tol=tol) # note: rank is slow because it uses SVD
    y[:] = np.zeros((N, dimension)) # pre-allocate space
    #print("y zeros =", y)
    # pick first vector and normalize it
    print("x[:] =", x[:])
    print(sum(np.power(x[:], 2)))
    print("div =", np.sqrt(sum(np.power(x[:], 2))))
    y = x[:] / np.sqrt(sum(np.power(x[:], 2)))
    numBasis = 1

    for k in range(1, m):
        errorVector = x[k:] # error (or target) vector
        for m in range(1, numBasis): # go over all previously selected basis
            # p_xy = <x,y> * y; # recall, in this case: ||y||=1
            projectionOverBasis = ((y[m:]*np.transpose(x[k:])))*y[m:]
            # update target:
            errorVector -= projectionOverBasis
            
        magErrorVector = np.sqrt(sum(np.power(errorVector, 2)))
        if ( magErrorVector > tol ):
            # keep the new vector in basis set
            numBasis += 1
            y[numBasis:] = errorVector / magErrorVector
            if (numBasis >= N):
                break # Abort. Reached final number of vectors

    A = np.transpose(y);  #basis functions are the columns of inverse matrix A
    Ah = np.transpose(A) # the direct matrix transform is the Hermitian of A

    return A, Ah


def test_ak_gram_schmidt():
    x = [[0, -1, -1, 0],
         [0, 2,  2,  0],
         [0, 1,  0,  1],
         [1, 1,  1,  1],
         [-1, 2 , 2,  1]]

    Ah, A = ak_gram_schmidt(x)
    print("Ah = ", Ah)
    print("A = ", A)

if __name__ == "__main__":
    test_ak_gram_schmidt()
