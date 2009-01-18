require 'test_helper'

class LearningTestView < ActionView::TestCase
  context "Helpers" do
    should "content_for::" do
      # Calling content_for stores a block of markup in an identifier for later
      # use. You can make subsequent calls to the stored content in other
      # templates or the layout by passing the identifier as an argument to
      # yield.
      content_for :name do
        3
      end
      assert_equal "3", @content_for_name
    end

    should "javascript_include_tag(*sources)::" do
      # Returns an HTML script tag for each of the sources provided. You can
      # pass 1-the filename (w or w/o ext), 2-the full path (relative to your
      # document root). You can modify the html attrs of the SCRIPT tag by
      # passing a hash as the last argument.

      assert_dom_equal('<script type="text/javascript" src="/javascripts/xmlhr.js"></script>',
        javascript_include_tag("xmlhr"), "No extension")
    end

    should "content_tag::content_tag(name, content_or_options_with_block = nil, options = nil, escape = true, &block)" do
      # Returns an HTML block tag of type name surrounding the content. Instead
      # of passing the content as an argument, you can also use a block in which
      # case, you pass your options as the second parameter
      assert_equal '<div class="strong"><p>Hello world!</p></div>',
          content_tag(:div, content_tag(:p, "Hello world!"), :class => "strong")
      active_item = true
      assert_equal '<div class="active">Hello World</div>',
          content_tag(:div, "Hello World", :class => ("active" if active_item ))
    end


  end
  
  context "render:: render(options = nil, extra_options = {}, &block) " do
    setup do
      class CapoeiraController < ApplicationController
        def derrubar

        end
      end
    end
    should "render action::" do
      assert_equal render(:action => 'derrubar', :layout => '/view/derrubar'), 1
    end
  end
end
