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

# GET  /lists     -> view all lists
# GET  /lists/new -> new list form
# POST /lists     -> create new list
# GET  /lists/1   -> view a single list
# GET  /users
# GET  /users/1

# View list of lists
get "/lists" do
  # [
  #   {name: "Lunch Groceries", todos: []},
  #   {name: "Dinner Groceries", todos: []}
  # ]
  @lists = session[:lists]
  erb :lists, layout: :layout
end

set :session_secret, SecureRandom.hex(32)

# Render the new list form
get "/lists/new" do
  # session[:lists] << { name: "New List", todos: [] }
  # redirect "/lists"
  erb :new_list, layout: :layout

end

# Create a new list
post "/lists" do
  session[:lists] << {name: params[:list_name], todos: []}
  redirect "/lists"
end
