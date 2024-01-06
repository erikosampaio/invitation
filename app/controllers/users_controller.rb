class UsersController < ApplicationController
  http_basic_authenticate_with name: "sampaio", password: "abnerprincipe", only: %i[ index index_status index_anfitriao new edit create update destroy]
  before_action :set_user, only: %i[ edit update destroy ]

  def index
    @users = User.all.order(confirmed: :desc).order(:answered).order(:name)
    @contador = 0
  end

  def index_status
    @users             = User.all.order(:name).order(:confirmed)
    @confirmations     = User.where(confirmed: true, answered: '1').order(:name)
    @not_confirmations = User.where(confirmed: false, answered: '0').order(:name)
    @will_not          = User.where(confirmed: false, answered: '2').order(:name)
    @contador = 0
  end

  def index_anfitriao
    @users          = User.all.order(:name).order(:confirmed)
    @invites_eriko  = User.where(responsavel: 'Ériko').order(confirmed: :desc).order(:answered).order(:name)
    @invites_nayara = User.where(responsavel: 'Nayara').order(confirmed: :desc).order(:answered).order(:name)
    @invites_both   = User.where(responsavel: 'Ambos').order(confirmed: :desc).order(:answered).order(:name)
    @contador = 0
  end

  def new
    @user = User.new
  end

  def edit
    puts "Token do #{@user.name}: #{@user.token}"
  end

  def resend_message
    @user = User.find(params[:format]) if params[:format].present?
    begin
      return_api_whatsapp = ::SendMessage::WhatsAppApi.new(@user).resend_package_message

      if return_api_whatsapp['error']
        redirect_to users_url, notice: "#{return_api_whatsapp['error']}"
      else
        redirect_to users_url, notice: "Mensagem reenviada com sucesso"
      end
    rescue Exception => e
      flash.now['alert'] = "Erro inesperado: #{e.message}"
      redirect_to users_url
    end
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
      if @user.update(confirmed: false, answered: '2', qtd_guest: 0)
        redirect_to root_path, notice: "Sentiremos sua falta em nossa comemoração. Se mudar de ideia é só confirmar o quanto antes."
      else
        flash.now['alert'] = @user.errors.full_messages.to_sentence
        render :new_response_invitation
      end
    elsif params[:commit].downcase == "eu vou"
      params[:qtd_guest] = @user.qtd_expected if params[:qtd_guest].nil?
      if @user.update(confirmed: true, answered: '1', qtd_guest: params[:qtd_guest], qtd_expected: params[:qtd_guest])
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
    params.require(:user).permit(:name, :phone, :token, :confirmed, :tamanho_fralda, :qtd_guest, :responsavel, :qtd_expected, :send_qtd_expected)
  end
end
