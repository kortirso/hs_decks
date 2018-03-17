# Represents search methods for objects with hash for names
module Nameable
  extend ActiveSupport::Concern

  def find_by_locale_name(locale, name)
    find_by('name @> hstore(:key, :value)', key: locale, value: name)
  end

  def find_by_name(name)
    find_by_locale_name('en', name) || find_by_locale_name('ru', name)
  end

  def names_list(locale)
    all.collect { |object| object.name[locale] }.sort
  end
end
