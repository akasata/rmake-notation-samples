# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require 'thin'
require 'rmake-notation'

Rack::Handler.register 'Thin', 'Rack::Handler::Thin'

class SamplePlugin
  def target?(command)
    command == "version"
  end
  
  def execute(command, block)
    Rmake::Notation::VERSION.to_s
  end
end

helpers do
  def generate_contents(content)
    unless @notation
      @notation = Object.new.extend Rmake::Notation
      @notation.add_plugin(SamplePlugin.new)
    end
    
    @notation.generate_contents content
  end
end

get "/" do
  @text = ""
  open("./sample.txt") do |f|
    @text += f.read
  end
  
  erb :index
end





