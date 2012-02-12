require 'spec_helper'

describe Rstatsd::Charts do
  describe Rstatsd::Charts::Line do
    it "should initialize with an array of data points in the form ['timestamp:value']" do
      Rstatsd::Charts::Line.new([["123456:1"]]).data.should == [["123456:1"]]
    end


    let(:line_chart) {
      Rstatsd::Charts::Line.new([["123456:1"]])
    }

    context "returning the completed chart" do
      it "should return a completed png" do
        completed_chart = stub
        PNG.stub(:new).and_return(stub(:to_blob => completed_chart))
        line_chart.to_png.should == completed_chart
      end
    end
  end
end
