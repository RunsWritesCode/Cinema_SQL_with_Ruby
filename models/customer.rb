require('pg')
require_relative('../db/sql_runner')

class Customer
  attr_accessor :name, :funds, :id

  def initialize(options)
    @name = options['name']
    @funds = options['funds'].to_i
    @id = options['id'].to_i if options['id']
  end

  def save
    sql = "INSERT INTO customers (name, funds)
    VALUES ($1,$2)
    RETURNING *"
    values = [@name, @funds]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def self.all()
    sql = "SELECT * FROM customers"
    values = []
    customers = SqlRunner.run(sql, values)
    result = customers.map { |customer| Customer.new( customer ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM customers"
    values = []
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE customers
    SET name = $1, funds = $2
    WHERE id = $3"
    values = [@name, @funds, @id]
    SqlRunner.run(sql, values)
  end

  def buy_ticket(film)
    if sufficient_funds?(film.price)
      Ticket.new({'film_id' => film.id, 'customer_id' => @id}).save
      @funds -= film.price()
    end
    update
  end

  def sufficient_funds?(price)
    return price <= @funds
  end

  def films()
    sql = "SELECT films.* FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    INNER JOIN films
    ON tickets.film_id = films.id"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map {|film| Film.new( film )}
  end

  def films_booked()
    sql = "SELECT * FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    INNER JOIN films
    ON tickets.film_id = films.id"
    values = [@id]
    films = SqlRunner.run(sql, values)
    return films.map {|film| Film.new( film )}
  end

end
