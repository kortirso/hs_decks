RSpec.describe PagesController, type: :controller do
  describe 'GET #index' do
    it 'renders index page' do
      get :index

      expect(response).to render_template :index
    end
  end

  describe 'GET #decks' do
    let!(:decks) { create_list(:deck, 2) }
    before { get :decks }

    it 'assigns the requested decks to @decks' do
      expect(assigns(:decks)).to eq decks.reverse
    end

    it 'and renders account page' do
      expect(response).to render_template :decks
    end
  end

  describe 'GET #about' do
    it 'renders about page' do
      get :about

      expect(response).to render_template :about
    end
  end

  describe 'GET #collection' do
    it_behaves_like 'Check access'

    context 'When user logged in' do
      sign_in_user
      let!(:cards) { create_list(:card, 2) }
      let!(:position) { create :position_for_user, positionable: @current_user, card: cards.first }
      before { get :collection }

      it 'collects an array of cards in @cards' do
        expect(assigns(:cards)).to match_array(cards)
      end

      it 'and collects an array of packs with card ids in @packs' do
        expect(assigns(:packs)).to match_array([[position.card_id, position.amount]])
      end

      it 'and renders account page' do
        expect(response).to render_template :collection
      end
    end

    def do_request
      get :collection
    end
  end
end
