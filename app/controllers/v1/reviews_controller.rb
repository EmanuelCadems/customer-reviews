module V1
  class ReviewsController < ApplicationController
    def create
      review = Review.new(review_params)
      if review.save
        render json: review, status: 201
      else
        render json: review.errors, status: 422
      end
    end

    def update
      review = Review.find(params[:id])
      if review.update(review_params)
        render json: review, status: 200
      else
        render json: review.errors, status: 422
      end
    end

    private

    def review_params
      params.require(:review).permit(
        :store_id, :order_id, :user_id, :opinion, :score
      )
    end
  end
end
