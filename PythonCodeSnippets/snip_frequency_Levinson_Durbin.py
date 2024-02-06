import numpy as np


def snip_frequency_Levinson_Durbin(R, p):
    # Inicialização
    k = np.zeros(p)
    a = np.zeros(p)
    E = np.zeros(p)
    k[0] = R[1] / R[0]
    a[0] = k[0]
    E[0] = R[0] * (1 - k[0] ** 2)

    # Recursão
    for i in range(1, p):
        k[i] = (R[i + 1] - np.sum(a[:i] * R[i:0:-1])) / E[i - 1]
        a[i] = k[i]
        a[:i] = a[:i] - k[i] * a[i - 1:: -1]
        E[i] = E[i - 1] * (1 - k[i] ** 2)

    return a, k, E


def test_function():
    # Defina o vetor de correlação de amostra R e a ordem de análise LPC p
    R = np.array([1.0, 0.5, 0.2, 0.1])
    p = 3
    # Chame a função com R e p
    a, k, E = snip_frequency_Levinson_Durbin(R, p)

    # Imprima os resultados
    print("Coeficientes LPC (a):", a)
    print("Coeficientes de reflexão (k):", k)
    print("Energias de erro (E):", E)


test_function()
