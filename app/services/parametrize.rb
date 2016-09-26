class Parametrize

    PARAMS_HEADERS = %w(utf8 commit authenticity_token controller action id _method mana_cost)
    DECK_HEADERS = %w(name playerClass formats link caption success author direction)

    def self.deck_getting_params(params)
        data = params.to_a.delete_if { |elem| PARAMS_HEADERS.include? elem[0] }
        deck_params, positions_params = [], []
        data.each { |d| DECK_HEADERS.include?(d[0]) ? deck_params.push(d) : positions_params.push(d) }
        [deck_params, positions_params]
    end
end