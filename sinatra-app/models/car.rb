class Car
  attr_accessor :id, :name, :make, :description

  def self.open_connection
    make_conn = PG.connect(dbname: "catalogue", user: "postgres", password: "limewires123")
  end

  def self.all
    make_conn = self.open_connection

    sql = "SELECT * FROM car ORDER BY id"

    connected = make_conn.exec(sql)

    cars = connected.map do |data|
      self.hydrate data
    end
    return cars
  end

  def self.hydrate car_data
    car = Car.new

    car.id = car_data["id"]
    car.name = car_data["name"]
    car.make = car_data["make"]
    car.description = car_data["description"]

    return car
  end

  def self.find id
    make_conn = self.open_connection

    sql = "SELECT * FROM car WHERE id = #{id}"

    cars = make_conn.exec(sql)

    return self.hydrate cars[0]
  end

  def save
    make_conn = Car.open_connection

    if !self.id
      sql = "INSERT INTO car (make, description) VALUES ('#{self.make}', '#{self.description}')"
    else
      sql = "UPDATE car SET make='#{self.make}', description='#{self.description}' WHERE id = #{self.id}"
    end
    make_conn.exec(sql)
  end

  def self.destroy id
    make_conn = self.open_connection

    sql = "DELETE FROM car WHERE id = #{id}"

    make_conn.exec(sql)
  end
end
