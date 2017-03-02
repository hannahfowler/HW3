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
    @ratings = params[:ratings]
    if @ratings.respond_to?(:keys)
      @ratings = @ratings.keys
    else
      @ratings = @all_ratings
    end
    flash[:notice] = @ratings
  
    if params[:sortby] == 'title'
      @title_hilite = 'hilite'
      @movies = Movie.order(:title).all
    elsif params[:sortby] == 'release_date'
      @rel_hilite = 'hilite'
      @movies = Movie.order(:release_date).all
    else
      @movies = Movie.all
    end
    
    @movies = @movies.where("rating IN (?)", @ratings)
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

end
