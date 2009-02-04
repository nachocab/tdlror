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

  context "Dispatcher" do
    should "dispatch" do
      ENV['REQUEST_URI'] = "/blog/index"
      ENV['REQUEST_METHOD'] = 'get'
#      response = Dispatcher.dispatch
    end
  end

  #  context "render:: render(options = nil, extra_options = {}, &block) " do
#    setup do
#      class CapoeiraController < ApplicationController; end
#    end
#    should "render action::" do
#      assert_equal render(:action => 'derrubar', :layout => '/view/derrubar'), 1
#    end
#  end
end

#require 'test_helper'
#include ActionController::MimeResponds
## #require 'action_controller'
#require 'net/http'
#
#
#
#  context "Dispatcher" do
#    should "dispatch" do
#      ENV['REQUEST_URI'] = "/blog/index"
#      ENV['REQUEST_METHOD'] = 'get'
#      #      response = Dispatcher.dispatch
#    end
#  end
#
#  context "Action Controller" do
#    setup do
##      class MyController < ApplicationController; end
##      @controller = MyController.new
##      url = URI.parse('http://localhost:3000/index.js')
##      @controller.request = Net::HTTP::Get.new(url.path)
##      @controller.response = Net::HTTP.start(url.host, url.port) {|http|
##        http.request(@controller.request)
##      }
#    end
#    should "respond_to" do
#      # action_controller/mime_responds.rb
#      #
#      # Can be called in two ways:
#      #  1) Passing it a list of types to respond to:
#
##      @controller.respond_to(:js)
#
#      # 2) Passing it a block.
#      #            respond_to do |format|
#      #              format.js
#      #            end
#      #
#      # In both cases it creates a new Responder from the current Controller and
#      # we call the :js method on it. Method missing generates a new method for
#      # the mime-type (if it's valid) which calls custom(). Custom() sets up a
#      # block to assign the template_format for each mime-type and do one of two
#      # things:
#      #  - 1) If a block was given after format.js, it calls it
#      #  - 2) Otherwise it will execute the default action: render :action => 'whatever'
#
#      # Then, respond() calls the proc setup by custom()
#    end
#
#    should "render action:: render:: render(options = nil, extra_options = {}, &block) " do
#      # action_controller/base.rb
##      assert_equal @controller.send(:render, :action => 'derrubar', :layout => '/view/derrubar'), 1
#    end
#  end
