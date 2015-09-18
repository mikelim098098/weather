 # require 'twilio-ruby'
class AlertsController < ApplicationController
  before_action :set_alert, only: [:edit, :update, :destroy]

  # GET /alerts
  # GET /alerts.json
  def index
    # @alerts = Alert.all
    @user = User.find(session[:id])
    @alerts = @user.alerts
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
    
    alert = {:title => alert_params[:title], :city_name => alert_params[:city_name], :alert_time => alert_params[:alert_time], :user => user }
    puts 'ALERT TIME!!!!!!!!!!!!!!!!!!!!!!!!'
    puts alert_params[:alert_time][0]
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
    alert = {:title => alert_params[:title], :city_name => alert_params[:city_name], :alert_time => alert_params[:alert_time], :user => user }
    respond_to do |format|
      if @alert.update(alert)
        format.html { redirect_to('/alerts', notice: 'Alert was successfully updated.')}
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

    account_sid = 'AC3393f67117467905c5732e2f9300b3f9' 
    auth_token = 'c63e8daca528dc61e3d870383ca458a7' 
    # set up a client to talk to the Twilio REST API 
    @client = Twilio::REST::Client.new account_sid, auth_token
    
    curr_time1 =  Time.new.strftime("%I:%M%P")
    alerts = Alert.where(alert_time: curr_time1)

    alerts.each do | alert |

      user = User.find(alert.user.id)

      #current weather
      c_url = URI.parse('http://api.openweathermap.org/data/2.5/weather?q=' + alert.city_name + '&units=imperial')
      c_req = Net::HTTP::Get.new(c_url.to_s)
      c_res = Net::HTTP.start(c_url.host, c_url.port) {|http|
        http.request(c_req)
      }

      #weather forecast
      url = URI.parse('http://api.openweathermap.org/data/2.5/forecast/daily?q=' + alert.city_name + '&mode=json&units=imperial&cnt=1')
      req = Net::HTTP::Get.new(url.to_s)
      res = Net::HTTP.start(url.host, url.port) {|http|
        http.request(req)
      }
      obj = JSON.parse(res.body)
      c_obj = JSON.parse(c_res.body)
      # puts obj["list"][0]["temp"]["day"]*(9.to_f/5)+32
      # puts "Hello, user! Today, #{res.body.coor}"
      text = "Hi " + user.first_name + "! The weather in " + obj["city"]["name"] + " is currently " + c_obj["main"]["temp"].floor.to_s + " degrees F.\n"  + 
             "Today's forecast is the following:\n" +
            # "hello" + obj["list"]
             "Low: " + obj["list"][0]["temp"]["min"].floor.to_s + " F\n" +
             "High: " + obj["list"][0]["temp"]["max"].floor.to_s + " F\n" +
             "Description: " + obj["list"][0]['weather'][0]['description']


      puts "message sent"
      phone = '+1'+alert.user.phone_number 
      puts phone
      @client.account.messages.create({
        :from => '+17606645501', 
        :to => phone, 
        :body => text,  

        })   
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
