$.fn.mana_curve = function (amount) {
    mana = this.data('mana');
    if(mana > 7) mana = 7;
    mana_curve = $('#mana_curve #mana_' + mana + ' .count');
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
    $('#new-cards-tabs li.Neutral').show();

    select_value = $('#deck_playerClass').val();
    if(select_value == 'Warrior' || select_value == 'Hunter' || select_value == 'Paladin') {
        $('.card.Grimy_Goons').show();
        $('.card.Jade_Lotus').hide();
        $('.card.Kabal').hide();
    }
    else if(select_value == 'Shaman' || select_value == 'Druid' || select_value == 'Rogue') {
        $('.card.Grimy_Goons').hide();
        $('.card.Jade_Lotus').show();
        $('.card.Kabal').hide();
    }
    else if(select_value == 'Mage' || select_value == 'Warlock' || select_value == 'Priest') {
        $('.card.Grimy_Goons').hide();
        $('.card.Jade_Lotus').hide();
        $('.card.Kabal').show();
    }

    $('#cards_list').on('click', '.remove_card', function(e) {
        card_class = $(this).closest('.card').attr('class').split(' ').pop();
        object = $('.right_side').find('.' + card_class + ' label');

        amount = parseInt($('#card_amount').html());
        if ($(object).hasClass('double')) {
            $('#card_amount').html(amount - 2);
            $(object).mana_curve(-2);
            $(object).removeClass('double').addClass('none');
        }
        else if ($(object).hasClass('single')) {
            $('#card_amount').html(amount - 1);
            $(object).mana_curve(-1);
            $(object).removeClass('single').addClass('none');
        }

        $(object).closest('div').children('input').val(0);
        $('#cards_list .' + card_class.split(' ').pop()).remove();
    });

    $('#new-tabs-content .costs label').click(function(e) {
        e.preventDefault();
        amount = parseInt($('#card_amount').html());
        if($(this).hasClass('none')) {
            if(amount < 30) {
                $(this).removeClass('none').addClass('single');
                $(this).closest('div').children('input').val(1).attr('checked', true);
                $('#card_amount').html(amount + 1);

                $(this).mana_curve(1);

                cloned = $(this).closest('.card').clone();
                $(cloned).append('<span class="remove_card">x</span>');
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

                $(this).mana_curve(-1);

                lastClass = $(this).closest('.card').attr('class').split(' ').pop();
                $('#cards_list .' + lastClass).remove();
            }
            else {
                $(this).removeClass('single').addClass('double');
                $(this).closest('div').children('input').val(2);
                $('#card_amount').html(amount + 1);

                $(this).mana_curve(1);

                lastClass = $(this).closest('.card').attr('class').split(' ').pop();
                $('#cards_list .' + lastClass + ' label').addClass('double');
            }
        }
        else if($(this).hasClass('double')) {
            $(this).removeClass('double').addClass('none');
            $(this).closest('div').children('input').val(0);
            $('#card_amount').html(amount - 2);

            $(this).mana_curve(-2);

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

    $('#cards_collection ul li a').on('click', function() {
        $('#cards_collection ul li.is-active a').attr('aria-selected', false);
        $('#cards_collection ul li.is-active').removeClass('is-active');

        $('#cards_collection ul li.' + this.id + ' a').attr('aria-selected', true);
        $('#cards_collection ul li.' + this.id).show().addClass('is-active');

        $('#cards_collection .tabs-content .is-active').attr('aria-hidden', true).removeClass('is-active');
        $('#' + $('#cards_collection ul li.' + this.id + ' a').attr('aria-controls')).attr('aria-hidden', false).addClass('is-active');
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

        if(this.value == 'Warrior' || this.value == 'Hunter' || this.value == 'Paladin') {
            $('#cards9 .card.Grimy_Goons').show();
            $('#cards9 .card.Jade_Lotus').hide();
            $('#cards9 .card.Kabal').hide();
        }
        else if(this.value == 'Shaman' || this.value == 'Druid' || this.value == 'Rogue') {
            $('#cards9 .card.Grimy_Goons').hide();
            $('#cards9 .card.Jade_Lotus').show();
            $('#cards9 .card.Kabal').hide();
        }
        else if(this.value == 'Mage' || this.value == 'Warlock' || this.value == 'Priest') {
            $('#cards9 .card.Grimy_Goons').hide();
            $('#cards9 .card.Jade_Lotus').hide();
            $('#cards9 .card.Kabal').show();
        }
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
            newId = oldId.split('_').slice(0, -1).join('_') + '_' +formsOnPage;
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.split('_')[0] + '_' + formsOnPage + ']';
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
            newId = oldId.split('_').slice(0, -1).join('_') + '_' +formsOnPage;
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.split('_')[0] + '_' + formsOnPage + ']';
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

    $('.duplicate_mulligan').click(function(e) {
        var formsOnPage, newNestedForm;
        e.preventDefault();
        nestedExchange = $(this).closest('.mulligans').children('.pos').last();
        newNestedForm = $(nestedExchange).clone();
        formsOnPage = $(nestedExchange).data("position") + 1;
        $(newNestedForm).attr('data-position', formsOnPage);    
        $(newNestedForm).find('select').each(function() {
            var newId, newName, oldId, oldName;
            oldId = $(this).attr('id');
            newId = oldId.split('_').slice(0, -1).join('_') + '_' +formsOnPage;
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.split('_')[0] + '_' + formsOnPage + ']';
            $(this).attr('name', newName);
            $(this).val('');
        });
        $(newNestedForm).insertAfter(nestedExchange);
    });

    $('#lines').on('click', '.remove_mulligan', function(e) {
        e.preventDefault();
        if($(this).closest('.mulligans').children('.pos').length != 1) {
            $(this).closest('.pos').remove();
        }
    });
});