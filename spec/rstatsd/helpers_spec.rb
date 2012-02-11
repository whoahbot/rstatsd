require_relative '../../lib/rstatsd/helpers'

describe Rstatsd::Helpers do
  include Rstatsd::Helpers

  describe "#format_key" do
    it "should make underscores into spaces" do
      format_key('snozz berries').should == 'snozz_berries'
    end

    it "should make slashes into dashes" do
      format_key('snozz/berries').should == 'snozz-berries'
    end

    it "should remove non alphanumeric chars" do
      format_key('@snozzberries').should == 'snozzberries'
    end
  end
end
