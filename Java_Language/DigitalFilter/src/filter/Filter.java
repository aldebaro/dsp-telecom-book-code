package filter;

import sound.Processor;

/**
 *
 * @author Yuichi
 */
public class Filter implements Processor{
    protected double[] b;
    protected double[] a;
    protected double[] memory;
    
    public Filter(double[] b, double[] a){
        this.b = new double[b.length];
        
        this.a = new double[a.length];
        
        for(int i=0;i<b.length;i++){
            this.b[i] = b[i]/a[0]; 
        }
        for(int i=0;i<a.length;i++){
            this.a[i] = a[i]/a[0];
        }
        
        int memoryLength = Math.max(a.length-1, b.length-1);
        this.memory = new double[memoryLength];
    }
    
    public void filter(double[] input, double[] output){
        for(int n=0;n<input.length;n++){
            double tmp = this.b[0]*input[n];
            if(this.memory.length>0){
                tmp += this.memory[0];
            }
            output[n] = this.a[0]*(tmp);
            for(int i=0;i<this.memory.length;i++){
                this.memory[i] = 0;
                if(i < b.length - 1){
                    memory[i] += b[i+1]*input[n]; 
                }
                if(i < a.length - 1){
                    memory[i] += (-a[i+1])*output[n];
                }
                if(i < memory.length - 1){
                    memory[i] += memory[i+1];
                }
            }
        }
    }

    @Override
    public void process(double[] in, double[] out) {
        filter(in,out);
    }
    
    public void setB(double b, int idx){
        this.b[idx] = b;
    }
    
    public void setA(double a, int idx){
        this.a[idx] = a;
    }
    
    
}
