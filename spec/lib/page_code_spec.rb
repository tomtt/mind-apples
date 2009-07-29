require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe PageCode do
  it "should produce a code containing DEFAULT_SIZE characters by default" do
    PageCode.code.size.should == PageCode::DEFAULT_SIZE
  end

  it "should produce a code containing as many characters as specified" do
    PageCode.code(7).size.should == 7
  end

  it "should call the random method as many times as the size" do
    PageCode.should_receive(:rand).exactly(5).times.and_return(0)
    PageCode.code(5)
  end

  it "should use the random numbers to generate the code" do
    PageCode.should_receive(:rand).and_return(0, 1, 25, 26, 27, 51, 52, 61)
    PageCode.code(8).should == 'abzABZ09'
  end
end
