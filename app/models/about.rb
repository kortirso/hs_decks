# Represents App Versions
class About < ApplicationRecord
    has_many :fixes, dependent: :destroy

    validates :version, :label_en, :label_ru, presence: true

    def locale_label(locale)
        self["label_#{locale}"]
    end
end
