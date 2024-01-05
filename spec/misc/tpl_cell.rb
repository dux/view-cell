class TplCell < ViewCell
  template_root './spec/views/%s'

  css 'foo.scss'

  def foo
    @num = 3
    template 'tpl/base'
  end
end