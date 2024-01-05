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