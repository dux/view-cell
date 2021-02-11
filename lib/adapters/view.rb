klass =
if defined? ActionView::Base
  ActionView::Base
elsif defined? HtmlHelper
  HtmlHelper
end

if klass
  klass.class_eval do
    def cell *args
      ViewCell.cell self, *args
    end
  end
end
