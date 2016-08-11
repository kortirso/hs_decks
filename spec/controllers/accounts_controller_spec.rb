RSpec.describe AccountsController, type: :controller do
    describe 'GET #index' do
        it_behaves_like 'Check access'

        context 'When user logged in' do
            sign_in_user
            let!(:cards) { create_list(:card, 2) }
            let!(:position) { create :position_for_user, positionable: @current_user, card: cards.first }
            let!(:decks) { create_list(:deck, 2) }
            let!(:checks) { create_list(:check, 2, user: @current_user, deck: decks.first) }
            before { get :index }

            it 'collects an array of cards in @cards' do
                expect(assigns(:cards)).to match_array(cards)
            end

            it 'and collects an array of packs with card ids in @packs' do
                expect(assigns(:packs)).to match_array([[position.card_id, position.amount]])
            end

            it 'and collects an array of checks in @checks' do
                expect(assigns(:checks)).to match_array(checks)
            end

            it 'and assigns the requested decks to @decks' do
                expect(assigns(:decks)).to eq decks
            end

            it 'and renders account page' do
                expect(response).to render_template :index
            end
        end

        def do_request
            get :index
        end
    end

    describe 'POST #create' do
        it_behaves_like 'Check access'

        context 'When user logged in' do
            sign_in_user

            it 'should call build_collection users method' do
                expect_any_instance_of(User).to receive(:build_collection)

                post :create, params: {}
            end

            it 'and should render head ok' do
                post :create, params: {}

                expect(response.status).to eq 200
            end
        end

        def do_request
            post :create, params: {}
        end
    end
end
