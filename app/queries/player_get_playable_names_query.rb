# Returns localized names of player classes
class PlayerGetPlayableNamesQuery
  def self.query
    Player
      .is_playable
      .map { |elem| elem.locale_name(I18n.locale) }
  end
end
