#!/usr/bin/env ruby
require 'rack'

class Page
  attr_accessor :body
  def initialize(body="")
    @body = body
  end
  def add(line)
    @body = "#{@body}#{line}"
  end
end

class Server
  def initialize
    @html_head   = '<!doctype html><html><head><meta charset="utf-8"></head><body>',
    @html_tail   = '</body></html>'
    @http_header = { 'Content-type' => 'text/html' }
    @http_code   = '200'
    @page        = Page.new
  end
  def call(env)
    @page.body = "<h1>hello</h1><table>"
    env.each_pair { |k,v| @page.add("<tr><td>#{k}</td><td>#{v}</td></tr>") }
    @page.add("</table>")
    puts @page.body.class
    [@http_code, @http_header, [html]]
  end
  def html
    "#{@html_head}#{@page.body}#{@html_tail}"
  end
end

Rack::Handler::WEBrick.run Server.new, :Port => 8000

