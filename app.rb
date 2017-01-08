require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/flash'
require_relative 'config/application'

set :bind, '0.0.0.0'  # bind to all interfaces

enable :sessions

configure :development, :test do
  require 'pry'
end

configure do
  set :views, 'app/views'
end

Dir[File.join(File.dirname(__FILE__), 'app', '**', '*.rb')].each do |file|
  require file
  also_reload file
end

helpers do
  def current_user
    if @current_user.nil? && session[:user_id]
      @current_user = User.find_by(id: session[:user_id])
      session[:user_id] = nil unless @current_user
    end
    @current_user
  end
end

get '/' do
  redirect '/meetups'
end

get '/auth/github/callback' do
  user = User.find_or_create_from_omniauth(env['omniauth.auth'])
  session[:user_id] = user.id
  flash[:notice] = "You're now signed in as #{user.username}!"

  redirect '/'
end

get '/sign_out' do
  session[:user_id] = nil
  flash[:notice] = "You have been signed out."

  redirect '/'
end

get '/meetups' do
  @meetups = (Meetup.all).order(name: :asc)
  erb :'meetups/index'
end

get '/meetups/create' do
  if session[:user_id] == nil
    flash[:notice] = "You must sign in first."
    redirect '/'
  else
    erb :'meetups/create'
  end
end

post '/meetups/create' do
  @id = current_user.id
  @meetup_name = params['meetup_name']
  @meetup_description = params['meetup_description']
  @meetup_location = params['meetup_location']
  if @meetup_name == '' || @meetup_location == '' || @meetup_description == ''
    @error = ''
    if @meetup_name == ''
      @error += 'Please supply a Meetup Name. '
      erb :'/meetups/create'
    end
    if @meetup_location == ''
      @error += 'Please supply a Meetup Location. '
      erb :'/meetups/create'
    end
    if @meetup_description == ''
      @error += 'Please supply a Meetup Description. '
      erb :'/meetups/create'
    end
  else
    Meetup.create(creator_id: @id, name: @meetup_name, location: @meetup_location, description: @meetup_description)
    flash[:notice] = "Meetup created successfully"
    redirect '/meetups/' + Meetup.last.id.to_s
  end
end

get '/meetups/edit/:id' do
  @meetup = Meetup.find(params[:id])
  erb :'/meetups/edit'
end

post '/meetups/edit/:id' do
  @meetup = Meetup.find(params[:id])
  @meetup_name = params['meetup_name']
  @meetup_description = params['meetup_description']
  @meetup_location = params['meetup_location']

  if @meetup_name == '' || @meetup_location == '' || @meetup_description == ''
    @error = ''
    if @meetup_name == ''
      @error += 'Please supply a Meetup Name. '
    end
    if @meetup_location == ''
      @error += 'Please supply a Meetup Location. '
    end
    if @meetup_description == ''
      @error += 'Please supply a Meetup Description. '
    end
    erb :'/meetups/edit'
  else
    @meetup.name = params['meetup_name']
    @meetup.location = params['meetup_location']
    @meetup.description = params['meetup_description']
    @meetup.save
    redirect '/meetups/' + params[:id].to_s
  end
end

get '/meetups/cancel/:id' do
  @meetup = Meetup.find(params[:id])
  erb :'meetups/cancel'
end

post '/meetups/cancel/:id' do
  Signup.where(meetup_id: params[:id]).delete_all
  Meetup.where(id: params[:id]).delete_all
  redirect '/'
end

post '/meetups/comment/:id' do
  @id = params[:id]
  @user_id = current_user.id
  if params['meetup_comment'] == ''
    flash[:notice] = "Please supply text for your comment"
    redirect '/meetups/' + @id.to_s
  else
    Comment.create(user: current_user, body: params['meetup_comment'], meetup: Meetup.find(@id))
    redirect '/meetups/' + @id.to_s
  end
end

post '/meetups/:id/delete' do
  @id = params[:id]
  @meetup_id = Comment.where(id: @id).first.meetup.id
  @user = current_user
  Comment.where(id: @id).delete_all
  redirect '/meetups/' + @meetup_id.to_s
end

get '/meetups/:id' do
  @meetup = Meetup.find(params[:id])
  @user = current_user
  erb :'meetups/show'
end

post '/meetups/:id' do
  @id = params[:id]
  if session[:user_id] == nil
    flash[:notice] = "You must sign in first."
    redirect '/meetups/' + @id.to_s
  else
    @user_id = current_user.id
    if Meetup.find(@id).signups.where(user_id: @user_id) == []
      Signup.create(meetup_id: @id, user_id: @user_id)
      flash[:notice] = "You are now signed up for this event"
      redirect '/meetups/' + @id.to_s
    else
      Signup.where(meetup_id: @id, user_id: @user_id).delete_all
      flash[:notice] = "Sign up cancelled"
      redirect '/meetups/' + @id.to_s
    end
  end
end
