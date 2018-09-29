require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_index(:store_id) }
    it { is_expected.to have_db_index(:order_id) }
    it { is_expected.to have_db_index(:user_id) }
    it { is_expected.to have_db_column(:opinion).of_type(:string) }
    it do
      is_expected.to have_db_column(:score).of_type(:integer)
                                           .with_options(default: 5)
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:store_id) }
    it { is_expected.to validate_presence_of(:order_id) }
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:opinion) }
    it { is_expected.to validate_presence_of(:score) }
    it { is_expected.to validate_uniqueness_of(:store_id)
      .scoped_to([:order_id, :user_id]) }
    it { should validate_inclusion_of(:score).in_array(Review::SCORES)}
  end

  describe 'scopes' do
    let(:review) { create(:review) }

    describe '.by_store' do
      it 'filters reviews by store_id' do
        expect(Review.by_store(review.store_id)).to include(review)
      end
    end

    describe '.between' do
      let(:from) { Date.today.beginning_of_month }
      let(:to)   { Date.today.end_of_month }
      before do
        review
        create(:review, :last_month)
      end

      it 'filters reviews between two dates' do
        expect(Review.between(from, to)).to include(review)
      end
    end

    describe '.score_by_store_and_period' do
      let(:from)     { Date.today.beginning_of_month }
      let(:to)       { Date.today.end_of_month }
      let(:store_id) { 1 }
      let(:bad_review)   { create(:review, store_id: store_id, score: 1) }
      let(:good_review)   { create(:review, store_id: store_id, score: 4) }
      before do
        bad_review
        good_review
        create(:review, :last_month, store_id: store_id)
      end

      it 'filters reviews by store and between two dates' do
        expect(Review.score_avg_by_store_and_period(store_id, from, to))
          .to eq(2.5)
      end
    end
  end

  describe 'constants' do
    describe '::SCORES' do
      it 'returns an array with integers 1 to 5' do
        expect(Review::SCORES).to eq((1..5).to_a)
      end
    end
  end

  describe 'soft-delete' do
    let(:review) { create(:review) }

    before do
      review.delete
    end

    it 'removes the row from all' do
      expect(Review.all).to be_empty
    end

    it 'soft deletes the row' do
      expect(Review.only_deleted).to include(review)
    end

    it 'marks the row as deleted' do
      expect(Review.only_deleted.first.deleted_at).not_to be(nil)
    end

    it 'allows to recover the deleted row' do
      Review.only_deleted.first.recover
      expect(Review.all).to include(review)
    end
  end
end
