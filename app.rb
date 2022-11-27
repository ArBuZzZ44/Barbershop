#encoding: utf-8
require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'
require 'sqlite3'

configure do
  @db = SQLite3::Database.new 'barbershop.db'
  @db.execute 'CREATE TABLE if not exists 
  	"Users" 
  	(
  		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
  		"username" VARCHAR,
  		"phone" VARCHAR,
  		"datestamp" VARCHAR,
  		"barber" VARCHAR,
  		"color" VARCHAR
  	)'

end


get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"			
end

get '/About' do
	@error = 'something!!!'
	erb :about
end

get '/Visit' do 
	erb :visit
end

get '/Contacts' do 
	erb :contacts
end

post '/Visit' do
	@username = params[:username]
	@phone = params[:phone]
	@date = params[:date]
	@barber = params[:barber]
	@color = params[:colorpicker]

	hh = {username: 'Введите имя',
	 	 phone:'Введите телефон',
	  	 date:'Введите дату и время'}
	hh.each do |key, value|
		if params[key] == ''
			@error = hh[key]
			return erb :visit
		end
	end

	# @error = hh.select{|key,_| params[key] == ''}.values.join(", ") - еще один способ валидации
	# if @error != '' erb :visit

	@title = 'Спасибо!'
	@message = "Уважаемый #{@username}, мы будем ждать вас в #{@date}, мастер: #{@barber}, цвет: #{@color}"


	f = File.open './public/users.txt', 'a'
	f.write "Имя: #{@username}, номер телефона: #{@phone}, дата и время: #{@date}, мастер: #{@barber}, цвет: #{@color} \n"
	f.close

	 erb :message
end

post '/Contacts' do 
	@mail = params[:mail]
	@blank = params[:blank]

	hh = {mail: 'Введите почтовый адрес',
		blank: 'Введите сообщение'}

	hh.each do |key, value|
		if params[key] == ''
			@error = hh[key]
			return erb :contacts
		end
	end
	

	f = File.open './public/contacts.txt', 'a'
	f.write "E-mail: #{@mail}\nСообщение: #{@blank}\n"
	f.close

	@title = 'Мы приняли ваше сообщение'
	@message = 'Постараемся с вами связаться по вашему вопросу как можно скорее'

	erb :message
end
