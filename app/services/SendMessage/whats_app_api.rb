TOKEN = 'q51bc4b96y09tfjn'

require 'uri'
require 'net/http'
require 'openssl'

module SendMessage
  class WhatsAppApi
    def initialize(user)
      @base_url = 'https://api.ultramsg.com/instance70753/messages/'
      @token = TOKEN
      @user = user
    end

    def send_package_message
      return_text_message = send_message('chat', phone_number, "body=#{body_message}")
      return_image_message = send_message('image', phone_number, "image=#{image_url}&caption=#{caption}")

      if return_text_message['error'] && return_image_message['error']
        return { 'error' => "Erro ao enviar convite digital. Erro: #{return_text_message['error']}" }
      end
      
      if return_text_message['error'] || return_image_message['error']
        if return_text_message['error']
          return { 'error' => "Imagem enviada com sucesso. Erro ao enviar mensagem de texto. Erro: #{return_text_message['error']}" }
        end
        
        return { 'error' => "Mensagem enviada com sucesso. Erro ao enviar imagem. Erro: #{return_image_message['error']}" }
      else
        return { 'success' => 'Usuário criado com sucesso. Convite digital enviado.' }
      end
    end

    def resend_package_message
      return_text_message = send_message('chat', phone_number, "body=#{body_resend_message}")
      return_image_message = send_message('image', phone_number, "image=#{image_url}&caption=#{caption}")

      if return_text_message['error'] && return_image_message['error']
        return { 'error' => "Erro ao enviar convite digital. Erro: #{return_text_message['error']}" }
      end
      
      if return_text_message['error'] || return_image_message['error']
        if return_text_message['error']
          return { 'error' => "Imagem enviada com sucesso. Erro ao enviar mensagem de texto. Erro: #{return_text_message['error']}" }
        end
        
        return { 'error' => "Mensagem enviada com sucesso. Erro ao enviar imagem. Erro: #{return_image_message['error']}" }
      else
        return { 'success' => 'Usuário criado com sucesso. Convite digital enviado.' }
      end
    end

    def trigger_package_message
      return_text_message = send_message('chat', phone_number, "body=#{body_trigger_message}")
      return_image_message = send_message('image', phone_number, "image=#{image_url}&caption=#{caption}")

      if return_text_message['error'] && return_image_message['error']
        return { 'error' => "Erro ao enviar convite digital. Erro: #{return_text_message['error']}" }
      end
      
      if return_text_message['error'] || return_image_message['error']
        if return_text_message['error']
          return { 'error' => "Imagem enviada com sucesso. Erro ao enviar mensagem de texto. Erro: #{return_text_message['error']}" }
        end
        
        return { 'error' => "Mensagem enviada com sucesso. Erro ao enviar imagem. Erro: #{return_image_message['error']}" }
      else
        return { 'success' => 'Usuário criado com sucesso. Convite digital enviado.' }
      end
    end
  
    def send_text_message
      send_message('chat', phone_number, "body=#{body_message}")
    end
  
    def send_image_message
      send_message('image', phone_number, "image=#{image_url}&caption=#{caption}")
    end
  
    private
    def phone_number
      "+55" + @user.phone
    end

    def body_message
      <<~MSG
      Oi #{@user.name.capitalize.titleize},

      Gostaríamos de convidar você para o chá de fraldas do nosso bebê Abner. O evento será no dia 13/01/2023, a partir das 17h. Sua presença é muito importante para nós.

      Mesmo que não possa comparecer, agradecemos se puder confirmar sua resposta no link abaixo. Isso nos ajudará na organização do evento.

      Link de confirmação: #{invite_url}

      *Sugestão de fraldas:* _Huggies Pacote Vermelho, Pampers, Pompom, Mamypoko, Milly e Needs._
      
      *Sugestão de mimos:* _Kit de higiene, roupinhas, meias coloridas, mantas e cobertores, cesta de banho etc._

      Até breve!

      Atenciosamente,
      Nayara e Ériko Sampaio.
    MSG
    end

    def body_resend_message
      <<~MSG
      Oi #{@user.name.capitalize.titleize},

      Percebemos que não confirmou ainda sua presença no chá de fralda do nosso Abner.

      A confirmação pode ser feita até dia 08/01/2023 - 23:59h. Não deixa de nos responder. Agradecemos muito!

      Link de confirmação: #{invite_url}

      *Sugestão de fraldas:* _Huggies Pacote Vermelho, Pampers, Pompom, Mamypoko, Milly e Needs._
      
      *Sugestão de mimos:* _Kit de higiene, roupinhas, meias coloridas, mantas e cobertores, cesta de banho etc._

      Até breve!

      Atenciosamente,
      Nayara e Ériko Sampaio.
    MSG
    end

    def body_trigger_message
      <<~MSG
      É HOOOOOOOOOOOOOOOJEEEEEEEEEEEEEEE!

      O chá de fraldas do nosso Abner será hoje, a partir das 17h. Estamos muito felizes e ansiosos para te ver.

      Já estamos com tudo pronto para te receber.

      Até Mais tarde!

      Atenciosamente,
      Nayara e Ériko Sampaio.
    MSG
    end

    def root_url
      "https://invitation-2.fly.dev/"
    end

    def invite_url
      "https://invitation-2.fly.dev/users/new_response_invitation?token=#{@user.token}"
    end

    def caption
      "Convite Digital"
    end

    def image_url
      if @user.tamanho_fralda == "M"
        "https://uploaddeimagens.com.br/images/004/688/621/original/convite_m.jpg?1702381924"
      else
        "https://uploaddeimagens.com.br/images/004/688/624/original/convite_g.jpg?1702382005"
      end
    end

    def send_message(type, to, body_params)
      url = URI("#{@base_url}#{type}")
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  
      request = Net::HTTP::Post.new(url)
      request["content-type"] = 'application/x-www-form-urlencoded'
      request.body = "token=#{@token}&to=#{to}&#{body_params}&referenceId="
  
      response = http.request(request)
      
      JSON.parse(response.read_body)
    end
  end
end
