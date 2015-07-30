require 'cuboid'


describe Cuboid do

  describe "#initialize" do
    context "given impossible dimensions" do
      it "raises an argument error" do
        expect { Cuboid.new 0,0,0,5,-1,0 }.to raise_error(ArgumentError)
      end
    end
    context "given good dimensions" do
      it "initializes without complaint" do
        expect { Cuboid.new 0,0,0,1,1,1 }.not_to raise_error
      end
    end
  end

  describe "#move_to!" do
    before do
      @cuboid = Cuboid.new 0,0,0,5,2,3
      @cuboid.move_to!(1,2,3)
    end

    describe "cuboid" do
      it "has a new origin at 1,2,3" do
        expect(@cuboid.x).to eql(1.0)
        expect(@cuboid.y).to eql(2.0)
        expect(@cuboid.z).to eql(3.0)
      end
    end
    #it "changes the origin in the simple happy case" do
    #  expect(subject.move_to!(1,2,3)).to be true
    #end
  end

  describe "#intersects?" do
    before do
      @small_cuboid = Cuboid.new 0,0,0,1,1,1
      @another_small_cuboid = Cuboid.new 0,0,0,1,1,1
      @large_subsuming_cuboid = Cuboid.new 0,0,0,10,10,10
      @small_subsumed_cuboid = Cuboid.new 0,0,0,0.1,0.1,0.1

    end
    context "given something that isn't another cuboid to evaluate" do
      it "raises an argument error" do
        expect { @small_cuboid.intersects? ("some that ain't a cuboid") }.to raise_error(ArgumentError)
      end
    end
    context "given another cuboid to evaluate" do
      it "no argument error is raised" do
        expect { @small_cuboid.intersects? (@another_small_cuboid) }.not_to raise_error
      end
    end

    context "given another cuboid in the exact same spot" do
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a containing cuboid" do
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@large_subsuming_cuboid)).to eq true
      end
    end

    context "given a fully contained cuboid" do
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@small_subsumed_cuboid)).to eq true
      end
    end

    context "given another cuboid very far away" do
      before do
        @another_small_cuboid.move_to! 1000,1000,1000
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a left-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! -1,0,0
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a right-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 1,0,0
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a top-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 0,1,0
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a bottom-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 0,-1,0
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a front-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 0,0,1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a rear-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 0,0,-1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a left-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! -0.5,0,0
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a right-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0.5,0,0
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a top-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0,0.5,0
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a bottom-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0,-0.5,0
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a front-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0,0,0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a rear-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0,0,-0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a top-right-front corner-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 1,1,1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a bottom-right-front corner-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 1,-1,1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a top-left-front corner-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! -1,1,1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a bottom-left-front corner-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! -1,-1,1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a top-left-back corner-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! -1,1,-1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a bottom-left-back corner-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! -1,-1,-1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a top-right-back corner-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 1,1,-1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a bottom-right-back corner-adjacent cuboid" do
      before do
        @another_small_cuboid.move_to! 1,-1,-1
      end
      it "reports intersects? is false" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq false
      end
    end

    context "given a top-right-front corner-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0.5,0.5,0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a bottom-right-front corner-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0.5,-0.5,0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a top-left-front corner-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! -0.5,0.5,0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a bottom-left-front corner-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! -0.5,-0.5,0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a top-left-back corner-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! -0.5,0.5,-0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a bottom-left-back corner-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! -0.5,-0.5,-0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a top-right-back corner-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0.5,0.5,-0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end

    context "given a bottom-right-back corner-overlapping cuboid" do
      before do
        @another_small_cuboid.move_to! 0.5,-0.5,-0.5
      end
      it "reports intersects? is true" do
        expect(@small_cuboid.intersects? (@another_small_cuboid)).to eq true
      end
    end
  end

  describe "#vertices" do
    before do
      @small_cuboid = Cuboid.new 0,0,0,1,1,1
      @vertices = @small_cuboid.vertices
    end
    context "fetching vertices as array of coordinates" do
      it "should accurately express vertices" do
        expect(@vertices[0]).to  match_array([-0.5,0.5,0.5])
        expect(@vertices[1]).to  match_array([0.5,0.5,0.5])
        expect(@vertices[2]).to  match_array([0.5,-0.5,0.5])
        expect(@vertices[3]).to  match_array([-0.5,-0.5,0.5])
        expect(@vertices[4]).to  match_array([-0.5,0.5,-0.5])
        expect(@vertices[5]).to  match_array([0.5,0.5,-0.5])
        expect(@vertices[6]).to  match_array([0.5,-0.5,-0.5])
        expect(@vertices[7]).to  match_array([-0.5,-0.5,-0.5])
      end
    end
  end

  describe "#put_inside!" do
    before do
      @small_cuboid = Cuboid.new 0,0,0,1,1,1
      @big_enough_cuboid = Cuboid.new 0,0,0,10,10,10
      @not_big_enough_cuboid = Cuboid.new 0,0,0,10,20,0.5
    end
    context "putting a cuboid in a larger cuboid" do
      it "should not raise an exception" do
        expect { @small_cuboid.put_inside! (@big_enough_cuboid) }.not_to raise_error()
      end
    end

    context "putting a cuboid in a larger cuboid that's far away" do
      before do
        @big_enough_cuboid.move_to!(50,50,50)
      end
      it "should raise an ArgumentError" do
        expect { @small_cuboid.put_inside! (@big_enough_cuboid) }.to raise_error(ArgumentError)
      end
    end

    #(bigger_cuboid.x - self.x).abs + self.width/2 <= bigger_cuboid.width/2
    context "putting a cuboid in a larger cuboid that's involves one or more plane intersecting" do
      before do
        @big_enough_cuboid.move_to!(5,0,0)
      end
      it "should raise an ArgumentError" do
        expect { @small_cuboid.put_inside! (@big_enough_cuboid) }.to raise_error(ArgumentError)
      end
    end

    context "putting a cuboid in a not-larger cuboid" do
      it "should raise an exception" do
        expect { @small_cuboid.put_inside! (@not_big_enough_cuboid) }.to raise_error(ArgumentError)
      end
    end
  end

  describe "#rotate!" do
    before do
      @rectangle = Cuboid.new 0,0,0,5,1,3
    end

    context "trying to rotate around something that's not a 3D axis ('x','y' or 'z')" do
      it "should raise an exception" do
        expect { @rectangle.rotate! ("b") }.to raise_error(ArgumentError)
      end
    end

    context "before rotation" do
      it "should have depth of 5 and width of 1 and height of 3" do
        expect(@rectangle.depth).to eql(5.0)
        expect(@rectangle.width).to eql(1.0)
        expect(@rectangle.height).to eql(3.0)
      end
    end
    context "after rotating about x axis" do
      before do
        @rectangle.rotate! ("x")
      end
      it "should have depth of 3 and width of 1 and height of 5" do
        expect(@rectangle.depth).to eql(3.0)
        expect(@rectangle.width).to eql(1.0)
        expect(@rectangle.height).to eql(5.0)
      end
    end
    context "after rotating on y axis" do
      before do
        @rectangle.rotate! ("y")
      end
      it "should have depth of 1 and width of 3 and height of 5" do
        expect(@rectangle.depth).to eql(1.0)
        expect(@rectangle.width).to eql(5.0)
        expect(@rectangle.height).to eql(3.0)
      end
    end
    context "after rotating on z axis" do
      before do
        @rectangle.rotate! ("z")
      end
      it "should have depth of 5 and width of 1 and height of 5" do
        expect(@rectangle.depth).to eql(5.0)
        expect(@rectangle.width).to eql(3.0)
        expect(@rectangle.height).to eql(1.0)
      end
    end

    context "rotating in a container too small to rotate" do
      before do
        @rectangle.put_inside! (Cuboid.new 0,0,0,5.1,1.1,3.1)
      end
      it "should raise a RangeError" do
        expect{ @rectangle.rotate! ("z") }.to raise_error(RangeError)
      end
    end

    context "rotating in a container large enough to rotate" do
      before do
        @rectangle.put_inside! (Cuboid.new 0,0,0,50,10,30)
      end
      it "should not raise a RangeError" do
        expect{ @rectangle.rotate! ("z") }.not_to raise_error
      end
    end

    context "rotating in a big enough container near its edge" do
      before do
        @rectangle.put_inside! (Cuboid.new 0,0,0,50,10,30)
        @rectangle.move_to!(-4.5,0,0) #should be against the left wall now
        @rectangle.rotate!("z") #should force some x_nudge as the rotation would move it out of the box
      end
      it "should move so it's fully contained again" do
        expect(@rectangle.x).to eql(-3.5)
      end
    end

  end
end
