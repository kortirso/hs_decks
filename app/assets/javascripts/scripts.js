$.fn.mana_curve = function (amount) {
    mana_curve = $('#mana_curve #' + this.attr('class').split(' ')[0] + ' .count')
    $(mana_curve).html(parseInt($(mana_curve).html()) + amount);

    array = [];
    $('#mana_curve .col').each(function() {
        array.push(parseInt($(this).children('.count').html()));
    });
    max_amount = Math.max.apply(Math, array);
    if(max_amount != 0) {
        $('#mana_curve .col').each(function() {
            $(this).children('.inner_col').children('.filled').css('height', (parseInt($(this).children('.count').html()) * 100 / max_amount) + 'px');
        });
    }
    else {
        mana_curve_reset();
    }
}

function mana_curve_reset() {
    $('#mana_curve .col').each(function() {
        $(this).children('.count').html('0');
        $(this).children('.inner_col').children('.filled').css('height', '0');
    });
}

$(function() {
    $('#new-cards-tabs li:nth-of-type(n+2)').hide();
    $('#new-cards-tabs li.Common').show();

    $('#new-tabs-content .costs label').click(function(e) {
        e.preventDefault();
        amount = parseInt($('#card_amount').html());
        if($(this).hasClass('none')) {
            if(amount < 30) {
                $(this).removeClass('none').addClass('single');
                $(this).closest('div').children('input').val(1).attr('checked', true);
                $('#card_amount').html(amount + 1);

                $(this).mana_curve(1)

                cloned = $(this).closest('.card').clone();
                current_mana_cost = parseInt($(cloned).attr('class').split(' ')[1].split('_')[1]);
                current_name = $(cloned).data('card-name');
                if($('#cards_list .card').size() == 0) $('#cards_list').append(cloned);
                else {
                    i = 0;
                    $('#cards_list .card').each(function() {
                        mana_cost = parseInt($(this).attr('class').split(' ')[1].split('_')[1]);
                        name = $(this).data('card-name');
                        if(current_mana_cost < mana_cost) {
                            $(this).before($(cloned));
                            return false;
                        }
                        else if(current_mana_cost == mana_cost && current_name < name) {
                            $(this).before($(cloned));
                            return false;
                        }
                        i += 1;
                    });
                    if($('#cards_list .card').size() == i) $('#cards_list').append(cloned);
                }
            }
        }
        else if($(this).hasClass('single')) {
            if(amount >= 30 || $(this).closest('.card').hasClass('Legendary')) {
                $(this).removeClass('single').addClass('none');
                $(this).closest('div').children('input').val(0);
                $('#card_amount').html(amount - 1);

                $(this).mana_curve(-1)

                lastClass = $(this).closest('.card').attr('class').split(' ').pop();
                $('#cards_list .' + lastClass).remove();
            }
            else {
                $(this).removeClass('single').addClass('double');
                $(this).closest('div').children('input').val(2);
                $('#card_amount').html(amount + 1);

                $(this).mana_curve(1)

                lastClass = $(this).closest('.card').attr('class').split(' ').pop();
                $('#cards_list .' + lastClass + ' label').addClass('double');
            }
        }
        else if($(this).hasClass('double')) {
            $(this).removeClass('double').addClass('none');
            $(this).closest('div').children('input').val(0);
            $('#card_amount').html(amount - 2);

            $(this).mana_curve(-2)

            lastClass = $(this).closest('.card').attr('class').split(' ').pop();
            $('#cards_list .' + lastClass).remove();
        }
    });

    $('#tabs-content .costs label').click(function(e) {
        e.preventDefault();
        if($(this).hasClass('none')) {
            $(this).removeClass('none').addClass('single');
            $(this).closest('div').children('input').val(1).attr('checked', true);
        }
        else if($(this).hasClass('single')) {
            if($(this).closest('.card').hasClass('Legendary')) {
                $(this).removeClass('single').addClass('none');
                $(this).closest('div').children('input').val(0);
            }
            else {
                $(this).removeClass('single').addClass('double');
                $(this).closest('div').children('input').val(2);
            }
        }
        else {
            $(this).removeClass('double').addClass('none');
            $(this).closest('div').children('input').val(0);
        }
    });

    $('#deck .cards .card label').click(function(e) {
        e.preventDefault();
        if($(this).hasClass('none')) {
            $(this).removeClass('none').addClass('single');
            $(this).closest('div').children('input').val(1).attr('checked', true);
        }
        else if($(this).hasClass('single')) {
            if($(this).closest('.card').hasClass('Legendary')) {
                $(this).removeClass('single').addClass('none');
                $(this).closest('div').children('input').val(0);
            }
            else {
                $(this).removeClass('single').addClass('double');
                $(this).closest('div').children('input').val(2);
            }
        }
        else {
            $(this).removeClass('double').addClass('none');
            $(this).closest('div').children('input').val(0);
        }
    });

    $('select#deck_playerClass').on('change', function() {
        $('#card_amount').html('0');
        mana_curve_reset();

        $('#new-cards-tabs li.is-active a').attr('aria-selected', false);
        $('#new-cards-tabs li.is-active').removeClass('is-active');
        $('#new-cards-tabs li.visibled').hide();

        $('#new-cards-tabs li.' + this.value + ' a').attr('aria-selected', true);
        $('#new-cards-tabs li.' + this.value).show().addClass('is-active visibled');

        $('#new-tabs-content .is-active').attr('aria-hidden', true).removeClass('is-active');

        $('#new-tabs-content #' + $('#new-cards-tabs li.' + this.value + ' a').attr('aria-controls')).attr('aria-hidden', false).addClass('is-active');

        $('#new-tabs-content .tabs-panel label').removeClass('single').removeClass('double').removeClass('none').addClass('none');
        $('#new-tabs-content .tabs-panel input').val(0);

        $('#cards_list .card').remove();
    });

    $('select#deck_formats').on('change', function() {
        $('#card_amount').html('0');
        mana_curve_reset();
        
        $('#new-tabs-content .tabs-panel label').removeClass('single').removeClass('double').removeClass('none').addClass('none');
        $('#new-tabs-content .tabs-panel input').val(0);
        
        if(this.value == 'standard') $('.costs .wild').hide();
        else $('.costs .wild').show();

        $('#cards_list .card').remove();
    });

    $('#mana_cost').on('change', function() {
        mana = this.value;
        if(mana == '') $('.costs').show();
        else {
            $('.costs').hide();
            $('.cost_' + mana).show();
        }
    });

    $('#collection').on('change', function() {
        collection = this.value;
        if(collection == '') $('.card').show();
        else {
            $('.card').hide();
            $('.card.' + collection.split(' ').join('_')).show();
        }
    });

    $('#free_existed').on('click', function(e) {
        e.preventDefault();
        $('.card.Free input').val(2).prop('checked', true);
        $('.card.Free label').removeClass('none').removeClass('single').removeClass('double').addClass('double');
    });

    $('.class_existed').on('click', function(e) {
        e.preventDefault();
        name = $(this).attr('class').split(' ').pop();
        $('.' + name + ' input').val(2).prop('checked', true);
        $('.' + name + ' label').removeClass('none').removeClass('single').removeClass('double').addClass('double');
        $('.' + name + ' .Legendary input').val(1).prop('checked', true);
        $('.' + name + ' .Legendary label').removeClass('none').removeClass('single').removeClass('double').addClass('single');
    });

    $('.class_unexisted').on('click', function(e) {
        e.preventDefault();
        name = $(this).attr('class').split(' ').pop();
        $('.' + name + ' input').val(0);
        $('.' + name + ' label').removeClass('none').removeClass('single').removeClass('double').addClass('none');
    });

    $('.card').mouseenter(function() {
        $(this).children('.card_caption').show();
    }).mouseleave(function() {
        $(this).children('.card_caption').hide();
    });

    $('.duplicate_exchange').click(function(e) {
        var formsOnPage, newNestedForm;
        e.preventDefault();
        nestedExchange = $(this).closest('.exchanges').children('.pos').last();
        newNestedForm = $(nestedExchange).clone();
        formsOnPage = $(nestedExchange).data("position") + 1;
        $(newNestedForm).attr('data-position', formsOnPage);    
        $(newNestedForm).find('input').each(function() {
            var newId, newName, oldId, oldName;
            oldId = $(this).attr('id');
            newId = oldId.replace(oldId.split('_').pop(), formsOnPage);
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.replace(oldName.split('_').pop(), formsOnPage + "]");
            $(this).attr('name', newName);
            $(this).val('');
        });
        $(newNestedForm).insertAfter(nestedExchange);
    });

    $('#exchanges').on('click', '.remove_exchange', function(e) {
        e.preventDefault();
        if($(this).closest('.exchanges').children('.pos').length != 1) {
            $(this).closest('.pos').remove();
        }
    });

    $('.duplicate_line').click(function(e) {
        var formsOnPage, newNestedForm;
        e.preventDefault();
        nestedExchange = $(this).closest('.lines').children('.pos').last();
        newNestedForm = $(nestedExchange).clone();
        formsOnPage = $(nestedExchange).data('position') + 1;
        $(newNestedForm).attr('data-position', formsOnPage);    
        $(newNestedForm).find('input').each(function() {
            var newId, newName, oldId, oldName;
            oldId = $(this).attr('id');
            newId = oldId.replace(oldId.split('_').pop(), formsOnPage);
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.replace(oldName.split('_').pop(), formsOnPage + "]");
            $(this).attr('name', newName);
            $(this).val('');
        });
        $(newNestedForm).insertAfter(nestedExchange);
    });

    $('#lines').on('click', '.remove_line', function(e) {
        e.preventDefault();
        if($(this).closest('.lines').children('.pos').length != 1) {
            $(this).closest('.pos').remove();
        }
    });
});