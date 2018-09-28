module V1
  class ReviewsController < ApplicationController
    before_action :authenticate, only: [:show, :create, :update]
    before_action :authenticate_moderator, only: [:destroy]
    before_action :load_resource, only: [:show, :update, :destroy]

    def show
      render json: @review, status: 200
    end

    def create
      review = Review.new(review_params)
      if review.save
        render json: review, status: 201
      else
        render json: review.errors, status: 422
      end
    end

    def update
      if @review.update(review_params)
        render json: @review, status: 200
      else
        render json: @review.errors, status: 422
      end
    end

    def destroy
      @review.destroy
      head 204
    end

    private

    def load_resource
      @review = Review.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      head 404
    end

    def review_params
      params.require(:review).permit(
        :store_id, :order_id, :user_id, :opinion, :score
      )
    end
  end
end
