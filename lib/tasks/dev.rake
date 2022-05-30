namespace :dev do

DEFAULT_PASSWORD = 123456

  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Drop data base...") { %x(rails db:drop) }      
      show_spinner("Create data base...") { %x(rails db:create) }
      show_spinner("Migrate data base...") { %x(rails db:migrate) }
      # show_spinner("Populating data base") { %x(rails db:seed) }
      show_spinner("Registering the default administrator") { %x(rails dev:add_default_admin) }
      show_spinner("Registering  extras administrators") { %x(rails dev:add_extras_admins) }
      show_spinner("Registering the default user") { %x(rails dev:add_default_user) }
    else
      puts "Você não está em ambiente de desenvolvimento"
    end
  end

  desc "Adciona o administrador padrão"
  task add_default_admin: :environment do
    Admin.create!(
      email: 'admin@admin.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

  desc "Adciona o administrador extras"
  task add_extras_admins: :environment do
    10.times do |i|
      Admin.create!(
        email: Faker::Internet.email,
        password: DEFAULT_PASSWORD,
        password_confirmation: DEFAULT_PASSWORD
      )
    end
  end



  desc "Adciona o usuário padrão"
  task add_default_user: :environment do
    User.create!(
      email: 'user@user.com',
      password: DEFAULT_PASSWORD,
      password_confirmation: DEFAULT_PASSWORD
    )
  end

private
  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
