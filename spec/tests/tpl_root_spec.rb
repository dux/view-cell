require 'spec_helper'

describe ViewCell do
  before do
    TplCell.template_root './spec/views'
  end
  
  it 'compiles css defined in custom template root' do
    css = TplCell.css
    expect(css.length).to eq(144)
  end

  it 'compiles template defined in custom template root' do
    data = TplCell.new.foo
    expect(data).to eq('x9x')
  end
end