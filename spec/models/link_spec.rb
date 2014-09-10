require 'spec_helper'

RSpec.describe Link do
  it "has a constructor" do
    expect(Link.new).to_not be_nil
  end
end
