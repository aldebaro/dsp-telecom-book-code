/** Example of reading and writing binary (float) files.*/
import java.io.*;

public class FileManipulation {

  public static void main(String[] args) {
	String fileName = "floatsamples.bin";
	float[] x = {-2,-1,0,1,2};
	writeVectorToBinaryFile(fileName, x);
	float[] y = readVectorFromBinaryFile(fileName);
	System.out.println("Samples obtained from file:");
	for (int i=0;i<y.length;i++) {
		System.out.print(y[i] + " ");
	}
	System.out.println("\nFinished writing and reading "+ fileName);
  }

  /** Method to write a binary file*/
  public static void writeVectorToBinaryFile(String fileName,
                                             float[] vector) {
    try {
      File file = new File(fileName);
      FileOutputStream fileOutputStream = new FileOutputStream(file);
      DataOutputStream dataOutputStream = new DataOutputStream(fileOutputStream);
      //create a small header with the number of samples
      dataOutputStream.writeShort( (short) vector.length);
      for (int i = 0; i < vector.length; i++) {
        dataOutputStream.writeFloat(vector[i]);
      }
      dataOutputStream.close();
      fileOutputStream.close();
    }
    catch (IOException e) {
      e.printStackTrace();
      System.err.println("Problem writing file " + fileName);
    }
  }

  /** Method to read a binary file*/
  public static float[] readVectorFromBinaryFile(String fileName) {
    float[] x = null;
    try {
      File file = new File(fileName);
      FileInputStream fileInputStream = new FileInputStream(file);
      DataInputStream dataInputStream = new DataInputStream(fileInputStream);
      //read the number of samples (in header)
      int numSamples = (int) dataInputStream.readShort();
      x = new float[numSamples];
      for (int i = 0; i < numSamples; i++) {
          x[i] = dataInputStream.readFloat();
      }
      fileInputStream.close();
    }
    catch (IOException e) {
      e.printStackTrace();
      System.err.println("Problem reading file " + fileName);
    }
    return x;
  }

}