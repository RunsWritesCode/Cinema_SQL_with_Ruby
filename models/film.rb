require('pg')
require_relative('../db/sql_runner')

class Film
  attr_accessor :title, :price
  attr_reader :id

  def initialize(options)
    @title = options['title']
    @price = options['price'].to_i
    @id = options['id'].to_i if options['id']
  end

  def save
    sql = "INSERT INTO films (title, price)
    VALUES ($1,$2)
    RETURNING *"
    values = [@title, @price]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def self.all()
    sql = "SELECT * FROM films"
    values = []
    films = SqlRunner.run(sql, values)
    result = films.map { |film| Films.new( visit ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM films"
    values = []
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE films
      SET title = $1, price = $2
      WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

end
