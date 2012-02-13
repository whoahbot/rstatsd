require 'spec_helper'

describe Rstatsd::Chart do
  describe "#title" do
    context "when no title is provided" do
      it "should specify a default title when none is given" do
        Rstatsd::Chart.new.title.should == "Chart"
      end
    end

    context "when a title is provided in the options hash" do
      it "should return the title" do
        Rstatsd::Chart.new({:title => "Grebulon chart"}).title.should == 
          "Grebulon chart"
      end
    end
  end

  describe "#width" do
    context "when no width is specified" do
      it "should default to 800" do
        Rstatsd::Chart.new.width.should == 800
      end
    end
    context "when a width is specified" do
      it "should return the specified width" do
        Rstatsd::Chart.new({:width => 400}).width.should == 400
      end
    end
  end

  describe "#height" do
    context "when no height is specified" do
      it "should default to 480" do
        Rstatsd::Chart.new.height.should == 480
      end
    end

    context "when a width is specified" do
      it "should return the specified width" do
        Rstatsd::Chart.new({:height => 580}).height.should == 580
      end
    end
  end

  describe "#column_types" do
    it "should return an array of column types and labels that describe the data" do
      Rstatsd::Chart.new({
        :column_types => [
          ['datetime', 'Timestamp'], 
          ['number', 'Grebulons consumed']
        ]
      }).column_types.should == [
        ['datetime', 'Timestamp'],
        ['number', 'Grebulons consumed']
      ]
    end
  end
end
