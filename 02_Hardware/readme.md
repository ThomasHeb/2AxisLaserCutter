# Hardware


![Electronic_01](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Electronic_01.JPG)

The hardware is based on Arduino Mega with display and Ramps 1.4 Board. Ramps 1.6 and similar boards will work, too.


# Modifications
- Add a 100nF C between S and GND for the X and Y limit switches
  ![Electronic_05](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Electronic_05.JPG)
- Add a 100nF C between D63 and GND for the e-stopp button
  ![Electronic_04](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Electronic_04.JPG)
- Optional: When using a back button connect the button, by soldering wires parallel to the stop button on the display, otherwise the stop button on the display operates as back button


# Blockdiagram / Connections

  ![Blockdiagram_01](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Blockdiagram_01.png)
- Stepper X-axis on E0 socket on Ramps // 1/16 Microsteps (set all three jumpers)
- Stepper Y-axis on E1 socket on Ramps // 1/16 Microsteps (set all three jumpers)
- Optional limit switch X-axis on X- S/- on Ramps (1st from left, top view)
- Optional limit switch Y-axis on X+ S/- on Ramps (2nd from left, top view)
- E-Stopp: D63 / GND
- Laser PWM input directly to D8 from Arduino (do not use Mosfet on Ramps)
- Optional: Use a DC/DC Converter with 12V Outputvoltage to supply the Arduino / Laser


