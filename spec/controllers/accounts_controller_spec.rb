RSpec.describe AccountsController, type: :controller do
    describe 'POST #create' do
        it_behaves_like 'Check access'

        context 'When user logged in' do
            sign_in_user

            it 'should call build_collection users method' do
                expect_any_instance_of(CollectionConstructor).to receive(:build_collection)

                post :create, params: { cards: { '1' => 1 } }, format: :js
            end

            it 'and should render head ok' do
                post :create, params: { cards: { '1' => 1 } }, format: :js

                expect(response.status).to eq 200
            end
        end

        def do_request
            post :create, params: {}, format: :js
        end
    end
end
