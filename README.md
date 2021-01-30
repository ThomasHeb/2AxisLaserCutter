## What is new?
- project description still in process 


## What is coming next?
- Please let me know, if you have ideas or need improvements




# 2AxisLaserCutter

Arduino based CNC laser cutter with display and SD-Card.
Shared firmware with [4AxisFoamCutter](https://github.com/ThomasHeb/4AxisFoamCutter)
Ruby Script for SketchUp Make 2017 to generate gcode.


My goal was to build semi scale balsa glider based on old fmt plans. It is a lot of effort to copy the plans on the balsa, cut it, and sand it. Especially for small models, very accurate working is necessary. This brought my to the idea to build a laser cutter and do the glider design in SketchUp. 

The base idea ist very simple. Two independent linear axis with NEMA 17 stepper and belts on 2020/2040 v-slot rails and Arduino Mega / Ramps, based on a modified grbl 8c2, which I am using in my FoamCutter, too. There are some special requests for the grbl, when working with a laser, especially when using as an engraver. The firmware modifications will be mentioned in the „Firmware“ section below.

I have a lot old paper plans for gliders. So I take some photos of the plans, imports these to SketchUp Make 2017, redraw and scale the plan. For generating the gcode, I wrote a small script. Description is below in section „Working with SketchUp“.




# Videos

ToDo


# Mechanics

- 2x linear v-slot actuator with NEMA 17 stepper
- 2020 and 2040 profiles, screws, nuts
- plates for stepper and connecting the profiles 
- Neje Laser
- 3D-printed parts for mounting the hardware on the rails

A bill of material and detailed photos are in the folder [01_Mechanics](https://github.com/ThomasHeb/2AxisLaserCutter/tree/main/01_Mechanic)


