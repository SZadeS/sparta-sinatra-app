class CarsController < Sinatra::Base
  set :root, File.join(File.dirname(__FILE__), '..')
  set :views, Proc.new { File.join(root, "views") }
  configure :development do
    register Sinatra::Reloader
  end

helpers Sinatra:: Cookies
enable :Sessions

# INDEX
get "/" do
  unless cookies[:visited]
    @show_message = true
    response.set_cookie(:visited,:value=>1, :expires => Time.now+(10))
  end
  @title = "Cars available"#{Joe, where is this @title linked?}
  @cars = Car.all
  erb :"cars/index"
end

# NEW
get "/new" do
  car = Car.new
  @car = car
   car.id = ""
   car.make = ""
   car.description = ""
  erb :"cars/new"
end


# SHOW
get "/:id" do
  id = params[:id].to_i
  if(!session[:cars])
    session[:cars] = []
  end
  if (!session[:cars].include?(id))
    session[:cars].push(id)
  end
  puts "The user has visited #{session[:cars]}"
  @car = Car.find(id)
  erb :"cars/show"
end

# CREATE
post "/" do
  car = Car.new

  car.make = params[:make]
  car.description = params[:description]

  car.save

  redirect "/"
end

# EDIT
get "/:id/edit" do
  id = params[:id].to_i
  @car = Car.find(id)
  erb :"cars/edit"
  # am i missing the line to add the edited version to index page? eg car = edited car
  # redirect "/"
end

# UPDATE
put "/:id" do
  id = params[:id].to_i
  car = Car.find(id)
  car.make = params[:make]
  car.description = params[:description]

  car.save

  redirect "/"
end

# DESTROY
delete "/:id" do
  # get the ID
  id = params[:id].to_i
  # delete the post from the database
  Car.destroy(id)
  # redirect back to the homepage
  #is there any in-built quick method to ask 'are you sure?'
  redirect "/"
end

end
