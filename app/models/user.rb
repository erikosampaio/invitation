class User < ApplicationRecord

  validates :name, presence: true
  validates :phone, presence: true
  validates :tamanho_fralda, presence: true
  validates :qtd_guest, presence: true

  before_save :set_token
  
  def message
    ::SendMessage::Whatsapp.new(self).message
  end

  def set_token
    self.token = SecureRandom.hex(10)
  end
  
  # enum answered: {
  #   not_confirmed: '0',
  #   confirmed: '1',
  #   will_not: '2'
  # }
end
