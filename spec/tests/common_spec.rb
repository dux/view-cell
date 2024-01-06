require 'spec_helper'

###

User = Struct.new :name, :email

class AppCell < ViewCell
  before do
    @numbers = [123]
  end

  css %[
    .foo {
      .bar {
        font-weight: bold;
      }
    }
  ]
end

class UserCell < AppCell
  delegate :email

  template_root './spec/misc'
  
  css 'css/user.scss'

  def before
    super
    @numbers.push 456
  end

  def sq num
    num * num
  end

  def numbers
    @numbers.join '-'
  end

  def profile
    @user = parent { @user }
    template :profile
  end

  def profiles
    @users = [User.new('dux', 'dux@net'), User.new('foo', 'foo@net')]
    template 'profiles'
  end

  def not_found
    template :not_found
  end

  def uemail
    email
  end

  def render user
    '>%s<' % user.name
  end
end

###

describe 'common' do
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

  it 'renders template with variable lists' do
    data  = UserCell.new.profiles
    expect(data).to eq 'x >dux<>foo< x >dux< x'
  end

  it 'can deleate functions to parent scope' do
    # user object is parent scope!
    data = UserCell.new(user).uemail
    expect(data).to eq 'dux@net.net'
  end
end