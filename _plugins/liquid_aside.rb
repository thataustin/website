module Jekyll
  class AsideTag < Liquid::Tag

    def initialize(tag_name, text, tokens)
      super
      @text = "<aside>#{text}</aside>"
    end

    def render(context)
       "<aside style='padding: 2%; color: rgb(0, 128, 128); margin:auto 5%; background-color: rgb(240, 255, 255);'>#{context[@markup]}</aside>"
    end
  end
end

Liquid::Template.register_tag('aside', Jekyll::AsideTag)
