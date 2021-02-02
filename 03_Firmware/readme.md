# Firmware
The firmware is based on the grbl version 8c2 modified for foam cutter and laser cutter. 
A modified version of U8G2 library for the display and SdFat for SD card reader is used.

Links to the original 
- [grbl 8c2 foam](https://www.rcgroups.com/forums/showthread.php?2915801-4-Axis-Hot-Wire-CNC-%28Arduino-Ramps1-4%29-Complete-Solution)
- [U8G2 Lib by Oli Kraus, tested with version 2.27.6](https://github.com/olikraus/u8g2)
- [SdFat by Bill Greiman, tested with version 1.2.3](https://github.com/greiman/SdFat)

Many thanks to you, for writing and sharing this fantastic code.

The firmware is a common project with [4 Axis Foam Cutter](https://github.com/ThomasHeb/4AxisFoamCutter).
Download the git from [4 Axis Foam Cutter](https://github.com/ThomasHeb/4AxisFoamCutter) and use the firmware / librarys from the subfolder 


### Major changes to FoamCutter firmware
- Tool syncronisation a spindle or a hotwire is not very fast... it needs time to reach target rpm or target temperature
  - A spindle or a hotwire is not very fast... it needs time to reach target rpm or target temperature
  - So tool commands are not synchronised with grbl line execution, because you normally start the tool with M3 followed with a pause G4P3. The pause command will synchronise the execution.
  - Using a laser requires laser synchronisation with movement within one gcode line, (especially if you are working with different shades)
  - Tool synchronisation is included for Laser and Foam Cutter. You should still use pause commands for Foam Cutter to give some time to heat up. Laser Cutter operates gcode by switching on the laser with M3 and controlling it’s power wir S0…100 in each gcode line. 
  - power control during ac/deceleration is not implemented yet. So good settings for grbl is fast ac/deceleration, medium speed (400 - 600 mm/min are tested), and medium laser power.
- E-stopp is always active / other buttons are not supported
  - Laser cutter has only two axis and manual operation of the laser is a safety issue.
  - Position menu is operated with knob and back button (marked as stop on display) only.
  - Laser can not be operated manually, only a focusing dot is available in position menu.
  - E-stopp on pin D63 is always active - it does not match the standards for safety! Please ensure additional measure, i.e interrupting main power supply.
  - Other buttons are not implemented
- Common tool control
  - implementation of hotwire is moved to tool to offer common tool control interface (hotwire and laser use same interface)
- Compiler switches
  - Select the version LASER_CUTTER in config.h file
  - Separated default settings in defaults.h.


### How to install:
- Download the firmware / library from [4 Axis Foam Cutter](https://github.com/ThomasHeb/4AxisFoamCutter)
- Install (Copy!) the libraries from /03_Firmware/libraries directly in your ../Arduino/libraries/ folder (prefered, because updates of the original libraries may cause problems with grbl)
- You may delete other versions of this libraries first
- Select the version LASER_CUTTER in config.h file
- Compile and download.

![compiler_01](https://github.com/ThomasHeb/2AxisLaserCutter/blob/main/img/compiler_01.png)
  

### Changes within the library U8G2 - only for information:
Grbl uses almost all resources of the Arduino to control the stepper within an accurate timing. So the standard approach of Arduino is not working any more, because some resources are not available anymore for the Arduino framework. Within the U8G2 I use a software driven SPI on pin D50 to D52 (I didn’t check, if hardware driven SPI would work, too). The only thing I needed to change, was the required delay within the SPI. Therefore I changed the delay function to the grbl supported delay function.


### LCD, SD card and buttons, ….
The LCD display, rotary knob and back buttons (marked as stop on the display)  are controlled inside the lcd.h and lcd.cpp. Knob and button are read within the lcd_process(), from where all processing functions of the sub menus are called.
Functions within the sub menus, which are related to cnc functionality are called as if they would have been called via UART/USB. So you will get an ok over the UART/USB for a local called cnc command, too. The firmware can still be controlled with gcode sender tools via the UART/USB.
SD card is processed inside lcd.cpp and lcd_process(), too. Processing of the SD card is handled with a state machine, which reads the selected file char by char, similar as reading the UART. 
During processing a file from SD card, button are ignored, operation can only be stopped with an IRQ of the limit switches or the e-stop.

Please have a lock at the parameters (command $$ over Serial Monitor)
Information of how to get started are [HERE](https://github.com/ThomasHeb/2AxisLaserCutter#first-operation--setup).
Please search the web for more detailed grbl parameter settings.


### Functions on local display / buttons
- e-stop: IRQ based local stop, this does not match the requirements of any safety standard.
- Idle stepper
- Homing (only available if limit switches are used)
  - homing including pull-off
  - set current position as new pull off position: This function is used to travel from limit switches to machine zero position. Adjust the position with the position menu
- Position menu
  - adjust each axis independent
  - set or travel to a temporary home position
  - set or travel to a temporary zero position
  - select the axis and step size with the knob. By pressing the knob, you can move the axis by rotationg the knob.
  - toggle the laser point (by default 0,2% of maximum power, see defaults.h, DEFAULT_LASER_DOT). You can use this to focus the laser. 
- SD-Card
  - read file list from SD-Card (only with defined file extensions (config.h), only from root directory, keep filenames short)
  - valid gcode file extensions: .nc, .gcode (you may change the file extension to oneof these)
  - execute a file from the SD-Card
  - visualise the progress (bytes read and send to gcode processing, not bytes really executed)
- The firmware can still be controlled with gcode sender tools via the UART/USB 


### How to start:
Please refer to grbl documentation for parameter settings and first steps. A good point to start is shown [HERE](https://github.com/ThomasHeb/2AxisLaserCutter#first-operation--setup)




[Back to main page](https://github.com/ThomasHeb/2AxisLaserCutter)


