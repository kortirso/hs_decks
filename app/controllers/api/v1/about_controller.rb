module Api
    module V1
        class AboutController < Api::V1::BaseController
            resource_description do
                short 'About information resources'
                formats ['json']
            end

            api :GET, '/v1/about.json', 'Returns about information'
            def index
                render json: ActiveModel::Serializer::CollectionSerializer.new(About.order(id: :desc).includes(:fixes), each_serializer: AboutSerializer)
            end
        end
    end
end
