module UsersHelper
  def confirmed_presence?(user)
    if user.answered == '0' and !user.confirmed.present?
      "Ainda não"
    elsif user.answered == '1' and user.confirmed.present?
      "Sim"
    else
      "Não vai"
    end
  end

  def verify_invited(user)
    if user.confirmed.present? || (!user.confirmed.present? && user.answered == '2')
      user.qtd_guest
    elsif !user.confirmed.present? && user.answered == '0'
      user.qtd_expected
    end
  end

  def quantity_diapers(users)
    m = users.where(tamanho_fralda: 'M').count
    g = users.where(tamanho_fralda: 'G').count
    return "#{m}M e #{g}G. Total: #{m + g}"
  end

  def action(action)
    if action == 'new'
      "Criar"
    else
      "Atualizar"
    end
  end
end
