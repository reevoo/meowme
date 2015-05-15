require "sinatra"
require "yaml"
require "set"
require "json"

configure do
  set :cats, YAML.load(open(File.expand_path("assets/cats.yml", __dir__)))
  set :cute, YAML.load(open(File.expand_path("assets/cute.yml", __dir__)))
end

def random(count = 5, type)
  pics = Set.new
  pics << settings.public_send(type).sample while pics.size < count
  pics
end

[:cats, :cute].each do |type|
  get "/#{type}/bomb" do
    content_type :json
    count = Integer(params[:count] || 5)
    { cats: random(count, type).to_a }.to_json
  end

  get "/#{type}/random" do
    content_type :json
    { cat: random(1, type).first }.to_json
  end

  get "/#{type}/count" do
    content_type :json
    { cat_count: settings.public_send(type).size }.to_json
  end
end
