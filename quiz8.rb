# Classes as observer examples
class Car
  def initialize 
    @name = "car #{rand(10)}"
    @speed = rand(10)
  end
end


class Coupe < Car
  def initalize 
    @doors = 3
  end
end

10.times { Car.new }
5.times  { Coupe.new }



# Print all objects of classes 
# passed as arguments
class ObjectBrowser
  attr_accessor :objects

  def initialize(*classes)
    @objects = []
    if classes
      classes.each do |class_name|
        get_objects(Module.const_get(class_name)) 
      end
    else
      get_objects
    end
  end

  def get_objects(class_name = nil)
    ObjectSpace.each_object(class_name) do |object|
      @objects << object unless @objects.include?(object)
    end
  end

  def print
    @objects.each do |object|
      p "#{object.class.name} - ##{object.object_id} "
      object.instance_variables.each do |var|
        p " -- #{var} = #{object.instance_variable_get(var.to_sym)}"
      end
    end
  end
end

@browser = ObjectBrowser.new(*ARGV)
@browser.print
