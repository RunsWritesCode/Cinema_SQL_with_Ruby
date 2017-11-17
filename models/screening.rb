require('pg')
require_relative('../db/sql_runner')

class Screening

  attr_reader :id, :film_id, :num_seats,

  def initialize(options)
    @film_id = options['film_id']
    @num_seats = options['num_seats']
    @id = options['id'].to_i if options['id']
  end

end
