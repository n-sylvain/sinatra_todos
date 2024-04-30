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
  # [
  #   {name: "Lunch Groceries", todos: []},
  #   {name: "Dinner Groceries", todos: []}
  # ]
  @lists = session[:lists]
  erb :lists, layout: :layout
end

set :session_secret, SecureRandom.hex(32)

get "/lists/new" do
  # session[:lists] << { name: "New List", todos: [] }
  # redirect "/lists"
  erb :new_list, layout: :layout

end

post "/lists" do
  session[:lists] << {name: params[:list_name], todos: []}
  redirect "/lists"
end
