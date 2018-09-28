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
