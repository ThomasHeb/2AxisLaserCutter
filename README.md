## What is new?
- project description still in process 


## What is coming next?
- Please let me know, if you have ideas or need improvements




# 2AxisLaserCutter

Arduino based CNC laser cutter with display and SD-Card.
Shared firmware with [4AxisFoamCutter](https://github.com/ThomasHeb/4AxisFoamCutter)
Ruby Script for SketchUp Make 2017 to generate gcode.

![Total_01](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/Total_01.JPG)

My goal was to build semi scale balsa glider based on old fmt plans. It is a lot of effort to copy the plans on the balsa, cut it, and sand it. Especially for small models, very accurate working is necessary. This brought my to the idea to build a laser cutter and do the glider design in SketchUp. 

The base idea ist very simple. Two independent linear axis with NEMA 17 stepper and belts on 2020/2040 v-slot rails and Arduino Mega / Ramps, based on a modified grbl 8c2, which I am using in my FoamCutter, too. There are some special requests for the grbl, when working with a laser, especially when using as an engraver. The firmware modifications will be mentioned in the „Firmware“ section below.

I have a lot old paper plans for gliders. So I take some photos of the plans, imports these to SketchUp Make 2017, redraw and scale the plan. For generating the gcode, I wrote a small script. Description is below in section „Working with SketchUp“.



# Safety
Due to the specific characteristics of laser radiation and the biological and physical effects this has, special protection and cautionary measures are required in the use of lasers.
- Do not look into the beam or direct reflections, also do not look with optical instruments.
- wear special protection googles for the laser you are using
- Clear marking of the laser area with warning signs at all access points.
- Route the laser beam clearly below or above eye level, but not at eye level.
- Refer to the manuals and safety instructions of your laser module
- Refer to the manuals and safety instructions of other used equipment (Ramps, Arduino, DC/DC Converter, power supply, …)
- Please keep all standards and safety topics in mind, when handling with high voltage on power supply, best is to contact an authorised specialist.



# Videos

ToDo



# Mechanics

- 2x linear v-slot actuator with NEMA 17 stepper
- 2020 and 2040 profiles, screws, nuts
- plates for stepper and connecting the profiles 
- Neje Laser
- 3D-printed parts for mounting the hardware on the rails

A bill of material (including hardware and electronics) and detailed photos are in the folder [01_Mechanics](https://github.com/ThomasHeb/2AxisLaserCutter/tree/main/01_Mechanic)



# Hardware

- Arduino Mega with Ramps 1.4 board
- Display and SD card reader for loacl operation

A block diagramm is provided in the folder [02_Hardware](https://github.com/ThomasHeb/2AxisLaserCutter/tree/main/02_Hardware)



# Firmware

- The Firmware is based on GRBL 8c2 
- Special modifications for local operation
- Special operation for synchron power regulation of the laser 

More Details here: [03_Firmware](https://github.com/ThomasHeb/2AxisLaserCutter/tree/main/03_Firmware)




# First operation / setup

In this chapter you find some recommendations how to get started and how to setup the laser cutter.

## First test of Arduino.
The Arduino and the Ramps board are working without the stepper driver or motors.
- Mount the Ramps on the Arduino
- Connect the display to the Ramps
- Connect the Arduino with the USB
- Connect to USB and load the firmware and check if you get a welcome screen (you need an Arduino IDE installed).

## Adjusting and first operation of stepper
- Adjust the driver [link](https://www.makerguides.com/a4988-stepper-motor-driver-arduino-tutorial/)
- Place the jumper and the stepper driver on the Ramps
- Connect the NEMA 17 stepper motor to E0 / E1
- Connect 12V DC to Ramps 3/4
- Connect the Arduino to USB. 
- Go to position menu and check the operation of the stepper motor
- Disconnect power supply and USB

## Operation of limit switches and e-stopp
- Place each a jumper on S and - for X- and X+
- Connect 12V DC to Ramps 3/4
- Optional: Pull one jumper, Arduino should go to Error. Reset the Arduino
- Optional: Pull the other jumper, Arduino should go to Error. Reset the Arduino
- Connect D68 to GND, Arduino should go to Error
- Disconnect power supply and USB

## Mechanic meets hardware
- Assemble the mechanic 
- Connect the hardware
- Do NOT connect the laser
- Wire the NEMA 17 stepper motor
- Optional: Wire the limit switches
- Wire the e-stopp
- Connect 12V DC to Ramps 3/4
- Connect the Arduino to USB. 
- Go to position menu and check movement of the axis
- Check direction of the axis, 
  - Otherwise open the parameters in the Serial Monitor of the Arduino IDE with $$
  - Adjust parameter $7
- Calculate the Steps per mm, adjust parameter $0 and $1
  - Equation is : (USER_STEP_PER_REVOLUTION x USER_MICROSTEPS) / (USER_PITCH_BELT x USER_GEAR)
  - Example: (200 steps/rpm x 16 Microsteps) / (2mm x 20) = 80
  - Best is to adjust the defaults.h, compile and download and set parameter to default with $R
- Operate the e-stopp, Arduino should go to Error. Reset the Arduino
- Optional: Operate the limit switches, Arduino should go to Error. Reset the Arduino
- Optional using limit switches: Go to homing menu and start a homing cycle. 
  - Check if axis are moving to the right direction, otherwise adjust parameter $19
- Check and adjust other parameters. refer to grbl parameter settings online.
- Disconnect power supply and USB

## First operation of the laser
- Assemble and connect the laser
- Operate alle the safety meassures / steps required, refer to the safety instructions and manuals of your laser
- Connect 12V DC to Ramps 3/4
- Go to position menu and toggle the laser dot. you should see a laser to on your table (0.2% of laser power, you can change this in defaults.h, DEFAULT_LASER_DOT, compiler run and firmware upload is required)
- adjust the focus of the lense of your laser
- Operate the e-stopp, Arduino should go to Error, laser should switch off. Reset the Arduino
- Optional: Operate the limit switches, Arduino should go to Error, laser should switch off. Reset the Arduino
- Optional using limit switches:
  - Go to position menu and toggle the laser dot on.
  - Move the laser to your preferes mechanical zero position.
  - Push the back button (stop button on display)
  - Go to homing menu and select "set as new pull-off?", committ by pushing the rotary knob
  - This position is stored and accessed with the next homing cycle

## Find best settings for the laser
- To achive good cutting results, you must find the right settings for each material type and thickness
- I recommend to start with a 2mm balsa sheet
  - Take a 1mm balsa sheet and adjust the focus of the laser in the position menu with the dot
  - Make several test cuts with different power settings and feed speeds and repeats
  - A good result is where the complete wood is cut through and corners are sharp
  - My prefered setup is 2xS40F400 (2 repeates with 40% power and a feedrate of 400mm/min), or 3xS40F500, especially when the density of the balsa is a bit higher
  - The resulting dimension is at the beginning not very important, because this can be adjusted in the design.
  - You can use the "test_01.gcode" file from the [06_Example](https://github.com/ThomasHeb/2AxisLaserCutter/tree/main/06_Example) folder (1xS15F500 is used for the text)
  - You can generate your own test pattern with SketchUp and the laser cutter skript.
    ![Test_01](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/test_01.png)
    ![Test_01a](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/test_01a.JPG)
    ![Test_01b](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/test_01b.JPG)
  
  




