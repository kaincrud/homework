class CreateBarbers < ActiveRecord::Migration[7.0]
  def change
    create_table :barbers do |t|
      t.text :name

      t.timestamps
    end

    Barber.create :name => "Пан Зеленський"
    Barber.create :name => "Пес Патрон"
    Barber.create :name => "Залужний"
    Barber.create :name => "Арестович"

  end
end
