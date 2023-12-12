module SendMessage
  class Whatsapp
    def initialize(user)
      @user = user
    end

    def execute
      "https://api.whatsapp.com/send?1=pt_BR;phone=+55#{@user.phone};text=#{message}"
    end

    def message
      "Percebemos que ainda não confirmou sua presença. Precisamos da sua confirmação para organizar o evento.

      Link de confirmação: #{invite_url}

      Esperamos te ver lá!

      Atenciosamente,

      Nayara e Ériko Sampaio."
    end

    private
    def root_url
      "https://invitation-2.fly.dev/"
    end

    def invite_url
      "https://invitation-2.fly.dev/users/new_response_invitation?token=#{@user.token}"
    end
  end
end