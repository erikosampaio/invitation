class UsersController < ApplicationController
  http_basic_authenticate_with name: "sampaio", password: "abnerprincipe", only: %i[ index index_status new edit create update destroy]
  before_action :set_user, only: %i[ edit update destroy ]

  def index
    @users = User.all.order(:name).order(:confirmed)
  end

  def index_status
    @user = User.all.order(:name).order(:confirmed)
    @confirmations = User.where(confirmed: true, answered: '1').order(:name)
    @not_confirmations = User.where(confirmed: false, answered: '0').order(:name)
    @will_not = User.where(confirmed: false, answered: '2').order(:name)
  end

  def new
    @user = User.new
  end

  def edit
    puts "Token do #{@user.name}: #{@user.token}"
  end

  def create
    @user = User.new(user_params)
    @user.token = SecureRandom.hex(5)
    
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
    @user = User.where(token: params[:token]).first
    
    if params[:commit].downcase == "não posso ir"
      if @user.update(confirmed: false, answered: '2')
        redirect_to root_path, notice: "Sentiremos sua falta em nossa comemoração. Se mudar de ideia é só confirmar o quanto antes."
      else
        flash.now['alert'] = @user.errors.full_messages.to_sentence
        render :new_response_invitation
      end
    elsif params[:commit].downcase == "eu vou"
      if @user.update(confirmed: true, answered: '1', qtd_guest: params[:qtd_guest])
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
    @user = User.where(token: params[:token]).first
    if @user.nil?
      redirect_to root_path, alert: "Erro ao validar token. Fale com os pais do Abner para resolver esse problema."
    end
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :phone, :token, :confirmed, :tamanho_fralda, :qtd_guest, :responsavel)
  end
end
