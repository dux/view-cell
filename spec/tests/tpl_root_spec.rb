require 'spec_helper'

###

class TplCell < ViewCell
  template_root './spec/views/%s'

  css 'foo.scss'

  def foo
    @num = 3
    template 'tpl/base'
  end
end

###

describe 'tpl' do
  before do
    TplCell.template_root './spec/views'
  end
  
  it 'compiles css defined in custom template root' do
    css = TplCell.css
    expect(css.length).to eq(53)
  end

  it 'compiles template defined in custom template root' do
    data = TplCell.new.foo
    expect(data).to eq('x9x')
  end

  it 'compiles template defined in custom template root' do
    TplCell.template_root './spec/x_views'
    expect { TplCell.new.foo }.to raise_error(ArgumentError, %[Template "./spec/x_views/tpl/base.*" not found])
  end
end