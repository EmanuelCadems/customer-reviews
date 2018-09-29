module V1
  class ServicesController < ApplicationController
    before_action :authenticate_admin

    def create
      service = Service.new(service_params)
      if service.save
        render json: service, status: 201
      else
        render json: service.errors, status: 422
      end
    end

    private

    def service_params
      params.require(:service).permit(:name, :curl_cmd, :notify_on)
    end
  end
end
