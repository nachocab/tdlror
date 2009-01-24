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
