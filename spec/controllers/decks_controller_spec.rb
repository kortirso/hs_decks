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
        it_behaves_like 'Check access'

        context 'When user logged in' do
            sign_in_user

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

        def do_request
            get :show, params: { id: 1 }
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
                    expect(Deck).to receive(:build)

                    post :create, params: {}
                end

                it 'should redirect to decks_path if Deck.build returns true' do
                    post :create, params: { name: 'Deck', playerClass: 'Shaman', formats: 'standard', link: '', caption: '', "#{cards[0].id}" => '2', "#{cards[1].id}" => '2', "#{cards[2].id}" => '2', "#{cards[3].id}" => '2', "#{cards[4].id}" => '2', "#{cards[5].id}" => '2', "#{cards[6].id}" => '2', "#{cards[7].id}" => '2', "#{cards[8].id}" => '2', "#{cards[9].id}" => '2', "#{cards[10].id}" => '2', "#{cards[11].id}" => '2', "#{cards[12].id}" => '2', "#{cards[13].id}" => '2', "#{cards[14].id}" => '2'}

                    expect(response).to redirect_to decks_path
                end

                it 'should redirect to new_deck_path if Deck.build returns false' do
                    post :create, params: {}

                    expect(response).to redirect_to new_deck_path
                end
            end
        end

        def do_request
            post :create, params: {}
        end

        def do_request_for_role
            post :create, params: {}
        end
    end
end
