require 'spec_helper'

describe Rstatsd::Chart do
  let(:new_chart) {
    Rstatsd::Chart.new('target=crumdinglers')
  }

  describe "query string parsing" do
    context "for one chart target" do
      it "should find the data requested from the target parameters" do
        Rstatsd::Chart.new("target=crumdinglers").targets.should == ['crumdinglers']
      end
    end

    context "for multiple chart targets" do
      it "should find the data requested from the target parameters" do
        Rstatsd::Chart.new("target=crumdinglers&target=snozzblers").targets.should == ['crumdinglers', 'snozzblers']
      end
    end
  end

  describe "#title" do
    let(:new_chart) {
      Rstatsd::Chart.new('target=crumdinglers')
    }

    context "when no title is provided" do
      it "should set the default title to be the target when none is given" do
        new_chart.title.should == "Crumdinglers"
      end
    end

    context "when a title is provided in the options hash" do
      it "should return the title" do
        Rstatsd::Chart.new('target=crumdinglers&title=Number%20of%20Crumdinglers').title.should ==
          "Number of Crumdinglers"
      end
    end
  end

  describe "#width" do
    context "when no width is specified" do
      it "should default to 800" do
        new_chart.width.should == 800
      end
    end
  end

  describe "#height" do
    context "when no height is specified" do
      it "should default to 480" do
        new_chart.height.should == 480
      end
    end
  end

  describe "#column_types" do
    it "should return an array of column types and labels that describe the data" do
      new_chart.column_types.should ==
        [['datetime', 'Timestamp'],
         ['number', 'Crumdinglers']]
    end
  end
end
