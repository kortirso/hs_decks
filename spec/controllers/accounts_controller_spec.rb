RSpec.describe AccountsController, type: :controller do
    describe 'GET #index' do
        it 'redirect to welcome page if user not login' do
            get :index

            expect(response).to render_template 'welcome/index'
        end

        context 'When user logged in' do
            sign_in_user
            let!(:cards) { create_list(:card, 2) }
            let!(:position) { create :position_for_user, positionable: @current_user, card: cards.first }
            before { get :index }

            it 'renders account page' do
                expect(response).to render_template :index
            end

            it 'and collects an array of cards' do
                expect(assigns(:cards)).to match_array(cards)
            end

            it 'and collects an array of packs with card ids' do
                expect(assigns(:packs)).to match_array([[position.card_id, position.amount]])
            end
        end
    end
end
