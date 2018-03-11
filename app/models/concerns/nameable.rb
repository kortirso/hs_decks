# Represents search methods for objects with hash for names
module Nameable
  extend ActiveSupport::Concern

  def find_by_locale_name(locale, name)
    self.find_by("name @> hstore(:key, :value)", key: locale, value: name )
  end

  def find_by_name(name)
    self.find_by_locale_name('en', name) || self.find_by_locale_name('ru', name)
  end
end
