require 'bundler'
Bundler.require

class Person

  attr_reader :name, :email, :user_name, :phone_number, :cell_phone,
    :street_address, :secondary_address, :city, :zip_code, :country, :state

  def initialize
    @name = Faker::Name.name

    @street_address = Faker::Address.street_address
    @secondary_address = rand(10) == 0 ? Faker::Address.secondary_address : nil
    @city = Faker::Address.city
    @zip_code = Faker::Address.zip_code
    @state = Faker::Address.state

    # Pull request is submitted for default country.
    # Currently only available here: https://github.com/kytrinyx/faker
    @country = Faker::Address.default_country

    @email = Faker::Internet.email(name)
    @user_name = Faker::Internet.user_name(name)
    @phone_number = Faker::PhoneNumber.phone_number
    @cell_phone = Faker::PhoneNumber.cell_phone
  end

end

def an_american
  person = Person.new

  contact = []
  contact << person.name
  contact << person.street_address
  contact << person.secondary_address if person.secondary_address
  contact << "#{person.city}, #{person.state}"
  contact << "#{person.zip_code} #{person.country}"
  contact << person.country

  contact.join("\n")
end

def a_norwegian
  I18n.with_locale(:"no-nb") do
    person = Person.new

    contact = []
    contact << person.name
    contact << person.street_address
    contact << person.secondary_address if person.secondary_address
    contact << "#{person.zip_code} #{person.city}"
    contact << person.country
    contact.join("\n")
  end
end

def a_dutch_person
  I18n.with_locale(:"nl") do
    person = Person.new

    contact = []
    contact << person.name
    contact << person.street_address
    contact << person.secondary_address if person.secondary_address
    contact << "#{person.zip_code} #{person.city}"
    contact << person.country

    contact.join("\n")
  end
end

10.times { puts an_american; puts }
10.times { puts a_norwegian; puts }
10.times { puts a_dutch_person; puts }
