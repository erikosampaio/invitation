class UsersController < ApplicationController
  http_basic_authenticate_with name: "sampaio", password: "abnerprincipe", except: [:create_response_invitation, :new_response_invitation]
  before_action :set_user, only: %i[ edit update destroy ]

  def index
    @users = User.all.order(:name).order(:confirmed)
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    
    if params[:user][:confirmed] == '1'
      @user.confirmed = true
      @user.answered = '1'
    elsif params[:user][:will_not] == '1'
      @user.confirmed = false
      @user.answered = '2'
    else
      @user.confirmed = false
      @user.answered = '0'
    end

    if @user.save
      begin
        return_api_whatsapp = ::SendMessage::WhatsAppApi.new(@user).send_package_message
        if return_api_whatsapp['error']
          redirect_to users_url, notice: "Usuário criado com sucesso. #{return_api_whatsapp['error']}"
        else
          redirect_to users_url, notice: return_api_whatsapp['success']
        end
      rescue Exception => e
        flash.now['alert'] = "Erro inesperado: #{e.message}"
        render :new
      end
    else
      flash.now['alert'] = @user.errors.full_messages.to_sentence
      render :new
    end
  end

  def update
    if @user.update(user_params)
      redirect_to users_url, notice: "Usuário atualizado com sucesso."
    else
      flash.now['alert'] = @user.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: "Usuário deletado com sucesso."
  end

  def create_response_invitation
    if params[:telefone] == nil || params[:telefone] == ""
      flash.now[:alert] = "Telefone não pode ser vazio."
      render :new_response_invitation
      return
    end

    @user = User.find_by(phone: params[:telefone])
    if @user == nil
      flash.now[:alert] = "Usuário não encontrado pelo telefone. Tente novamente."
      return render :new_response_invitation
    end

    if @user.present? && @user.confirmed == true && params[:commit].downcase == "confirmar"
      return redirect_to root_path, notice: "Você já confirmou sua presença."
    end

    # if @user.token != params[:token]
    #   flash.now[:alert] = "Insira o token válido."
    #   return render :new_response_invitation
    # end
    
    if params[:commit].downcase == "declinar"
      if @user.update(confirmed: false, answered: '2')
        # Chama serviço de whatsapp para enviar mensagem de despedida
        redirect_to root_path, notice: "Sentiremos sua falta em nossa comemoração. Se mudar de ideia é só confirmar o quanto antes."
      else
        flash.now['alert'] = @user.errors.full_messages.to_sentence
        render :new_response_invitation
      end
    elsif params[:commit].downcase == "confirmar"
      if @user.update(confirmed: true, answered: '1')
        # Chama serviço de whatsapp para enviar mensagem de 
        redirect_to root_path, notice: "Sua presença foi confirmada. Estamos te esperando ansiosamente."
      else
        flash.now['alert'] = @user.errors.full_messages.to_sentence
        render :new_response_invitation
      end
    else
      redirect_to root_path, notice: "Erro inesperado. Tente novamente."
    end
  end

  def new_response_invitation
    @user = User.new
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :phone, :token, :confirmed)
  end
end
