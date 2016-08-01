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

                it 'renders decks page' do
                    expect(response).to render_template :index
                end

                it 'and collects an array of decks' do
                    expect(assigns(:decks)).to match_array(decks)
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
                @current_user.update(role: 'deck_master')
                get :show, params: { id: 1 }

                expect(response).to render_template 'layouts/404'
            end

            context 'if deck exist' do
                let!(:deck) { create :deck }
                before { get :show, params: { id: deck.id } }

                it 'renders deck page' do
                    expect(response).to render_template :show
                end

                it 'assigns the requested deck to @deck' do
                    expect(assigns(:deck)).to eq deck
                end
            end
        end

        def do_request
            get :show, params: { id: 1 }
        end
    end
end
