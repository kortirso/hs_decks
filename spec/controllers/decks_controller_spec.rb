RSpec.describe DecksController, type: :controller do
  describe 'GET #index' do
    it_behaves_like 'Check access'

    context 'When user logged in' do
      sign_in_user
      it_behaves_like 'Check role'

      context 'For deck master' do
        let!(:decks) { create_list(:deck, 2, user: @current_user) }
        before do
          @current_user.update(role: 'deck_master')
          get :index
        end

        it 'collects an array of decks in @decks' do
          expect(assigns(:decks)).to match_array(decks)
        end

        it 'and renders decks page' do
          expect(response).to render_template :index
        end
      end
    end

    def do_request
      get :index
    end

    def do_request_for_role
      get :index
    end
  end

  describe 'GET #show' do
    it 'should render 404 if deck does not exist' do
      get :show, params: { id: 1 }

      expect(response).to render_template 'layouts/404'
    end

    context 'if deck exist' do
      let!(:deck) { create :deck }
      let!(:position) { create :position_for_deck, positionable: deck }
      before { get :show, params: { id: deck.id } }

      it 'assigns the requested deck to @deck' do
        expect(assigns(:deck)).to eq deck
      end

      it 'assigns positions card_id and amount to @positions' do
        expect(assigns(:positions)).to eq [[position.card_id, position.amount]]
      end

      it 'and renders deck page' do
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #new' do
    it_behaves_like 'Check access'

    context 'When user logged in' do
      sign_in_user
      it_behaves_like 'Check role'

      context 'if user is deck master' do
        let!(:cards) { create_list(:card, 2) }
        before do
          @current_user.update(role: 'deck_master')
          get :new
        end

        it 'assigns all cards to @cards' do
          expect(assigns(:cards)).to match_array(cards)
        end

        it 'and renders deck page' do
          expect(response).to render_template :new
        end
      end
    end

    def do_request
      get :new
    end

    def do_request_for_role
      get :new
    end
  end

  describe 'POST #create' do
    it_behaves_like 'Check access'

    context 'When user logged in' do
      sign_in_user
      it_behaves_like 'Check role'

      context 'if user is deck master' do
        let!(:cards) { create_list(:card, 15) }
        before { @current_user.update(role: 'deck_master') }

        it 'should call Decks build method' do
          expect_any_instance_of(DeckConstructor).to receive(:build)

          post :create, params: { deck: { name: 'Deck' } }
        end

        it 'should redirect to decks_path if DeckConstructor.build returns true' do
          post :create, params: { deck: { name: 'Deck', playerClass: 'Shaman', formats: 'standard', link: '', caption: '', author: '', power: 1, style: 'Aggro', reno_type: 1 }, cards: { cards[0].id.to_s => '2', cards[1].id.to_s => '2', cards[2].id.to_s => '2', cards[3].id.to_s => '2', cards[4].id.to_s => '2', cards[5].id.to_s => '2', cards[6].id.to_s => '2', cards[7].id.to_s => '2', cards[8].id.to_s => '2', cards[9].id.to_s => '2', cards[10].id.to_s => '2', cards[11].id.to_s => '2', cards[12].id.to_s => '2', cards[13].id.to_s => '2', cards[14].id.to_s => '2' } }

          expect(response).to redirect_to decks_path
        end

        it 'should redirect to new_deck_path if Deck.build returns false' do
          post :create, params: { deck: { name: 'Deck' } }

          expect(response).to redirect_to new_deck_path
        end
      end
    end

    def do_request
      post :create, params: { deck: { name: 'Deck' } }
    end

    def do_request_for_role
      post :create, params: { deck: { name: 'Deck' } }
    end
  end

  describe 'GET #edit' do
    it_behaves_like 'Check access'

    context 'When user logged in' do
      let!(:deck) { create :deck }
      sign_in_user
      it_behaves_like 'Check role'

      it 'should render 404 if deck does not exist' do
        get :edit, params: { id: 1 }

        expect(response).to render_template 'layouts/404'
      end

      it 'should render 404 if deck does not belong to user' do
        get :edit, params: { id: deck.id }

        expect(response).to render_template 'layouts/404'
      end

      context 'if user is deck master and deck belongs to him' do
        let!(:users_deck) { create :deck, user: @current_user }
        let!(:card_1) { create :card, playerClass: users_deck.playerClass }
        let!(:card_2) { create :card, playerClass: 'Neutral' }
        let!(:card_3) { create :card, playerClass: 'Priest' }
        let!(:position) { create :position_for_deck, positionable: users_deck, card: card_1 }
        before do
          @current_user.update(role: 'deck_master')
          get :edit, params: { id: users_deck.id }
        end

        it 'assigns the requested deck to @deck' do
          expect(assigns(:deck)).to eq users_deck
        end

        it 'and assigns cards available for playerClass to @cards' do
          expect(assigns(:cards).size).to eq 2
          expect(assigns(:cards).first).to eq card_1
          expect(assigns(:cards).last).to eq card_2
        end

        it 'and assigns positions card_id and amount to @positions' do
          expect(assigns(:positions)).to eq [[position.card_id, position.amount]]
        end

        it 'and renders edit deck page' do
          expect(response).to render_template :edit
        end
      end
    end

    def do_request
      get :edit, params: { id: 1 }
    end

    def do_request_for_role
      get :edit, params: { id: 1 }
    end
  end

  describe 'PATCH #update' do
    it_behaves_like 'Check access'

    context 'When user logged in' do
      let!(:deck) { create :deck }
      sign_in_user
      it_behaves_like 'Check role'

      it 'should render 404 if deck does not exist' do
        patch :update, params: { id: 1, deck: { name: 'Deck' } }

        expect(response).to render_template 'layouts/404'
      end

      it 'should render 404 if deck does not belong to user' do
        patch :update, params: { id: deck.id, deck: { name: 'Deck' } }

        expect(response).to render_template 'layouts/404'
      end

      context 'if user is deck master' do
        let!(:users_deck) { create :deck, user: @current_user }
        let!(:cards) { create_list(:card, 15) }
        before { @current_user.update(role: 'deck_master') }

        it 'assigns the requested deck to @deck' do
          patch :update, params: { id: users_deck.id, deck: { name: 'Deck' } }

          expect(assigns(:deck)).to eq users_deck
        end

        it 'and should call Decks refresh method on @deck' do
          expect_any_instance_of(DeckConstructor).to receive(:refresh)

          patch :update, params: { id: users_deck.id, deck: { name: 'Deck' } }
        end

        it 'should redirect to decks_path if DeckConstructor.build returns true' do
          patch :update, params: { id: users_deck.id, deck: { name: 'Updated deck', link: '', caption: '', author: '', power: 1, style: 'Aggro', reno_type: 1 }, cards: { cards[0].id.to_s => '2', cards[1].id.to_s => '2', cards[2].id.to_s => '2', cards[3].id.to_s => '2', cards[4].id.to_s => '2', cards[5].id.to_s => '2', cards[6].id.to_s => '2', cards[7].id.to_s => '2', cards[8].id.to_s => '2', cards[9].id.to_s => '2', cards[10].id.to_s => '2', cards[11].id.to_s => '2', cards[12].id.to_s => '2', cards[13].id.to_s => '2', cards[14].id.to_s => '2' } }

          expect(response).to redirect_to decks_path
        end

        it 'should redirect to new_deck_path if Deck.build returns false' do
          patch :update, params: { id: users_deck.id, deck: { name: 'Deck' } }

          expect(response).to redirect_to edit_deck_path(users_deck)
        end
      end
    end

    def do_request
      patch :update, params: { id: 1, deck: { name: 'Deck' } }
    end

    def do_request_for_role
      patch :update, params: { id: 1, deck: { name: 'Deck' } }
    end
  end

  describe 'DELETE #destroy' do
    it_behaves_like 'Check access'

    context 'When user logged in' do
      let!(:deck) { create :deck }
      sign_in_user
      it_behaves_like 'Check role'

      it 'should render 404 if deck does not exist' do
        delete :destroy, params: { id: 1 }, format: :js

        expect(response).to render_template 'layouts/404'
      end

      it 'should render 404 if deck does not belong to user' do
        delete :destroy, params: { id: 1 }, format: :js

        expect(response).to render_template 'layouts/404'
      end

      context 'if user is deck master' do
        let!(:users_deck) { create :deck, user: @current_user }
        before { @current_user.update(role: 'deck_master') }

        it 'assigns the requested deck to @deck' do
          delete :destroy, params: { id: users_deck.id }, format: :js

          expect(assigns(:deck)).to eq users_deck
        end

        it 'and should call Decks destroy method on @deck' do
          expect_any_instance_of(Deck).to receive(:destroy)

          delete :destroy, params: { id: users_deck.id }, format: :js
        end

        it 'and should destroy deck' do
          expect { delete :destroy, params: { id: users_deck.id }, format: :js }.to change(Deck, :count).by(-1)
        end

        it 'and should redirect to decks_path' do
          delete :destroy, params: { id: users_deck.id }, format: :js

          expect(response).to redirect_to decks_path
        end
      end
    end

    def do_request
      delete :destroy, params: { id: 1 }, format: :js
    end

    def do_request_for_role
      delete :destroy, params: { id: 1 }, format: :js
    end
  end
end
