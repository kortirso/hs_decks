# Build css file with styles for short cards
class CardsStylesCompilerService
  def build_file
    open("#{Rails.root}/frontend/init/short_cards_sprites.css", 'w') do |f|
      cards.each.with_index do |card, index|
        f.puts ".card_#{card.cardId} {"
        f.puts "  background: url('../images/short_cards_sprite.png');"
        f.puts "  background-position: #{x_change(index)} #{y_change(index)};"
        f.puts '}'
        f.puts ''
      end
    end
  end

  private def cards
    Card.all.order(cardId: :asc)
  end

  private def x_change(index)
    x_koef = index % 50
    x_koef.zero? ? '0' : "-#{x_koef * 116}px"
  end

  private def y_change(index)
    y_koef = index / 50
    y_koef.zero? ? '0' : "-#{y_koef * 29}px"
  end
end
