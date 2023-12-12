class User < ApplicationRecord

  validates :name, presence: true
  validates :phone, presence: true
  validates :tamanho_fralda, presence: true
  validates :responsavel, presence: true
  validates :qtd_guest, presence: true

  before_save :set_token
  
  def message
    ::SendMessage::Whatsapp.new(self).message
  end

  def set_token
    self.token = SecureRandom.hex(10)
  end

  def format_phone
    # Remove caracteres não numéricos
    telefone = self.phone.gsub(/\D/, '')

    # Verifica se o número de telefone tem o formato desejado
    if telefone.match?(/^\d{2}\d{5}\d{4}$/)
      # Formata o número de telefone no padrão (xx) xxxxx-xxxx
      telefone_formatado = "(#{telefone[0..1]}) #{telefone[2..6]}-#{telefone[7..10]}"
      return telefone_formatado
    else
      # Caso o número não atenda ao formato desejado
      return nil
    end
  end
  
  # enum answered: {
  #   not_confirmed: '0',
  #   confirmed: '1',
  #   will_not: '2'
  # }
end
