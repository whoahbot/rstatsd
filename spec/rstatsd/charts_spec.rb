require 'spec_helper'

describe Rstatsd::Charts do
  describe Rstatsd::Charts::Line do
    it "should initialize with an array of data points in the form 'timestamp:value'" do
      Rstatsd::Charts::Line.new(["1:123456"]).data.should == ["1:123456"]
    end

    let!(:png_canvas) {
      PNG::Canvas = stub.as_null_object
    }

    let(:line_chart) {
      Rstatsd::Charts::Line.new(["1:123456"])
    }

    context "processing the data" do
      it "should return the chart when finished" do
        png = stub
        PNG.stub(:new).and_return(png)
        line_chart.process.should == line_chart
      end

      it "should assign the completed png to an instance variable" do
        png = stub
        PNG.stub(:new).and_return(png)
        line_chart.process
        line_chart.png.should == png
      end
    end
  end
end
