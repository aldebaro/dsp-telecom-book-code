package sound;

import java.nio.ByteBuffer;
import java.util.Locale;
import java.util.Scanner;

/**
 *
 * @author Yuichi
 */
public class Util {
    public static void byteToDouble(byte[] in, double[] out){
        ByteBuffer buff = ByteBuffer.wrap(in);
        
        for(int i=0;i<out.length;i++){
            out[i] = (double)buff.getShort();
        }
    }
    
    public static void doubleToByte(double[] in, byte[] out){
        ByteBuffer buff = ByteBuffer.wrap(out);
        for(int i=0;i<in.length;i++){
            buff.putShort((short) in[i]);
        }
    }
    
    public static double[] stringToArray(String str){
        Scanner scn = new Scanner(str);
        scn.useLocale(Locale.ENGLISH);
        int length = 0;
        while(scn.hasNextDouble()){
            length++;
            scn.nextDouble();
        }
        scn.close();
        scn = new Scanner(str);
        scn.useLocale(Locale.ENGLISH);
        double[] array = new double[length];
        for(int i=0;i<length;i++){
            array[i] = scn.nextDouble();
        }
        return array;
    }
}
