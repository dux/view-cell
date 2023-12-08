class ViewCell
  RENDER_CACHE ||= {}

  def initialize parent=nil, vars={}
    @_parent = parent
    vars.each { |k,v| instance_variable_set "@#{k}", v}
    before
  end

  # called every time for every method in a class
  def before
  end

  # access parent scope
  def parent &block
    if block
      @_parent.instance_exec self, &block
    else
      @_parent
    end
  end

  # call
  def cell *args
    ViewCell.cell @_parent, *args
  end

  # render template by name
  def template name
    template = Pathname.new(caller[0]).dirname + name.to_s
    template = template.to_s.sub(Lux.root.to_s, '.')
    Lux::Template.render(self, template.to_s)
  end

  private

  def _development?
    ENV['RAILS_ENV'] == 'development' || ENV['RACK_ENV'] == 'development'
  end
end
