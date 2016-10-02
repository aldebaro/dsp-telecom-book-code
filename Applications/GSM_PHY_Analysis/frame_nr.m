function FN = frame_nr(T3M, T2, T1)

T3 = (10 * T3M) + 1;

FN	=	51 * mod((T3 - T2),(26)) + T3 + 51 * 26 * T1;

