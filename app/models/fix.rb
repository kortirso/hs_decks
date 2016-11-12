class Fix < ApplicationRecord
    belongs_to :about

    validates :body_en, :body_ru, :about_id, presence: true

    def locale_body(locale)
        self["body_#{locale}"]
    end
end
