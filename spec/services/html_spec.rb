require 'spec_helper'

describe Html do
  it "is instantiated with content" do
    c=fixture_file_content('simple01.html')
    h=Html.new(c)
    expect(h.title).to eq("pfarrell")
  end
end
