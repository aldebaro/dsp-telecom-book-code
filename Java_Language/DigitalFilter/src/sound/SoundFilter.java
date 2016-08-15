package sound;

import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.SourceDataLine;
import javax.sound.sampled.TargetDataLine;
import javax.sound.sampled.AudioFormat;
import javax.sound.sampled.LineUnavailableException;
/**
 *
 * @author Yuichi
 */
public class SoundFilter {
    
    protected TargetDataLine inLine;
    protected SourceDataLine outLine;
    protected boolean isStarted;
    protected Processor p;
    
    public SoundFilter(Processor p) throws LineUnavailableException{
        float sampleRate = 44100;
        int bitsPerSample = 16;
        int numberChannels = 1;
        boolean isSigned = true;
        boolean isBigEndian = true;
        
        AudioFormat f = new AudioFormat(sampleRate, bitsPerSample, numberChannels, isSigned, isBigEndian);
        
        inLine = AudioSystem.getTargetDataLine(f);
        inLine.open(f);
        outLine = AudioSystem.getSourceDataLine(f);
        outLine.open(f);
        isStarted = false;
        this.p = p;
    }
    
    public synchronized void start(){
        if(!isStarted){
            isStarted=true;
            
            inLine.start();
            outLine.start();
            Thread t = new Thread(new Runnable(){
                @Override
                public void run(){
                    byte[] buff = new byte[1024];
                    double[] buffDoubleIn = new double[512];
                    double[] buffDoubleOut = new double[512];
                        while(isStarted){
                            inLine.read(buff, 0, buff.length);
                            Util.byteToDouble(buff, buffDoubleIn);
                            p.process(buffDoubleIn, buffDoubleOut);
                            Util.doubleToByte(buffDoubleOut, buff);
                            outLine.write(buff, 0, buff.length);
                        }
                }
            });
            t.start();
        }
    }
    
    public synchronized void stop(){
        if(isStarted){
            isStarted = false;
            inLine.stop();
            outLine.stop();
        }
    }
    
    public void setProcessor(Processor p){
        this.p = p;
    }
}
