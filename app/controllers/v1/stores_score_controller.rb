module V1
  class StoresScoreController < ApplicationController
    before_action :set_avg
    def show
      if @avg.kind_of?(BigDecimal)
        render json: { avg: @avg }, status: 200
      else
        head 204
      end
    end

    private

    def set_avg
      @avg = Review.score_avg_by_store_and_period(
               params[:id], params[:from], params[:to]
             )
    end
  end
end
