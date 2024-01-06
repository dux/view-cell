require 'spec_helper'

class FooCell < ViewCell
  css %[
    .foo1 {
      .bar {
        font-weight: bold;
      }
    }
  ]
  
  css %[
    .bold { font-weight: bold; }
  ]
end

class BarCell < ViewCell
  css %[
    .bar {
      .baz {
        font-weight: bold;
      }
    }
  ]
end

describe 'css' do
  it 'compiles' do
    css = ViewCell.css
    expect(css.length).to eq(142)
  end
end