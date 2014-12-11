
infinity = Proc.new {|env| [200, {"Content-Type" => "text/html"}, env.inspect]}

use Rack::CommonLogger

map '/' do
  run infinity
end

map '/version' do
  map '/' do
    run Proc.new {|env| [200, {"Content-Type" => "text/html"}, "infinity 0.1"] }
  end

  map '/last' do
    run Proc.new {|env| [200, {"Content-Type" => "text/html"}, "infinity beta 0.0"] }
  end
end
