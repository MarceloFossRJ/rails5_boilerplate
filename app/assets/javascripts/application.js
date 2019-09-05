// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery3
//= require popper.min
//= require jquery_ujs
//= require turbolinks
//= require bootstrap.min
//= require_tree .
//= require bootstrap-datepicker

//datepicker
//$(document).ready(function(){
$(document).on ("turbolinks:load", function() {
    $('.datepicker').datepicker({
        autoclose: true,
        todayBtn: true,

        clearBtn: true,
        todayHighlight: true
    });
});


//master detail forms
$(document).on('turbolinks:load', function() {

    $('form').on('click', '.remove_record', function(event) {
        $(this).prev('input[type=hidden]').val('1');
        $(this).closest('tr').hide();
        return event.preventDefault();
    });

    $('form').on('click', '.add_fields', function(event) {

        var regexp, time;
        time = new Date().getTime();
        regexp = new RegExp($(this).data('id'), 'g');
        //alert($(this).data('fields').replace(regexp, time));
        $('.fields').append($(this).data('fields').replace(regexp, time));
        return event.preventDefault();
    });

});

// filter on collection expense_category to expense_type
$(document).on('turbolinks:load', function() {
    var expense_types;
    expense_types = $('#expense_expense_type_id').html();
    console.log(expense_types);
    //alert(expense_types);
    $('form').on('change', '#expense_expense_category_id', function(event) {
        var categoria, options;
        categoria = $('#expense_expense_category_id :selected').text();
        options = $(expense_types).filter("optgroup[label=" + categoria + "]").html();
        console.log(options);
        if (options) {
            return $('#expense_expense_type_id').html(options);
        } else {
            return $('#expense_expense_type_id').empty();
        }
    });
});

//image_preview
$(document).on('turbolinks:load', function() {
    function readURL(input) {
        if (input.files && input.files[0]) {
            var reader = new FileReader();
            reader.onload = function (e) {
                $('#img_prev').attr('src', e.target.result);
            }
            reader.readAsDataURL(input.files[0]);
        }
    }
    $('form').on('change', '#expense_receipt', function(event) {
        $('#img_prev').removeClass('hidden');
        readURL(this);
    });
});

