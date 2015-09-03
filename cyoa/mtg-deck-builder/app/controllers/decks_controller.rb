class DecksController < ApplicationController
  def new
    @deck = current_user.decks.build
  end

  def show
    @deck = Deck.find(params[:id])
    @cards_in_deck = Card.group_by_type(@deck.cards)
  end

  def create
    @deck = current_user.decks.build(deck_params)
    if @deck.save
      success_message = "Your deck #{@deck.name} has been created."
      redirect_to @deck.user, flash: { success: success_message }
    else
      render 'new'
    end
  end

  def edit
    @cards = Card.search(params).paginate(page: params[:page], per_page: 100)
    @deck = Deck.find(params[:id])
    @cards_in_deck = Card.group_by_type(@deck.cards)
  end

  def destroy
    deck = Deck.find(params[:id])
    deck.destroy
    success_message = "Your deck #{deck.name} has been destroyed."
    redirect_to current_user, flash: { success: success_message }
  end

  private

  def deck_params
    params.require(:deck).permit(
      :name,
      :user_id)
  end
end
