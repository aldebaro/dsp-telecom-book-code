package main;

import filter.Filter;
import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.Dimension;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Scanner;
import javax.swing.BorderFactory;
import javax.swing.JButton;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

import sound.SoundFilter;
import sound.Util;

/**
 *
 * @author Yuichi
 */
public class View extends JPanel{
    
    protected JButton start;
    protected JButton stop;
    protected JButton changeFilter;
    protected JTextField b;
    protected JTextField a;
    protected JPanel buttonPanel;
    protected JPanel coeffPanel;
    
    protected SoundFilter soundFilter;
    
    public View(SoundFilter sf){
        super();
        this.setLayout(new BorderLayout());
        
        buttonPanel = new JPanel();
        buttonPanel.setPreferredSize(new Dimension(200,75));
        coeffPanel = new JPanel();
        coeffPanel.setPreferredSize(new Dimension(400,200));
        add(buttonPanel, BorderLayout.SOUTH);
        add(coeffPanel, BorderLayout.CENTER);
        
        setBorder(BorderFactory.createLineBorder(Color.BLACK));
        setPreferredSize(new Dimension(800,200));
        this.soundFilter = sf;
        start = new JButton("Start");
        start.setEnabled(true);
        stop = new JButton("Stop");
        stop.setEnabled(false);
        b = new JTextField("1", 50);
        a = new JTextField("1", 50);
        changeFilter = new JButton("Change filter");
        
        start.addActionListener(new ActionListener(){
            @Override
            public void actionPerformed(ActionEvent e) {
                start.setEnabled(false);
                stop.setEnabled(true);
                soundFilter.start();
            }
        });
        stop.addActionListener(new ActionListener(){
            @Override
            public void actionPerformed(ActionEvent e) {
                stop.setEnabled(false);
                start.setEnabled(true);
                soundFilter.stop();
            }
        });
        changeFilter.addActionListener(new ActionListener(){
            @Override
            public void actionPerformed(ActionEvent e) {
                String bStr = b.getText();
                String aStr = a.getText();
                double[] bArray;
                double[] aArray;
                try{
                    bArray = Util.stringToArray(bStr);
                    aArray = Util.stringToArray(aStr);
                    soundFilter.setProcessor(new Filter(bArray,aArray));
                }
                catch(Exception exc){
                    JOptionPane.showMessageDialog(null, exc);
                }
                
            }
        });
        buttonPanel.add(start);
        buttonPanel.add(stop);
        coeffPanel.add(b);
        coeffPanel.add(a);
        buttonPanel.add(changeFilter);
    }
}
