module SendMessage
  class Whatsapp
    def initialize(user)
      @user = user
    end

    def execute
      "https://api.whatsapp.com/send?1=pt_BR;phone=+55#{@user.phone};text=#{message}"
    end

    def message
      "Olá #{@user.name.capitalize}, O teste deu certo viu!"
    end
  end
end