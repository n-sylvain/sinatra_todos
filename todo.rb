require "sinatra"
require "sinatra/reloader"
require "sinatra/content_for"
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

# Return an error message if the name is invalid. Return nil if name is valid
def error_for_list_name(name)
  if !(1..100).cover? name.size
    "List name must be between 1 and 100 characters."
  elsif session[:lists].any? { |list| list[:name] == name }
    "List name must be unique."
  end
end

# Create a new list
post "/lists" do
  list_name = params[:list_name].strip

  error = error_for_list_name(list_name)
  if error
    session[:error] = error
    erb :new_list, layout: :layout
  else
    session[:lists] << {name: list_name, todos: []}
    session[:success] = "The list has been created."
    redirect "/lists"
  end
end

get "/lists/:id" do
  id = params[:id].to_i
  @list = session[:lists][id]
  erb :list, layout: :layout
end

# Edit an existing todo list
get "/lists/:id/edit" do
  id = params[:id].to_i
  @list = session[:lists][id]
  erb :edit_list, layout: :layout
end

# Update an existing todo list
post "/lists/:id" do
  list_name = params[:list_name].strip
  id = params[:id].to_i
  @list = session[:lists][id]

  error = error_for_list_name(list_name)
  if error
    session[:error] = error
    erb :edit_list, layout: :layout
  else
    @list[:name] = list_name
    session[:success] = "The list has been updated."
    redirect "/lists/#{id}"
  end
end

# Delete a todo list
post "/lists/:id/destroy" do
  id = params[:id].to_i
  session[:lists].delete_at(id)
  session[:success] = "The list has been deleted."
  redirect "/lists"
end
