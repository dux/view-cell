require 'spec_helper'

describe ViewCell do
  let!(:user) { User.new 'Dux', 'dux@net.net' }

  it 'can call plain function' do
    num = UserCell.new.sq 4
    expect(num).to eq 16
  end

  it 'resoves before filters well' do
    num = UserCell.new.numbers
    expect(num).to eq '123-456'
  end

  it 'raises render error' do
    expect { UserCell.new.not_found }.to raise_error ArgumentError
  end

  it 'renders template with parent instance variables' do
    @user = user
    data  = UserCell.new(self).profile
    expect(data).to eq 'foo Dux bar'
  end

  it 'can deleate functions to parent scope' do
    # user object is parent scope!
    data = UserCell.new(user).uemail
    expect(data).to eq 'dux@net.net'
  end
end