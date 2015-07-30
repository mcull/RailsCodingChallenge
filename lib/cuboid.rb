
class Cuboid
  attr_reader :x, :y, :z
  attr_reader :width, :height, :depth
  attr_reader :container


  #redefined origin as (x,y,z) from instructions which specified
  #(z,y,x) because the latter is non-standard, seems prone to
  #misinterpretation
  def initialize(x,y,z,depth,width,height)
    raise ArgumentError.new("Box dimensions must be positive non-zero numbers") unless (height > 0 && width > 0 && depth > 0)
    @depth = depth.to_f
    @width = width.to_f
    @height = height.to_f
    @x = x.to_f
    @y = y.to_f
    @z = z.to_f
    @container = nil
  end

  def move_to!(x,y,z)
    @x = x.to_f
    @y = y.to_f
    @z = z.to_f
  end

  def highest_plane
    @y + @height/2
  end

  def lowest_plane
    @y - @height/2
  end

  def leftmost_plane
    @x - @width/2
  end

  def rightmost_plane
    @x + @width/2
  end

  def frontmost_plane
    @z + @depth/2
  end

  def rearmost_plane
    @z - @depth/2
  end

  #I know this is verbose and could be done with pure math,
  #but I find this longhand to be more expressive--easier to
  #understand and intuit what is being tested for and why.
  #
  #For each axis, we'll examine the cases of being totally subsumed by
  #the other, totally containing the other, or partially overlapping the other
  def overlaps_in_x? (other)
    (self.leftmost_plane >= other.leftmost_plane && self.rightmost_plane <= other.rightmost_plane) || \
    (self.leftmost_plane < other.leftmost_plane && self.rightmost_plane > other.rightmost_plane) || \
    (self.leftmost_plane > other.leftmost_plane && self.leftmost_plane < other.rightmost_plane) || \
    (self.rightmost_plane > other.leftmost_plane && self.rightmost_plane < other.rightmost_plane)
  end

  def overlaps_in_y? (other)
    (self.lowest_plane >= other.lowest_plane && self.highest_plane <= other.highest_plane) || \
    (self.lowest_plane < other.lowest_plane && self.highest_plane > other.highest_plane) || \
    (self.lowest_plane > other.lowest_plane && self.lowest_plane < other.highest_plane) || \
    (self.highest_plane > other.lowest_plane && self.highest_plane < other.highest_plane)
  end

  def overlaps_in_z? (other)
    (self.rearmost_plane >= other.rearmost_plane && self.frontmost_plane <= other.frontmost_plane) || \
    (self.rearmost_plane < other.rearmost_plane && self.frontmost_plane > other.frontmost_plane) || \
    (self.rearmost_plane > other.rearmost_plane && self.rearmost_plane < other.frontmost_plane) || \
    (self.frontmost_plane > other.rearmost_plane && self.frontmost_plane < other.frontmost_plane)
  end

  def vertices
    [[leftmost_plane,highest_plane,frontmost_plane],\
    [rightmost_plane,highest_plane,frontmost_plane],\
    [rightmost_plane,lowest_plane,frontmost_plane],\
    [leftmost_plane,lowest_plane,frontmost_plane],\
    [leftmost_plane,highest_plane,rearmost_plane],\
    [rightmost_plane,highest_plane,rearmost_plane],\
    [rightmost_plane,lowest_plane,rearmost_plane],\
    [leftmost_plane,lowest_plane,rearmost_plane]]
  end


  #returns true if the two cuboids intersect each other.  False otherwise.
  def intersects?(other)
    raise ArgumentError.new("Cuboids can only evaluate other cuboids for intersection") unless (other.is_a?(Cuboid))

    self.overlaps_in_x?(other) && self.overlaps_in_y?(other) && self.overlaps_in_z?(other)
  end

  def put_inside!(bigger_cuboid)
    raise ArgumentError.new("Cuboids can only be put inside other cuboids") unless (bigger_cuboid.is_a?(Cuboid))
    raise ArgumentError.new("Cuboids can only be put inside larger boxes") unless (bigger_cuboid.height > self.height && bigger_cuboid.width > self.width && bigger_cuboid.depth > self.depth)
    raise ArgumentError.new("Cuboids can only be put inside containers they're wholly contained by") unless ((bigger_cuboid.x - self.x).abs + self.width/2 <= bigger_cuboid.width/2 && (bigger_cuboid.y - self.y).abs + self.height/2 <= bigger_cuboid.height/2 &&  (bigger_cuboid.z - self.z).abs + self.depth/2 <= bigger_cuboid.depth/2)

    @container = bigger_cuboid
  end

  def rotate!(axis)
    raise ArgumentError.new("Cuboids can only rotate in 'x','y', or 'z'") unless (axis == "x".downcase || axis == "y".downcase || axis == "z".downcase)

    is_space = true
    case axis
    when "x"
      if (@container.nil? || (@container.depth >= self.height && @container.height >= self.depth)) then
        @height,@depth = @depth,@height
      else
        is_space = false
      end
    when "y"
      if (@container.nil? || (@container.depth >= self.width && @container.width >= self.depth)) then
        @depth,@width = @width,@depth
      else
        is_space = false
      end
    when "z"
      if (@container.nil? || (@container.width >= self.height && @container.height >= self.width)) then
        @height,@width = @width,@height
      else
        is_space = false
      end
    end
    if (!is_space) then
      raise RangeError.new("The containing cuboid isn't large enough for this rotation")
    end

    #make adjustments if needed
    if (!@container.nil?) then
      x_nudge = 0
      y_nudge = 0
      z_nudge = 0
      if (self.leftmost_plane < @container.leftmost_plane) then
        x_nudge = @container.leftmost_plane - self.leftmost_plane
      elsif (self.rightmost_plane > @container.rightmost_plane) then
        x_nudge = @container.rightmost_plane - self.rightmost_plane
      end
      if (self.highest_plane < @container.highest_plane) then
        y_nudge = @container.highest_plane - self.highest_plane
      elsif (self.lowest_plane > @container.lowest_plane) then
        y_nudge = @container.lowest_plane - self.lowest_plane
      end
      if (self.rearmost_plane < @container.rearmost_plane) then
        z_nudge = @container.rearmost_plane - self.rearmost_plane
      elsif (self.frontmost_plane > @container.frontmost_plane) then
        z_nudge = @container.frontmost_plane - self.frontmost_plane
      end
      self.move_to!(@x+x_nudge,@y+y_nudge,@z+z_nudge)
    end
  end
end
