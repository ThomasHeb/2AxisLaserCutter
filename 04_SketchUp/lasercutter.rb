#to_a wandelt in ein array um


@@version = 'v1.0.0'

require 'sketchup'
require 'io/console'                                                                                                       
 
@configKeys = [\
               #"cutDiamiter",\
               "decimalPlaces",\
               "units",\
               "labelXAxis",\
               "labelYAxis",\
               "laserPower",\
               "feedSpeed",\
               "repeat"] 
@config = {}

# Load configuration from persistent storage into @config hashmap.
def loadConfig()
  defaultValue = {\
                  #"cutDiamiter" => "0.10",\
                  "decimalPlaces" => "3",\
                  "units" => "mm",\
                  "labelXAxis" => "X",\
                  "labelYAxis" => "Y",\
                  "laserPower" => "50",\
                  "feedSpeed"  => "100",\
                  "repeat"  => "1"}

  @configKeys.each do | key |
    value = Sketchup.read_default('dla_laser_cutter_rb', key)
    puts("load: #{key} #{value}")
    if value == nil
      value = defaultValue[key]
    end
    @config[key] = value
  end
end

# Reset config to default values.
def clearConfig()
  @config.each do |key, value|
    result = Sketchup.write_default('dla_laser_cutter_rb', key,  nil)
    puts("clear: #{key} #{result}")
  end
end

# Save entries in @config to persistent storage.
def saveConfig()
  @config.each do |key, value|
    result = Sketchup.write_default('dla_laser_cutter_rb', key,  value)
    puts("save: #{key}, #{value}, #{result}")
  end
end

 

# Set values in the @config hashmap.
def menu()
  configDescriptions = {\
                        #"cutDiamiter" => "Durchmesser Hotwire (mm)",\
                        "decimalPlaces" => "Digits for GCode",\
                        "units" => "Units for GCode",\
                        "labelXAxis" => "Label Horizontal",\
                        "labelYAxis" => "Label Vertical",\
                        "laserPower" => "Laser Power %",\
                        "feedSpeed"  => "Feed Speed mm/min",\
                        "repeat"  => "No Repeats"}
  #sizes = "0.00|"\
  #        "0.01|0.02|0.03|0.04|0.05|0.06|0.07|0.08|0.09|0.10|"\
  #        "0.11|0.12|0.13|0.14|0.15|0.16|0.17|0.18|0.19|0.20|"\
  #        "0.21|0.22|0.23|0.24|0.25|0.26|0.27|0.28|0.29|0.30|"\
  #        "0.31|0.32|0.33|0.34|0.35|0.36|0.37|0.38|0.39|0.40|"\
  #        "0.41|0.42|0.43|0.44|0.45|0.46|0.47|0.48|0.49|0.50"
  menuOptions = {\
                 #"cutDiamiter" => sizes,\
                 "decimalPlaces" => "0|1|2|3|4",\
                 "units" => "mm|inch",\
                 "labelXAxis" => "X|Y|Z|U|W|A",\
                 "labelYAxis" => "X|Y|Z|U|W|A",\
                 "laserPower" => "5|10|15|20|25|30|35|40|45|50|55|60|65|70|75|80|85|90|95|100",\
                 "feedSpeed" => "50|100|150|200|250|300|350|400|450|500|550|600|650|700|750|800|850|900|950|1000",\
                 "repeat"  => "1|2|3|4|5|6|7|8|9|10"}
         
  descriptions = []
  values = []
  options = []
  
  @configKeys.each do | key |
    descriptions.push(configDescriptions[key])
    values.push(@config[key])
    options.push(menuOptions[key])
  end
 
  input = UI.inputbox descriptions, values, options, "Gcode options."

  if input
    for x in 0..(input.size - 1)
      key = @configKeys[x]
      @config[key] = input[x]
      puts("menu: #{key} #{input[x]}")
    end
    return true
  end
end 


# Round floats down to a sane number of decimal places.
def roundToPlaces(value, places, units)
  if units == "mm"
    value = value.to_mm
  end
  places = places.to_i
  #puts("places #{places}")
  returnVal = value.round(places)
  return returnVal
end

# Add a menu for Settings
if (not $fcSettingsLoaded)
  puts("Load Settings menu")
  UI.menu("Plugins").add_item("LaserCutter Settings") {
    loadConfig()
    if menu()
      saveConfig()
    end
  }
  $fcSettingsLoaded = true
end

class String
  def isFloat?
    Float(self) != nil rescue false
  end
end


# Add a menu for Tool
#$fcToolLoaded = false
if (not $fcToolLoaded)
  puts("Load Tool  menu")
  UI.menu("Plugins").add_item("LaserCutter Tool") {
    loadConfig()
    cutter = LaserCutter.new
    cutter.labelX = @config["labelXAxis"]
    cutter.labelY = @config["labelYAxis"]
    cutter.places = @config["decimalPlaces"]
    cutter.units = @config["units"]
    cutter.feedSpeed = @config["feedSpeed"]
    cutter.laserPower = @config["laserPower"]
    cutter.repeat = @config["repeat"]
    cutter.start
  }
  $fcToolLoaded = true
end

class LaserCutter
  def labelX=(z)
    @labelX = z
  end
  def labelX
    @labelX
  end
  def labelY=(z)
    @labelY = z
  end
  def labelY
    @labelY
  end
  def places=(z)
    @places = z
  end
  def places
    @places
  end
  def units=(z)
    @units = z
  end
  def units
    @units
  end
  def feedSpeed=(z)
    @feedSpeed = z
  end
  def feedSpeed
    @feedSpeed
  end
  def laserPower=(z)
    @laserPower = z
  end
  def laserPower
    @laserPower
  end
  def repeat=(z)
    @repeat = z
  end
  def repeat
    @repeat
  end
  
  def closeTool
      puts("close")
      return true
  end

  # 1. reset the tool
  def start
      puts("reset")
      
      model = Sketchup.active_model
      @selection = model.selection
      
      if (@selection.empty?)
        puts("no elements selected")
        UI.messagebox('Please select elements first')
      else
        puts("elements selected")
        generateGCode()
        
      end
      closeTool()
  end
  
  
  
  def edgesContain(edges, edge)
    edges.each do |e|
      if (e == edge)
        return true
      end
    end
    return false
  end
  
  def generateGCode()
    puts("generate gcode")
    
    #copy all edges from selection or copy all surrounting edges from face
    edges = []
    @selection.each do |s|
      if (s.is_a? Sketchup::Edge)
        if (edgesContain(edges, s) == false)
            edges.push(s)
        end
      end
      if (s.is_a? Sketchup::Face)
        puts("found face")
        s.edges.each do |e|
          if (edgesContain(edges, e) == false)
            edges.push(e)
          end
        end
      end
    end
    
    #check if edges are available
    if (edges.empty?)
      UI.messagebox('No edges selected')
      return
    end
    
    #selectiere nur die edges
    model = Sketchup.active_model
    model.selection.clear
    model.selection.add(edges)
    
    x = 0
    y = 0
    
    #switch the laser of
    laser = false
    
    file = UI.savepanel "GCode File", "c:\\", "default.gcode"
    if file
      outputfile = File.new( file , "w" )
      puts("G17")
      puts("G94")
      puts("M5")
      puts("G90F#{feedSpeed}S#{laserPower}") 
      outputfile.puts("G17")
      outputfile.puts("G94")
      outputfile.puts("M5")
      outputfile.puts("G90F#{feedSpeed}S#{laserPower}") 
       #goto 0,0
      x = roundToPlaces(0, places, units)
      y = roundToPlaces(0, places, units)
      puts("G0#{labelX}#{x}#{labelY}#{y}")
      outputfile.puts("G0#{labelX}#{x}#{labelY}#{y}")
      
      puts("M3S0")
      outputfile.puts("M3S0")
            
      point = Geom::Point3d.new
      point.x = x
      point.y = y
      
      backupEdges = edges
      i = 0
      
      while i < repeat.to_i
        i = i + 1
        #restore the complete edges to be cut
        edges = backupEdges
        while edges.count > 0
          #find related edge to point
          edge = edgeToPoint(edges, point)
          if (edge == nil)
            #switch the laser off
            #if (laser == true)
            #  puts("M5")
            #  outputfile.puts("M5")
            #end
            laser = false
            
            #select point from next edge
            point = edges.first.start
            #move to point, switch laser off
            x = roundToPlaces(point.position.x, places, units)
            y = roundToPlaces(point.position.y, places, units)
            puts("G0S0#{labelX}#{x}#{labelY}#{y}")
            outputfile.puts("G0S0#{labelX}#{x}#{labelY}#{y}")

          else
            #switch the laser on
            #if (laser == false)
            #  puts("M3")
            #  outputfile.puts("M3")
            #end
            laser = true
            #move to next point, with activated laser
            point = edge.other_vertex point
            x = roundToPlaces(point.position.x, places, units)
            y = roundToPlaces(point.position.y, places, units)
            puts("G1S#{laserPower}#{labelX}#{x}#{labelY}#{y}")
            outputfile.puts("G1S#{laserPower}#{labelX}#{x}#{labelY}#{y}")

            #remove edge from edges array
            edges = remove(edges, edge)
          end
        end
      end
      
      #laser off
      puts("M5")
      outputfile.puts("M5")
      puts("G0#{labelX}0#{labelY}0")
      outputfile.puts("G0#{labelX}0#{labelY}0")
      outputfile.close
   
      UI.messagebox('Ready')
    end
  end
  
  def edgeToPoint(edges, point)
    edges.each do |e|
      if (e.used_by? point)
        return e
      end
    end
    return nil
  end
  
  def remove(edges, edge)
    newEdges = []
    edges.each do |e|
      if (e != edge)
        newEdges.push(e)
      end
    end
    return newEdges
  end
  
 
end







