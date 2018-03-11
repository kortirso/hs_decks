# Represents localization helper
module Localizeable
  extend ActiveSupport::Concern

  def locale_name(locale)
    name[locale]
  end
end
