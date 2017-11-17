require('pg')
require_relative('../db/sql_runner')

class Ticket

  attr_reader :id, :film_id
  attr_accessor :customer_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @film_id = options['film_id']
    @customer_id = options['customer_id'] if options['customer_id']
  end

  def save
    sql = "INSERT INTO tickets (film_id, customer_id)
    VALUES ($1,$2)
    RETURNING *"
    values = [@film_id, @customer_id]
    @id = SqlRunner.run(sql, values)[0]["id"].to_i
  end

  def self.all()
    sql = "SELECT * FROM tickets"
    values = []
    visits = SqlRunner.run(sql, values)
    result = tickets.map { |ticket| Ticket.new( visit ) }
    return result
  end

  def self.delete_all()
    sql = "DELETE FROM tickets"
    values = []
    SqlRunner.run(sql, values)
  end

  def update
    sql = "UPDATE tickets
      SET customer_id = $1,
      film_id = $2
      WHERE id = $3"
    values = [@customer_id, @film_id, @id]
    SqlRunner.run(sql, values)
  end

  def customer
    sql = "SELECT customers.* FROM customers, tickets
    WHERE tickets.customer_id = customers.id
    AND tickets.id = $1"
    values = [@id]
    customers = SqlRunner.run(sql, values)
    Customer.new(customers[0])
  end

  def film
    sql = "SELECT films.* FROM films, tickets
    WHERE tickets.id = $1
    AND tickets.film_id = films.id"
    values = [@id]
    films = SqlRunner.run(sql, values)
    Film.new(films[0])
  end


end
