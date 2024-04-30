require "sinatra"
require "sinatra/reloader"
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

before do
  session[:lists] ||= []
end

get "/" do
  redirect "/lists"
end

get "/lists" do
  @lists = session[:lists]
  # [
  #   {name: "Lunch Groceries", todos: []},
  #   {name: "Dinner Groceries", todos: []}
  # ]
  erb :lists, layout: :layout
end

set :session_secret, SecureRandom.hex(32)

get "/lists/new" do
  session[:lists] << { name: "New List", todos: [] }
  redirect "/lists"
end
