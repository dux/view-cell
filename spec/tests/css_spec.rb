require 'spec_helper'

describe ViewCell do
  it 'compiles css' do
    css = ViewCell.css
    expect(css.length).to eq(144)
  end
end