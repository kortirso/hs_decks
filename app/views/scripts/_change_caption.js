$('.card').mouseenter(function() {
    $(this).children('.card_caption').show();
}).mouseleave(function() {
    $(this).children('.card_caption').hide();
});