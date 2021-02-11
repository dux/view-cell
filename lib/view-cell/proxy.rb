class ViewCell
  # proxy loader class
  # cell.user.foo -> cell(:user).foo
  class Proxy
    def initialize parent
      @parent = parent
    end

    def method_missing cell_name, vars={}
      ViewCell.get(@parent, cell_name, vars)
    end
  end
end
