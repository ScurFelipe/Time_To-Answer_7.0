namespace :dev do

DEFAULT_PASSWORD = 123456
DEFAULT_FILE_PATH = File.join(Rails.root, 'lib', 'tmp')


  desc "Configura o ambiente de desenvolvimento"
  task setup: :environment do
    if Rails.env.development?
      show_spinner("Drop data base...") { %x(rails db:drop) }      
      show_spinner("Create data base...") { %x(rails db:create) }
      show_spinner("Migrate data base...") { %x(rails db:migrate) }
      # show_spinner("Populating data base") { %x(rails db:seed) }
      show_spinner("Registering the default administrator") { %x(rails dev:add_default_admin) }
      show_spinner("Registering extras administrators") { %x(rails dev:add_extras_admins) }
      show_spinner("Registering the default user") { %x(rails dev:add_default_user) }
      show_spinner("Registering the default subjects") { %x(rails dev:add_subjects) }
      show_spinner("Registering the questions and answer") { %x(rails dev:add_answers_and_questions) }
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

  desc "Adiciona assuntos padrões"
  task add_subjects: :environment do
    file_name = 'subjects.txt'
    file_path = File.join(DEFAULT_FILE_PATH, file_name)

    File.open(file_path, 'r').each do |line|
      Subject.create!(description: line.strip)
    end
  end

  desc "Adiciona perguntas e respostas"
  task add_answers_and_questions: :environment do
    Subject.all.each do |subject|
      rand(5..10).times do |i|
        Question.create!(
          description: "#{Faker::Lorem.paragraph} #{Faker::Lorem.question}",
          subject: subject
        )
      end
    end
  end



private
  def show_spinner(msg_start, msg_end = "Done!")
    spinner = TTY::Spinner.new("[:spinner] #{msg_start}")
    spinner.auto_spin
    yield
    spinner.success("(#{msg_end})")
  end
end
