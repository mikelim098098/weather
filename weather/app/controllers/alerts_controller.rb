 # require 'twilio-ruby'
class AlertsController < ApplicationController
  before_action :set_alert, only: [:edit, :update, :destroy]

  # GET /alerts
  # GET /alerts.json
  def index
    @alerts = Alert.all
    @user = User.find(session[:id])

  end

  # GET /alerts/1
  # GET /alerts/1.json
  def show
    @alert = Alert.find(params[:id])
  end

  # GET /alerts/new
  def new
    @alert = Alert.new
  end

  # GET /alerts/1/edit
  def edit
  end

  # POST /alerts
  # POST /alerts.json
  def create
    user = User.find(session[:id])
    alert = {:city_name => alert_params[:city_name], :alert_time => alert_params[:alert_time], :user => user }
    @alert = Alert.new(alert)
    respond_to do |format|
      if @alert.save
        # format.html { redirect_to @user, notice: 'Alert was successfully created.' }
        format.html { redirect_to('/alerts', notice: 'Alert was successfully created.') }
        format.json { render :show, status: :created, location: @alert }
      else
        format.html { render :new }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /alerts/1
  # PATCH/PUT /alerts/1.json
  def update
    user = User.find(session[:id])
    alert = {:city_name => alert_params[:city_name], :alert_time => alert_params[:alert_time], :user => user, :title => alert_params[:title]  }
    respond_to do |format|
      if @alert.update(alert)
        format.html { redirect_to @alert, notice: 'Alert was successfully updated.' }
        format.json { render :show, status: :ok, location: @alert }
      else
        format.html { render :edit }
        format.json { render json: @alert.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /alerts/1
  # DELETE /alerts/1.json
  def destroy
    @alert.destroy
    respond_to do |format|
      format.html { redirect_to alerts_url, notice: 'Alert was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def self.hello
    puts "printing message"
    url = URI.parse('http://api.openweathermap.org/data/2.5/weather?q=London,uk')
    req = Net::HTTP::Get.new(url.to_s)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    puts res.body

    account_sid = 'AC0624d10f56e7c544e263f5675b73f6b9' 
    auth_token = '6c837895f487d82c51e283c119bf1b6c' 
    # set up a client to talk to the Twilio REST API 
    @client = Twilio::REST::Client.new account_sid, auth_token
    
    alerts = Alert.all
    alerts.each do | alert |
       phone = '+1'+alert.user.phone_number
       # @client.account.messages.create({
       #  :from => '+18315089098', 
       #  :to => phone, 
       #  :body => 'Hello',  
       # })   
    end
 
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_alert
      @alert = Alert.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def alert_params
      params.require(:alert).permit(:city_name, :alert_time, :title)
    end
end
