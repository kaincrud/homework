require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

def get_db
  @db = SQLite3::Database.new 'base.db'
  @db.results_as_hash = true
  return @db
end

configure do
  db = get_db
  db.execute 'CREATE TABLE IF NOT EXISTS "Users"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "email" TEXT,
      "username" TEXT,
      "charactername" TEXT,
      "back" TEXT,
      "class" TEXT,
      "race" TEXT,
      "time" TEXT,
      "color" TEXT
    )'

  db.execute 'CREATE TABLE IF NOT EXISTS "Class_Race"
    (
      "id" INTEGER PRIMARY KEY AUTOINCREMENT,
      "class" TEXT,
      "race" TEXT
    )'
  db.close
end

get '/' do
  erb 'Шалом, подорожній! Присядь до нас до вогнища і розкажи про свої найпотаємніші ДнД фантазії'
end

get '/about' do
  erb :about
end

get '/visit' do
  erb :visit
end

get '/contacts' do
  erb :contacts
end

post '/visit' do
  @email = params[:email]
  @username = params[:username]
  @charactername = params[:charactername]
  @back = params[:back]
  @class = params[:class]
  @race = params[:race]
  @time = params[:time]
  @color = params[:color]

  hh = { :email => 'Введіть пошту',
         :username => 'Введіть ПІБ',
         :charactername => 'Введіть імя персонажа',
         :back => 'Введіть опис персонажа' }


  @error = hh.select {|key,_| params[key] == ""}.values.join(", ")

  if @error != ''
    return erb :visit
  end

  def save_form_data_to_database
  db = get_db
  db.execute 'INSERT INTO Users (email, username, charactername, back, class, race, time, color)
  VALUES (?, ?, ?, ?, ?, ?, ?, ?)', [@email, @username, @charactername, @back, @class, @race, @time, @color]
  db.close
  end

  erb "Дякуємо за реєстрацію!
Дані для перевірки: пошта - #{@email}, ПІБ - #{@username}, ім'я персонажа - #{@charactername}, клас та раса - #{@class} #{@race}."
end

get '/showusers' do
  db = get_db
  @results = @db.execute 'SELECT * FROM Users ORDER BY id DESC'
  erb :showusers
end