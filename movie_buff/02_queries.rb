def eighties_b_movies
  # List all the movies from 1980-1989 with scores falling between 3 and 5
  # (inclusive). Show the id, title, year, and score.
  Movie.where(score: 3.0..5.0)
       .where('yr BETWEEN 1980 AND 1989')
       .select(:id, :title, :yr, :score)
end

def bad_years
  # List the years in which no movie with a rating above 8 was released.
  Movie.group(:yr).having('MAX(score) < 8.0').pluck(:yr)

end

def cast_list(title)
  # List all the actors for a particular movie, given the title.
  # Sort the results by starring order (ord). Show the actor id and name.
  # Movie.joins(:actors).where(title: title).order('castings.ord DESC').pluck(actor:[:id, :name])
  Actor.joins(:movies)
       .where('movies.title = (?)', title)
       .order('castings.ord')
       .select(:id, :name)

end

def vanity_projects
  # List the title of all movies in which the director also appeared as the
  # starring actor. Show the movie id, title, and director's name.

  # Note: Directors appear in the 'actors' table.
  Movie.joins(:actors)
       .joins(:director)
       .where('castings.ord = 1')
       .where('castings.actor_id = movies.director_id')
       .select('movies.id, movies.title, actors.name')

end

def most_supportive
  # Find the two actors with the largest number of non-starring roles.
  # Show each actor's id, name, and number of supporting roles.
  Actor.joins(:castings)
       .where('castings.ord > 1')
       .group(:id, :name)
       .select('actors.id, actors.name, COUNT(*) as roles')
       .order(Arel.sql('COUNT(*) DESC'))
       .order(:name)
       .limit(2)

end
