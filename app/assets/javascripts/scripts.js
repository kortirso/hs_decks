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

                cloned = $(this).closest('.card').clone();
                current_mana_cost = parseInt($(cloned).attr('class').split(' ')[1].split('_')[1]);
                current_name = $(cloned).data('card_name');
                if($('#cards_list .card').size() == 0) $('#cards_list').append(cloned);
                else {
                    i = 0;
                    $('#cards_list .card').each(function() {
                        mana_cost = parseInt($(this).attr('class').split(' ')[1].split('_')[1]);
                        name = $(this).data('card_name');
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

                lastClass = $(this).closest('.card').attr('class').split(' ').pop();
                $('#cards_list .' + lastClass).remove();
            }
            else {
                $(this).removeClass('single').addClass('double');
                $(this).closest('div').children('input').val(2);
                $('#card_amount').html(amount + 1);

                lastClass = $(this).closest('.card').attr('class').split(' ').pop();
                $('#cards_list .' + lastClass + ' label').addClass('double');
            }
        }
        else if($(this).hasClass('double')) {
            $(this).removeClass('double').addClass('none');
            $(this).closest('div').children('input').val(0);
            $('#card_amount').html(amount - 2);

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

    $('select#playerClass').on('change', function() {
        $('#card_amount').html('0');

        $('#new-cards-tabs li.is-active a').attr('aria-selected', false);
        $('#new-cards-tabs li.is-active').removeClass('is-active');
        $('#new-cards-tabs li.visibled').hide();

        $('#new-cards-tabs li.' + this.value + ' a').attr('aria-selected', true);
        $('#new-cards-tabs li.' + this.value).show().addClass('is-active visibled');

        $('#new-tabs-content .is-active').attr('aria-hidden', true).removeClass('is-active');

        $('#new-tabs-content #' + $('#new-cards-tabs li.' + this.value + ' a').attr('aria-controls')).attr('aria-hidden', false).addClass('is-active');

        $('#new-tabs-content .tabs-panel label').removeClass('single').removeClass('double').removeClass('none').addClass('none');
        $('#new-tabs-content .tabs-panel input').val(0);
    });

    $('select#formats').on('change', function() {
        $('#card_amount').html('0');
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

    $('#free_existed').on('click', function() {
        $('.card.Free input').val(2).prop('checked', true);
        $('.card.Free label').addClass('double');
    });
});