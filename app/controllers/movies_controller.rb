class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
      
    # will render app/views/movies/show.<extension> by default
  end
  
  def movie
    return @all_ratings
  end
  
  
  def index
    
      @all_ratings = ['G','PG','PG-13','R']
      
    if params[:ratings] 
      @ratings = params[:ratings]
    elsif session[:ratings] 
      @ratings = session[:ratings]
        
    else
      @ratings = @all_ratings
    end
      
      #byebug
      
      
      sort = params[:sort_by]
      
      
      
      if sort == "title"
         @movies = Movie.all.order(title: :asc)
         @hilite = "hilite"
      elsif sort == "date"
        @movies = Movie.all.order(release_date: :asc)
        @hilite_data = "hilite"
      elsif @ratings !=nil
          @movies = Movie.all.select{|m|@ratings.include?(m.rating)}
        else
          @movies = Movie.all
          session[:sort_by]= sort
          
          end
     #debugger
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
