class User < ApplicationRecord

  validates :name, presence: true
  validates :phone, presence: true
  validates :tamanho_fralda, presence: true

  before_save :set_token_and_phone
  
  def message
    ::SendMessage::Whatsapp.new(self).message
  end

  def set_token_and_phone
    self.token = SecureRandom.hex(10)
    self.phone = self.phone.gsub(/[^0-9]/, '')
  end
  
  # enum answered: {
  #   not_confirmed: '0',
  #   confirmed: '1',
  #   will_not: '2'
  # }
end
