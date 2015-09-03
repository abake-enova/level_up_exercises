class CardsController < ApplicationController
  before_action :find_card_from_params_id, except: :index

  def index
    @cards = Card.search(params).paginate(page: params[:page], per_page: 50)
  end

  def show
  end

  def show_tooltip
    render 'cards/show_tooltip', layout: false
  end

  private

  def find_card_from_params_id
    @card = Card.find(params[:id])
  end
end
