module UsersHelper
  def confirmed_presence?(user)
    if user.answered == '0' and !user.confirmed.present?
      "Ainda não"
    elsif user.answered == '1' and user.confirmed.present?
      "Confirmado"
    else
      "Não vai"
    end
  end

  def action(action)
    if action == 'new'
      "Criar"
    else
      "Atualizar"
    end
  end
end
