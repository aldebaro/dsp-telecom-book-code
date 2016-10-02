/* 

   This is the c-version of the matlab file viterbi_detector.m 

   This version of the file is constructed so that a mex file can be
   made directly from the source by issuing the matlab command:

   mex viterbi_detector.c

   -in the director where the file resides.

   The time spent in the matlab version of this file is at the very
   least 17% of the total simulation time, if channel-coding is
   used. If no channelcoding is used the time spent is no less than
   53%. These tests are done when Lh=2. Increasing Lh to 3 or 4
   increases the time significantly.

   From the above discussion it is clear that optimizations on this
   function can be assumed to be beneficial.

*/

/* 
   includes here... 
*/
#include "mex.h"
#include <math.h>
#include <stdio.h>


/* Toggle debugging */
#define DEBUG_ARGUMENTS  0 /* For detecting correct transfer of parameters */
#define DEBUG_INCREMENT  0 /* For debugging the INCREMENT table */
#define DEBUG_RUN_IN     0 /* For debugging the run in of the algorithm */
#define DEBUG_METRIC     0 /* For debugging the calculated metric values */
#define DEBUG_BEST_LEGAL 0 /* For debugging the final state */
#define DEBUG_RX_BURST   0 /* For debugging the final state */

/* Headers */

void viterbi_function(int *SYMBOLSi, int *SYMBOLSr,
		      int *NEXT,
		      int *PREVIOUS,
		      int START,
		      int *STOPS,
		      double *Yi,double *Yr,
		      double *Rhhi,double *Rhhr,
		      double *rx_burst,
		      int Lh, int M);

/* 
   This is the mex interface function. It does checking of parameters,
   and handles any errors that may be found.
*/

void mexFunction(
		 int nlhs,       mxArray *plhs[],
		 int nrhs, const mxArray *prhs[]
		 )
{

  /* The variables to pass to the calculation routine */
  int    *NEXT,*PREVIOUS,START,*STOPS,*SYMBOLSr,*SYMBOLSi;
  double *Rhhr,*Rhhi,*Yr,*Yi,*rx_burst;

  /* Helpers */
  int m,n,Lh,M,Mtst;
#define STEPS 148

  /* First we allocate memory for rx_burst */
  rx_burst=mxCalloc(STEPS,sizeof(double));

  /* Check for proper number of arguments */
  if (nrhs != 7) {
    mexErrMsgTxt("viterbi_detector requires seven input arguments.\n");
  } else if (nlhs > 1) {
    mexErrMsgTxt("viterbi_detector allow for one output argument only.\n");
  }

  /* First argument is SYMBOLS. SYMBOLS is a matrix. The matrix has M
     rows, and Lh columns. */
  M  = mxGetM(prhs[0]);
  Lh = mxGetN(prhs[0]);
  Mtst=2;
  for (n=0;n<Lh;n++) {
    Mtst=Mtst*2;
  }
  if ( Lh!=2 && Lh!=3 && Lh!=4 )
    mexErrMsgTxt("Columns(=Lh) of argument SYMBOLS must be either 2,3 or 4.");
  if ( M!=Mtst )
    mexErrMsgTxt("Rows(=M) of argument SYMBOLS must equal 2^(Lh+1).");  
  if ( !mxIsComplex(prhs[0]) )
    mexErrMsgTxt("SYMBOLS need to be complex.");  
  else {
    double *TmpArr_r=mxGetPr(prhs[0]);
    double *TmpArr_i=mxGetPi(prhs[0]);

    SYMBOLSr=mxCalloc(Lh*M,sizeof(int));
    
    for (m=0;m<Lh*M;m++)
      *(SYMBOLSr+m)=(int)*(TmpArr_r+m);
    
#if DEBUG_ARGUMENTS
    /* The matrix originally is MxLh */
    /* Here it is addressed using MATLAB indexes */
    printf("Re(SYMBOLS)=");
    for (m=1;m<=M;m++) {
      printf("\n ");
      for (n=1;n<=Lh;n++) {
	printf("%2d ",*(SYMBOLSr+((n-1)*M+(m-1))));
      }
    }
    printf("\n");
#endif
    
    SYMBOLSi=mxCalloc(Lh*M,sizeof(int));
    
    for (m=0;m<Lh*M;m++)
      *(SYMBOLSi+m)=(int)*(TmpArr_i+m);
    
#if DEBUG_ARGUMENTS
    /* The matrix originally is MxLh */
    /* Here it is addressed using MATLAB indexes */
    printf("Im(SYMBOLS)=");
    for (m=1;m<=M;m++) {
      printf("\n ");
      for (n=1;n<=Lh;n++) {
	printf("%2d ",*(SYMBOLSi+((n-1)*M+(m-1))));
      }
    }
    printf("\n");
#endif

  }

  /* Second argument is NEXT, it has M rows, and two columns. */
  if ( mxGetM(prhs[1])!=M ) 
    mexErrMsgTxt("NEXT and SYMBOLS must have equal many rows.");  
  if ( mxGetN(prhs[1])!=2 ) 
    mexErrMsgTxt("NEXT must have two columns.");  
  if ( mxIsComplex(prhs[1]) )
    mexErrMsgTxt("NEXT can not be complex.");  
  else {
    double *TmpArr=mxGetPr(prhs[1]);
    
    NEXT=mxCalloc(2*M,sizeof(int));
    
    for (m=0;m<2*M;m++)
      *(NEXT+m)=(int)*(TmpArr+m);

#if DEBUG_ARGUMENTS
    /* The matrix originally is Mx2 */
    /* Here it is addressed using MATLAB indexes */
    printf("NEXT=");
    for (m=1;m<=M;m++) {
      printf("\n ");
      for (n=1;n<=2;n++) {
	printf("%2d ",*(NEXT+((n-1)*M+(m-1))));
      }
    }
    printf("\n");
#endif

  }

  /* Third argument is PREVIOUS, it has M rows, and two columns. */
  if ( mxGetM(prhs[2])!=M ) 
    mexErrMsgTxt("PREVIOUS and SYMBOLS must have equal many rows.");  
  if ( mxGetN(prhs[2])!=2 ) 
    mexErrMsgTxt("PREVIOUS must have two columns.");  
  if ( mxIsComplex(prhs[2]) )
    mexErrMsgTxt("PREVIOUS can not be complex.");  
  else {
    double *TmpArr=mxGetPr(prhs[2]);
    
    PREVIOUS=mxCalloc(2*M,sizeof(int));
    
    for (m=0;m<2*M;m++)
      *(PREVIOUS+m)=(int)*(TmpArr+m);

#if DEBUG_ARGUMENTS
    /* The matrix originally is Mx2 */
    /* Here it is addressed using MATLAB indexes */
    printf("PREVIOUS=");
    for (m=1;m<=M;m++) {
      printf("\n ");
      for (n=1;n<=2;n++) {
	printf("%2d ",*(PREVIOUS+((n-1)*M+(m-1))));
      }
    }
    printf("\n");
#endif

  }

  /* Fourth argument is START, it is real and 1x1 */ 
  if ( mxGetM(prhs[3])!=1 || mxGetN(prhs[3])!=1 ||
       mxIsComplex(prhs[3]) || (int)mxGetScalar(prhs[3])>M ||
       (int)mxGetScalar(prhs[3])<1 )
    mexErrMsgTxt("START must be real valued and 1 < START < M.");
  else {
    START=(int)mxGetScalar(prhs[3]);

#if DEBUG_ARGUMENTS
    /* The matrix originally is Mx2 */
    /* Here it is addressed using MATLAB indexes */
    printf("START=%2d\n",START);
#endif

  }
  
  /* Fifth argument is STOPS, it is real and 1x1 or 1x2. */
  /* STOPS is 1x1 if M=8 or M=16. */
  /* If M=32 then STOPS must be 1x2. */
  if ( M==8 || M==16 ) {
    if ( mxGetM(prhs[4])!=1 || mxGetN(prhs[4])!=1 ||
	 mxIsComplex(prhs[4]) || (int)mxGetScalar(prhs[4])>M ||
	 (int)mxGetScalar(prhs[4])<1 )
      mexErrMsgTxt("(M=8/M=16)STOPS must be real valued and 1 < START < M.");
    else {
      double *TmpArr=mxGetPr(prhs[4]);
      
      STOPS=mxCalloc(1,sizeof(int));
      *STOPS=(int)*TmpArr;
      *(STOPS+1)=(int)*(TmpArr+1);
    }

#if DEBUG_ARGUMENTS
    /* The matrix originally is Mx2 */
    /* Here it is addressed using MATLAB indexes */
    printf("STOPS=%2d\n",*STOPS);
#endif
    
  }
  else {
    if ( mxGetM(prhs[4])!=1 || mxGetN(prhs[4])!=2 ||
	 mxIsComplex(prhs[4]) )
      mexErrMsgTxt("(M=32)STOPS must be real valued and 1x2");
    else {
      double *TmpArr=mxGetPr(prhs[4]);
      
      STOPS=mxCalloc(2,sizeof(int));
      *STOPS=(int)*TmpArr;
      *(STOPS+1)=(int)*(TmpArr+1);
      
      if ( *STOPS<1 || *STOPS>M || *(STOPS+1)<1 || *(STOPS+1)>M) 
	mexErrMsgTxt("All elements E of STOPS must 1 < E < M.");
      
#if DEBUG_ARGUMENTS
      /* The matrix originally is Mx2 */
      /* Here it is addressed using MATLAB indexes */
      printf("STOPS=%2d %2d\n",*(STOPS),*(STOPS+1));
#endif

    }
  }

  /* Sixth argument is Y, which is 1x148 and complex valued. */
  if ( mxGetM(prhs[5])!=1 || mxGetN(prhs[5])!=148 || !mxIsComplex(prhs[5]) )
    mexErrMsgTxt("Y, must be 1x148 and complex valued.");
  else {
    Yr=mxGetPr(prhs[5]);
    Yi=mxGetPi(prhs[5]);
  }

  /* The last argument is Rhh, it is complex, and 1x(Lh+1) */
  if ( mxGetM(prhs[6])!=1 || mxGetN(prhs[6])!=Lh+1 || !mxIsComplex(prhs[6]) )
    mexErrMsgTxt("Rhh, must be 1x(Lh+1) and complex valued.");  
  else {
    Rhhr=mxGetPr(prhs[6]);
    Rhhi=mxGetPi(prhs[6]);
  }

#if DEBUG_ARGUMENTS
  /* The matrix originally is Mx2 */
  /* Here it is addressed using MATLAB indexes */
  printf("Real(Rhh) = ");
  for (m=1;m<=(Lh+1);m++)
    printf("%3.2f ",*(Rhhr+(m-1)));
  printf("\n");
  printf("Imag(Rhh) = ");
  for (m=1;m<=(Lh+1);m++)
    printf("%3.2f ",*(Rhhi+(m-1)));
  printf("\n");
#endif

  /* Call the vitirbi detector */
  viterbi_function(SYMBOLSi,SYMBOLSr,
		   NEXT,
		   PREVIOUS,
		   START,
		   STOPS,
		   Yi,Yr,
		   Rhhi,Rhhr,
		   rx_burst,
		   Lh,M);

  /* Return the result to matlab */
  plhs[0]=mxCreateDoubleMatrix(1,148,mxREAL);
  mxSetPr(plhs[0],rx_burst);

}

void viterbi_function(int *SYMBOLSi, int *SYMBOLSr,
		      int *NEXT,
		      int *PREVIOUS,
		      int START,
		      int *STOPS,
		      double *Yi,double *Yr,
		      double *Rhhi,double *Rhhr,
		      double *rx_burst,
		      int Lh, int M)
{
  
#define STEPS 148

  double *METRIC,*INCREMENT;
  int *SURVIVOR,PREVIOUS_STATES[16];
  int ELEMENTS_IN_PREVIOUS_STATES;
  int m,o,n,i;
  int N,PS,S,COMPLEX;
  int PROCESSED;
  int BEST_LEGAL,FINAL,ELEMENTS_IN_STOPS;
  int IESTr[STEPS],IESTi[STEPS];
  
  /*
    
    % KNOWLEDGE OF Lh AND M IS NEEDED FOR THE ALGORITHM TO OPERATE
    %
    [ M , Lh ] = size(SYMBOLS);
    
    % In the C-version this is available.
    
    % THE NUMBER OF STEPS IN THE VITERBI
    %
    STEPS=length(Y);
    
    % This is defined above as a constant
    
    % INITIALIZE TABLES (THIS YIELDS A SLIGHT SPEEDUP).
    %
    METRIC = zeros(M,STEPS);
    SURVIVOR = zeros(M,STEPS);
    
  */
  
  METRIC=mxCalloc(M*STEPS,sizeof(double));
  SURVIVOR=mxCalloc(M*STEPS,sizeof(int));
  
  /*
    % DETERMINE PRECALCULATABLE PART OF METRIC
    %
    INCREMENT=make_increment(SYMBOLS,NEXT,Rhh);

    In the matlab version this is done in a sub-file.
    
    The aim is to construct a table holding the increments of size
    MxM. 

    The matlab way is that INCREMENT(n,m) gives the precalculatable
    increment resulting from a transition from state n to m.

    In C the adress is: *(INCREMENT+((m-1)*M+(n-1))).
  */
 
  INCREMENT=mxCalloc(M*M,sizeof(double));

  /*
    % RECALL THAT THE I SEQUENCE AS IT IS STORED IN STORED AS:
    % [ I(n-1) I(n-2) I(n-3) ... I(n-Lh) ]
    %
    % ALSO RECALL THAT Rhh IS STORED AS:
    % [ Rhh(1) Rhh(2) Rhh(3) ... Rhh(Lh) ]
    %
    % THE FORMULA TO USE IS:
    % INCREMENT(n,m)
    % =
    % real(conj(I(n))*(I(n-Lh)*Rhh(Lh)+I(n-Lh+1)*Rhh(Lh-1)+...+I(n-1)*Rhh(1)))
    %
    % THEY CAN THUS BE MULTIPLIED DIRECTLY WITH EACH OTHER
    
    % LOOP OVER THE STATES, AS FOUND IN THE ROWS IN SYMBOLS.
    %
    for n=1:M, 

  */
  
  for (n=1;n<=M;n++) { /* Recall MATLAB indexing!!! */
    
    double A,B;

    /*
      % ONLY TWO LEGAL NEXT STATES EXIST, SO THE LOOP IS UNROLLED
      %
      m=NEXT(n,1);
    */
    m=*(NEXT+(n-1));
    /*
      INCREMENT(n,m)= real(conj(SYMBOLS(m,1))*SYMBOLS(n,:)*Rhh(2:Lh+1).')
                    = Real(SYMBOLS(m,1)) * Real(SYMBOLS(n,:)*Rhh(2:Lh+1).')
		      --
		      Imag(SYMBOLS(m,1)) * Imag(SYMBOLS(n,:)*Rhh(2:Lh+1).')

      A = Real(SYMBOLS(n,:)*Rhh(2:Lh+1).')
      B = Imag(SYMBOLS(n,:)*Rhh(2:Lh+1).')

      A = Real(SYMBOLS(n,:))*Real(Rhh(2:Lh+1).')
          -
	  Imag(SYMBOLS(n,:))*Imag(Rhh(2:Lh+1).')

      B = Real(SYMBOLS(n,:))*Imag(Rhh(2:Lh+1).')
          +
	  Imag(SYMBOLS(n,:))*Real(Rhh(2:Lh+1).')
    */
    A=0;
    B=0;
    for (i=1;i<=Lh;i++) {
      o=(i-1)*M+(n-1);
      A=A
	+
	*(SYMBOLSr+o)**(Rhhr+(i))
	-
	*(SYMBOLSi+o)**(Rhhi+(i));
      B=B
	+
	*(SYMBOLSr+o)**(Rhhi+(i))
	+
	*(SYMBOLSi+o)**(Rhhr+(i));
    }
    *(INCREMENT+((m-1)*M+(n-1)))=*(SYMBOLSr+(m-1))*A+*(SYMBOLSi+(m-1))*B;
    /*
      m=NEXT(n,2);
    */
    m=*(NEXT+(M+(n-1)));
    /*
      INCREMENT(n,m)=real(conj(SYMBOLS(m,1))*SYMBOLS(n,:)*Rhh(2:Lh+1).');
    */
    A=0;
    B=0;
    for (i=1;i<=Lh;i++) {
      o=(i-1)*M+(n-1);
      A=A
	+
	*(SYMBOLSr+o)**(Rhhr+(i))
	-
	*(SYMBOLSi+o)**(Rhhi+(i));
      B=B
	+
	*(SYMBOLSr+o)**(Rhhi+(i))
	+
	*(SYMBOLSi+o)**(Rhhr+(i));
    }
    *(INCREMENT+((m-1)*M+(n-1)))=*(SYMBOLSr+(m-1))*A+*(SYMBOLSi+(m-1))*B;
    /*
      end
    */
  }

#if DEBUG_INCREMENT
  /* The matrix originally is MxM */
  /* Here it is addressed using MATLAB indexes */
  printf("INCREMENT=");
  for (m=1;m<=M;m++) {
    printf("\n ");
    for (n=1;n<=M;n++) {
      printf("%3.0f ",*(INCREMENT+((n-1)*M+(m-1))));
    }
  }
  printf("\n");
#endif
  
  /*
    
    >>>>>>>>>END OF PRECALCULATABLE METRIC PART<<<<<<<<<<
    
    % THE FIRST THING TO DO IS TO ROLL INTO THE ALGORITHM BY SPREADING OUT 
    % FROM 	THE START STATE TO ALL THE LEGAL STATES. 
    %
    PS=START;
  */
  
  PS=START;

  /*
    % NOTE THAT THE START STATE IS REFERRED TO AS STATE TO TIME 0
    % AND THAT IT HAS NO METRIC.
    %
    S=NEXT(START,1);
  */
  
  S=*(NEXT+(PS-1));

  /*
    METRIC(S,1)=real(conj(SYMBOLS(S,1))*Y(1))-INCREMENT(PS,S);
               =real(SYMBOLS(S,1))*real(Y(1))
	        --
		imag(SYMBOLS(S,1))*imag(Y(1))
		-
		INCREMENT(PS,S);
  */

  *(METRIC+(S-1))=*(SYMBOLSr+(S-1))**(Yr+(1-1))
                  +
                  *(SYMBOLSi+(S-1))**(Yi+(1-1))
                  -
                  *(INCREMENT+((S-1)*M+(PS-1)));
  /*
    SURVIVOR(S,1)=START;
  */

  *(SURVIVOR+S)=START;

  /*
    S=NEXT(START,2);
  */
  
  S=*(NEXT+(M+(START-1)));

  /*
    METRIC(S,1)=real(conj(SYMBOLS(S,1))*Y(1))-INCREMENT(PS,S);
  */

  *(METRIC+(S-1))=*(SYMBOLSr+(S-1))**(Yr+(1-1))
                  +
                  *(SYMBOLSi+(S-1))**(Yi+(1-1))
                  -
                  *(INCREMENT+((S-1)*M+(PS-1)));  

  /*    
    SURVIVOR(S,1)=START;
  */

  *(SURVIVOR+S)=START;

  /*
    PREVIOUS_STATES=NEXT(START,:);
  */
    
  *PREVIOUS_STATES=*(NEXT+((1-1)*M+(START-1)));
  *(PREVIOUS_STATES+1)=*(NEXT+((2-1)*M+(START-1)));
  ELEMENTS_IN_PREVIOUS_STATES=2;

  /*
    % MARK THE NEXT STATES AS REAL. N.B: COMPLEX INDICATES THE POLARITY
    % OF THE NEXT STATE, E.G. STATE 2 IS REAL.
    %
    COMPLEX=0;
  */

  COMPLEX=0;

  /*
    for N = 2:Lh,
  */
  
  for (N=2;N<=Lh;N++) {
    
    int STATE_CNTR;
    int USED[16];
    
    /*
      if COMPLEX,
    */
    if (COMPLEX) 
      /* COMPLEX=0; */
      COMPLEX=0; 
    /* else */
    else
      /* COMPLEX=1; */
      COMPLEX=1;
    /* end */
    
    /*
      STATE_CNTR=0;
    */
    STATE_CNTR=0;
    /*
      for PS = PREVIOUS_STATES,
    */
    for (n=1;n<=ELEMENTS_IN_PREVIOUS_STATES;n++) { 
      /* The above 'for PS=VECTOR' MATLAB trick is not available in C */
      PS=*(PREVIOUS_STATES+(n-1));
      /*
	STATE_CNTR=STATE_CNTR+1;
      */
      STATE_CNTR=STATE_CNTR+1;      
      /*
	S=NEXT(PS,1);
      */
      S=*(NEXT+((1-1)*M+(PS-1)));
      /*
	METRIC(S,N)=
	METRIC(PS,N-1)+real(conj(SYMBOLS(S,1))*Y(N))-INCREMENT(PS,S);
      */
      *(METRIC+(N-1)*M+(S-1))=*(METRIC+((N-1-1)*M+(PS-1)))
	                      +
                              *(SYMBOLSr+(S-1))**(Yr+(N-1))
                              +
	                      *(SYMBOLSi+(S-1))**(Yi+(N-1))
                              - 
	                      *(INCREMENT+((S-1)*M+(PS-1)));     
      /*	
	SURVIVOR(S,N)=PS;
      */
      *(SURVIVOR+((N-1)*M+(S-1)))=PS;
      /*
	USED(STATE_CNTR)=S;
      */
      *(USED+(STATE_CNTR-1))=S;
      /*
	STATE_CNTR=STATE_CNTR+1;
      */
      STATE_CNTR=STATE_CNTR+1;
      /*
	S=NEXT(PS,2);
      */
      S=*(NEXT+((2-1)*M+(PS-1)));
      /*
	METRIC(S,N)=
	METRIC(PS,N-1)+real(conj(SYMBOLS(S,1))*Y(N))-INCREMENT(PS,S);
      */
      *(METRIC+(N-1)*M+(S-1))=*(METRIC+((N-1-1)*M+(PS-1)))
	                      +
                              *(SYMBOLSr+(S-1))**(Yr+(N-1))
                              +
	                      *(SYMBOLSi+(S-1))**(Yi+(N-1))
                              - 
	                      *(INCREMENT+((S-1)*M+(PS-1)));     
      /*
	SURVIVOR(S,N)=PS;    
      */
      *(SURVIVOR+(N-1)*M+(S-1))=PS;
      /*
	USED(STATE_CNTR)=S;
      */
      *(USED+(STATE_CNTR-1))=S;
      /*
	end
      */
    }
    ELEMENTS_IN_PREVIOUS_STATES=STATE_CNTR;
    /*
      PREVIOUS_STATES=USED;
    */
    for (m=1;m<=ELEMENTS_IN_PREVIOUS_STATES;m++)
      *(PREVIOUS_STATES+(m-1))=*(USED+(m-1));
    /*
      end
    */
  }

  /*
    % AT ANY RATE WE WILL HAVE PROCESSED Lh STATES AT THIS TIME
    %
  PROCESSED=Lh;
  */
  PROCESSED=Lh;  
  /*
    % WE WANT AN EQUAL NUMBER OF STATES TO BE REMAINING. THE NEXT LINES ENSURE
    % THIS.
    %
    if ~COMPLEX,
  */
  if (!COMPLEX) {    
    /*
      COMPLEX=1;
    */
    COMPLEX=1;
    /*
      PROCESSED=PROCESSED+1;
    */
    PROCESSED=PROCESSED+1;
    /*
      N=PROCESSED;
    */
    N=PROCESSED;
    /*
      for S = 2:2:M,
    */
    for (S=2;S<=M;S=S+2) {
      int M1,M2;
      /*
	PS=PREVIOUS(S,1);
      */
      PS=*(PREVIOUS+((1-1)*M+(S-1)));
      /*
	M1=METRIC(PS,N-1)+real(conj(SYMBOLS(S,1))*Y(N)-INCREMENT(PS,S));
      */
      M1=*(METRIC+((N-1-1)*M+(PS-1)))
	 +
	 *(SYMBOLSr+(S-1))**(Yr+(N-1))
	 +
	 *(SYMBOLSi+(S-1))**(Yi+(N-1))
	 - 
	 *(INCREMENT+((S-1)*M+(PS-1)));
      /*
	PS=PREVIOUS(S,2);
      */
      PS=*(PREVIOUS+((2-1)*M+(S-1)));
      /*
	M2=METRIC(PS,N-1)+real(conj(SYMBOLS(S,1))*Y(N)-INCREMENT(PS,S)); 
      */
      M2=*(METRIC+((N-1-1)*M+(PS-1)))
	 +
	 *(SYMBOLSr+(S-1))**(Yr+(N-1))
	 +
	 *(SYMBOLSi+(S-1))**(Yi+(N-1))
	 - 
	 *(INCREMENT+((S-1)*M+(PS-1)));
      /*
	if M1 > M2,
      */
      if (M1>M2) {
	/*
	  METRIC(S,N)=M1;
	*/
	*(METRIC+(M*(N-1)+(S-1)))=M1;
	/*
	  SURVIVOR(S,N)=PREVIOUS(S,1);
	*/
	*(SURVIVOR+((N-1)*M+(S-1)))=*(PREVIOUS+((1-1)*M+(S-1)));
	/*
	  else
	*/
      }
      else {
	/*
	  METRIC(S,N)=M2;
	*/
	*(METRIC+(M*(N-1)+(S-1)))=M2;
	/*
	  SURVIVOR(S,N)=PREVIOUS(S,2);
	*/
	*(SURVIVOR+((N-1)*M+(S-1)))=*(PREVIOUS+((2-1)*M+(S-1)));
	/*
	  end
	*/
      }
      /*	
		end
      */
    }
    /*
      end
    */
  }

#if DEBUG_RUN_IN
  /* The metric matrix is originally is MxSTEPS */
  /* Only the first PROCESSED columns are printed */
  /* Here it is addressed using MATLAB indexes */
  printf("METRIC=");
  for (m=1;m<=M;m++) {
    printf("\n ");
    for (n=1;n<=PROCESSED;n++) {
      printf("%3.0f ",*(METRIC+((n-1)*M+(m-1))));
    }
  }
  printf("\n");
#endif

  /*
    % NOW THAT WE HAVE MADE THE RUN-IN THE REST OF THE METRICS ARE
    % CALCULATED IN THE STRAIGHT FORWARD MANNER. OBSERVE THAT ONLY
    % THE RELEVANT STATES ARE CALCULATED, THAT IS REAL FOLLOWS COMPLEX
    % AND VICE VERSA.
    %
    N=PROCESSED+1;
  */
  N=PROCESSED+1;
  /*
    while N <= STEPS,
  */
  while (N<=STEPS) {
    int M1,M2;
    /*
      for S = 1:2:M-1,
    */
    for (S=1;S<=(M-1);S=S+2) {
      /*
	PS=PREVIOUS(S,1);
      */
      PS=*(PREVIOUS+((1-1)*M+(S-1)));
      /*
	M1=METRIC(PS,N-1)+real(conj(SYMBOLS(S,1))*Y(N)-INCREMENT(PS,S));
      */
      M1=*(METRIC+((N-1-1)*M+(PS-1)))
	 +
	 *(SYMBOLSr+(S-1))**(Yr+(N-1))
	 +
	 *(SYMBOLSi+(S-1))**(Yi+(N-1))
	 - 
	 *(INCREMENT+((S-1)*M+(PS-1)));      
      /*
	PS=PREVIOUS(S,2);
      */
      PS=*(PREVIOUS+((2-1)*M+(S-1)));
      /*
	M2=METRIC(PS,N-1)+real(conj(SYMBOLS(S,1))*Y(N)-INCREMENT(PS,S)); 
      */
      M2=*(METRIC+((N-1-1)*M+(PS-1)))
	 +
	 *(SYMBOLSr+(S-1))**(Yr+(N-1))
	 +
	 *(SYMBOLSi+(S-1))**(Yi+(N-1))
	 - 
	 *(INCREMENT+((S-1)*M+(PS-1)));
      /*	
	if M1 > M2,
      */
      if (M1>M2) {
	/*
	  METRIC(S,N)=M1;
	*/
	*(METRIC+(M*(N-1)+(S-1)))=M1;
	/*
	  SURVIVOR(S,N)=PREVIOUS(S,1);
	*/
	*(SURVIVOR+((N-1)*M+(S-1)))=*(PREVIOUS+((1-1)*M+(S-1)));
	/*
	  else
	*/
      }
      else {
	/*
	  METRIC(S,N)=M2;
	*/
	*(METRIC+(M*(N-1)+(S-1)))=M2;
	/*
	  SURVIVOR(S,N)=PREVIOUS(S,2);
	*/
	*(SURVIVOR+((N-1)*M+(S-1)))=*(PREVIOUS+((2-1)*M+(S-1)));
	/*
	  end
	*/
      }
      /*	
		end
      */
    }
    /*
      N=N+1;
    */
    N=N+1;
    /*
      for S = 2:2:M,
    */
    for (S=2;S<=M;S=S+2) {
      /*
	PS=PREVIOUS(S,1);
      */
      PS=*(PREVIOUS+((1-1)*M+(S-1)));
      /*
	M1=METRIC(PS,N-1)+real(conj(SYMBOLS(S,1))*Y(N)-INCREMENT(PS,S));
      */
      M1=*(METRIC+((N-1-1)*M+(PS-1)))
	 +
	 *(SYMBOLSr+(S-1))**(Yr+(N-1))
	 +
	 *(SYMBOLSi+(S-1))**(Yi+(N-1))
	 - 
	 *(INCREMENT+((S-1)*M+(PS-1)));      
      /*
	PS=PREVIOUS(S,2);
      */
      PS=*(PREVIOUS+((2-1)*M+(S-1)));
      /*
	M2=METRIC(PS,N-1)+real(conj(SYMBOLS(S,1))*Y(N)-INCREMENT(PS,S)); 
      */
      M2=*(METRIC+((N-1-1)*M+(PS-1)))
	 +
	 *(SYMBOLSr+(S-1))**(Yr+(N-1))
	 +
	 *(SYMBOLSi+(S-1))**(Yi+(N-1))
	 - 
	 *(INCREMENT+((S-1)*M+(PS-1)));
      /*	
	if M1 > M2,
      */
      if (M1>M2) {
	/*
	  METRIC(S,N)=M1;
	*/
	*(METRIC+(M*(N-1)+(S-1)))=M1;
	/*
	  SURVIVOR(S,N)=PREVIOUS(S,1);
	*/
	*(SURVIVOR+((N-1)*M+(S-1)))=*(PREVIOUS+((1-1)*M+(S-1)));
	/*
	  else
	*/
      }
      else {
	/*
	  METRIC(S,N)=M2;
	*/
	*(METRIC+(M*(N-1)+(S-1)))=M2;
	/*
	  SURVIVOR(S,N)=PREVIOUS(S,2);
	*/
	*(SURVIVOR+((N-1)*M+(S-1)))=*(PREVIOUS+((2-1)*M+(S-1)));
	/*
	  end
	*/
      }
      /*	
		end
      */
    }
    /*
      N=N+1;
    */
    N=N+1;
    /*
      end  
    */
  }

#if DEBUG_METRIC
  /* The metric matrix is originally is MxSTEPS */
  /* Only the first 10 columns are printed */
  /* Here it is addressed using MATLAB indexes */
  printf("Only printing first 10 columns of METRIC\n");
  printf("METRIC=");
  for (m=1;m<=M;m++) {
    printf("\n ");
    for (n=1;n<=10;n++) {
      printf("%3.0f ",*(METRIC+((n-1)*M+(m-1))));
    }
  }
  printf("\n");
  /* Also the last 10 columns are printed */
  printf("Only printing last 10 columns of METRIC\n");
  printf("METRIC=");
  for (m=1;m<=M;m++) {
    printf("\n ");
    for (n=(STEPS-10);n<=STEPS;n++) {
      printf("%3.0f ",*(METRIC+((n-1)*M+(m-1))));
    }
  }
  printf("\n");
#endif
  
  /*
    % HAVING CALCULATED THE METRICS, THE MOST PROBABLE STATESEQUENCE IS
    % INITIALIZED BY CHOOSING THE HIGHEST METRIC AMONG THE LEGAL STOP 
    % STATES.
    %
    BEST_LEGAL=0;
  */
  BEST_LEGAL=0;
  /*
    for FINAL = STOPS,
    
    The for FINAL=STOPS, shown above isn't available in C.  The thing
    to do is to determine the number of elements in STOPS, and then
    access them as they are needed.  
  */  
  switch (Lh) {
  case 2:
  case 3:
    ELEMENTS_IN_STOPS=1;
  case 4:
    ELEMENTS_IN_STOPS=2;
  }
  
  /*
    Now it is time to comence the for loop;
  */
  for (n=1;n<=ELEMENTS_IN_STOPS;n++) {
    FINAL=*(STOPS+(n-1));
    /*
      if METRIC(FINAL,STEPS) > BEST_LEGAL,
    */
    if (*(METRIC+((STEPS-1)*M+(FINAL-1)))>BEST_LEGAL) {
      /*
	S=FINAL;
      */
      S=FINAL;
      /*
	BEST_LEGAL=METRIC(FINAL,STEPS);
      */
      BEST_LEGAL=*(METRIC+((STEPS-1)*M+(FINAL-1)));
      /*
	end
      */
    }
    /*
      end
    */
  }
  
#if DEBUG_BEST_LEGAL
  printf("BEST_LEGAL=\n");
  printf(" %d \n\n",BEST_LEGAL);
  printf("S=\n");
  printf(" %d\n",S);
#endif 
  
  /*
    % UNCOMMENT FOR TEST OF METRIC
    %
    % METRIC
    % BEST_LEGAL
    % S
    % pause
    
    % HAVING FOUND THE FINAL STATE, THE MSK SYMBOL SEQUENCE IS ESTABLISHED
    %
    IEST(STEPS)=SYMBOLS(S,1);
  */
  *(IESTr+(STEPS-1))=*(SYMBOLSr+((1-1)*M+(S-1)));
  *(IESTi+(STEPS-1))=*(SYMBOLSi+((1-1)*M+(S-1)));
  /*
    N=STEPS-1;
  */
  N=STEPS-1;
  /*
    while N > 0,
  */
  while (N>0) {
    /*
      S=SURVIVOR(S,N+1);
    */
    S=*(SURVIVOR+((N+1-1)*M+(S-1)));
    /*
      IEST(N)=SYMBOLS(S,1);
    */
    *(IESTr+(N-1))=*(SYMBOLSr+((1-1)*M+(S-1)));
    *(IESTi+(N-1))=*(SYMBOLSi+((1-1)*M+(S-1)));
    /*
      N=N-1;
    */
    N=N-1;
    /*
      end
    */
  }
  /*
    % THE ESTIMATE IS NOW FOUND FROM THE FORMULA:
    % IEST(n)=j*rx_burst(n)*rx_burst(n-1)*IEST(n-1)
    % THE FORMULA IS REWRITTEN AS:
    % rx_burst(n)=IEST(n)/(j*rx_burst(n-1)*IEST(n-1))
    % FOR INITIALIZATION THE FOLLOWING IS USED:
    % IEST(0)=1 og rx_burst(0)=1
    %

    In lack of complex numbers the above is rewritten:

    We use the fact

    if IESTr(N)!=0 then 
    IESTi(N)==0 , IESTr(N-1)==0 and IESTi(N-1)!=0.
    
    rx_burst(1)=IEST(1)/(j*1*1);
  */
  *(rx_burst+(1-1))=*(IESTi+(1-1));
  /*
    for n = 2:STEPS,
  */
  for (n=2;n<=STEPS;n++) {
    /*
      rx_burst(n)=IEST(n)/(j*rx_burst(n-1)*IEST(n-1));
    */
    if (*(IESTr+(n-1)))
      *(rx_burst+(n-1))=-*(IESTr+(n-1))/(*(rx_burst+(n-1-1))**(IESTi+(n-1-1)));
    else 
      *(rx_burst+(n-1))=*(IESTi+(n-1))/(*(rx_burst+(n-1-1))**(IESTr+(n-1-1)));
    /*
      end
    */
  }
  /*
    % rx_burst IS POLAR (-1 AND 1), THIS TRANSFORMS IT TO
    % BINARY FORM (0 AND 1).
    %
    rx_burst=(rx_burst+1)./2;
  */
  for (n=1;n<=STEPS;n++) {
    *(rx_burst+(n-1))=(*(rx_burst+(n-1))+1)/2;
  }

#if DEBUG_RX_BURST
  printf("rx-burst=\n");
  for (n=1;n<=STEPS;n++) {
    printf("%2.0f ",*(rx_burst+(n-1)));
  }
  printf("\n");
#endif

}




















