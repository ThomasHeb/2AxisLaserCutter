# Hardware


![Electronic_01](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Electronic_01.JPG)

The hardware is based on Arduino Mega with display and Ramps 1.4 Board. Ramps 1.6 and similar boards will work, too.




# Modifications
- Add a 100nF C between S and GND for the X and Y limit switches
  ![Electronic_05](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Electronic_05.JPG)
- Add a 100nF C between D63 and GND for the e-stopp button
  ![Electronic_04](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Electronic_04.JPG)
  
  
- Optional: When using an external back button, connect the button by soldering wires parallel to the stop button on the display, otherwise the stop button on the display operates as back button.





# Blockdiagram / Connections

  ![Blockdiagram_01](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Blockdiagram_01.png)
- Stepper X-axis on E0 socket on Ramps // 1/16 Microsteps (set all three jumpers)
- Stepper Y-axis on E1 socket on Ramps // 1/16 Microsteps (set all three jumpers)
- Optional limit switch X-axis on X- S/- on Ramps (1st from left, top view)
- Optional limit switch Y-axis on X+ S/- on Ramps (2nd from left, top view)
- E-Stopp: D63 / GND
- Laser PWM: directly to D8 from Arduino 
  For Neje Laser: Do not use the MOSFET on Ramps / Do not use connect the laser to the terminal screws. Refer to user manual of your laser!
  On Arduino Pin D8 a PWM Signal is available to control the laser. You may connect the laser directly or with a small amplifier to that pin. Please refer to Arduino Mega / Ramps schematic / pcb layout.
- Optional: Use a DC/DC Converter with 12V output voltage to supply the Arduino / Laser
- Power supply:
  - You may use any power supply, such as laboratory power supply, to operate the setup.
  - Optional: DC/DC Converter to have a stabilised fixed voltage (I use this supply, because I have many machines operating with up to 30V. So even when I connect a 30V power supply, everything is operating fine, because of internal DC/DC regulation). You can set the output voltage to any voltage between 9…17V (operation voltage for Arduino and Ramps/Stepper), as long as it fits to your laser, too. My Neje laser operates with 12V as shown in the block diagram.   - The block diagram above shows my favourite setup with a single power connection for my external laboratory supply, a DC/DC converter to supply the laser and the Arduino. Typical less than 2,5 A are required.


    
  - This block diagram shows an external power supply to operate the laser with a different voltage level as for the Arduino. The DC/DC converter supply the Arduino. Advantage is that you still have only one external power supply. Be aware, for Neje laser Arduino and laser must have the same ground level, please connect GND of the laser to GND of Arduino, too. Be aware that changing the voltage level for the laser may regulate it’s power, too. This means you have to adjust your settings (refer to First operation / setup). The block diagram shows a laser operating at app. 30 VDC
  ![Blockdiagram_02](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Blockdiagram_02.png)


    
    
    
  - This block diagram shows the operation with two different power supplies. One is set to 9….17V DC to supply the Arduino. The other operates the laser. Be aware, for Neje laser Arduino and laser must have the same ground level, please connect GND of the laser to GND of Arduino, too. Be aware that changing the voltage level for the laser may regulate it’s power, too. This means you have to adjust your settings (refer to First operation / setup).
  ![Blockdiagram_03](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Blockdiagram_03.png)




[Back to main page](https://github.com/ThomasHeb/2AxisLaserCutter)

