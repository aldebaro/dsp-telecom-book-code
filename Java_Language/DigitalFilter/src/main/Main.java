package main;

import filter.Filter;
import java.awt.Dimension;
import javax.sound.sampled.LineUnavailableException;
import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.SwingUtilities;
import sound.SoundFilter;

/**
 *
 * @author Yuichi
 */
public class Main {
    public static void main(String[] args) throws LineUnavailableException{
        final JFrame frame = new JFrame("Digital Filter");
        SwingUtilities.invokeLater(new Runnable(){
            @Override
            public void run() {
                frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
                frame.setPreferredSize(new Dimension(800,200));
            }
        
        });
        
        double[] b = {1};
        double[] a = {1};
        Filter f = new Filter(b,a);
        final SoundFilter sf = new SoundFilter(f);
        final View v = new View(sf);
        SwingUtilities.invokeLater(new Runnable(){

            @Override
            public void run() {
                frame.add(v);
                frame.pack();
                frame.setLocationRelativeTo(null);
                frame.setVisible(true);
            }
        
        });
        
    }
}
