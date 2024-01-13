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
    if user.confirmed.present?
      user.qtd_guest
    else
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

  def invited_confirmed_count(inviteds)
    users_remove = [
      'Ériko',
      'Nayara Teles',
      'Tarciane',
      'Marta Sampaio',
      'Berg',
      'Erika Jamille',
      'Valéria',
      'Davi e Patrícia',
      'Emilly e Bin',
      'Mayra e Família',
      'Valeska e Rafael',
      'Cláudio',
      'Luana'
    ]

    inviteds = User.where(confirmed: true).where.not(name: users_remove).count
  end
end
