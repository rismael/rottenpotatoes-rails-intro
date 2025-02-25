class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    if params[:ratings].nil?
      @rating_filter = @all_ratings
    else
      @rating_filter = params[:ratings].keys
      session[:ratings] = params[:ratings]
    end
    @rating_filter = session[:ratings].keys unless session[:ratings].nil?
    if params[:sort_by].nil?
      @sort_by = session[:sort_by]
    else
      @sort_by = params[:sort_by]
      @hilite = params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    @movies = Movie.where(:rating => @rating_filter).order(@sort_by)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def check
    if params[:ratings]
      params[:ratings].keys
    else
      @all_ratings
    end
  end


end
