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
//= require jquery_ujs
//= require turbolinks
//= require moment
//= require popper
//= require bootstrap
//= require daterangepicker
//= require bootstrap-datepicker
//= require perfect-scrollbar
//= require sidebar.menu
//= require select2-full
//= require_tree .

function format(item) {
    if (!item.id) {
        return item.text;
    }
    var countryUrl = "https://lipis.github.io/flag-icon-css/flags/4x3/";
    var img = $("<img>", {
        class: "img-flag",
        width: 26,
        src: countryUrl + item.element.value.toLowerCase() + ".svg"
    });
    var span = $("<span>", {
        text: " " + item.text
    });
    span.prepend(img);
    return span;
}

$(document).on('turbolinks:load', function(){
    $("#countries").select2({
        theme: "bootstrap",
        templateResult: function(item) {
            return format(item);
        }
    });
});

$(document).on('turbolinks:load', function(){
    $(".select-2").select2({
        theme: "bootstrap",
        placeholder: "Choose currency"
    });
});


// pop-over initialization for every page
$(document).on('turbolinks:load', function(){
    $('[data-toggle="popover"]').popover();
});

// toggle menu sidebar
$(document).on ("turbolinks:load", function() {
    $('#sidebar').on('click', function() {
        $('#navigation').toggleClass('sidebar-toggle');
    });
});

// menu workspace selector
$(document).on ("turbolinks:load", function() {
    $('#workspace_selector').on('change', function() {
        var workspace = $( "#workspace_selector option:selected" ).val();
        var path = "http://" + workspace + "." + root_path;
        window.location.href=path;
    });
});

// highlight clicked item on sidebar menu
$(document).on ("turbolinks:load", function() {
    $('.list-link').on('click', function() {
        $(this).addClass('link-current');
    });
});

// turbolinks spinner when firing actions from buttons/links
$(document).on("turbolinks:visit", function(){
   $(".spinner").show();
});
$(document).on("turbolinks:load", function(){
   $(".spinner").hide();
});

// range-date-picker
$(document).on("turbolinks:load", function(){
    $('.daterange').daterangepicker({
        locale: { format: 'DD/MM/YYYY'},
        cancelLabel: 'Clear',
        startDate: ( moment.utc($('[data=begin_date]').val()).isValid() ) ? moment.utc($('[data=begin_date]').val()) : Date.now(),
        endDate: ( moment.utc($('[data=end_date]').val()).isValid() ) ? moment.utc($('[data=end_date]').val()) : Date.now()
    });
    $('[data-behavior=daterangepicker]').on('cancel.daterangepicker', function(){
        $(this).val(' ');
    });
    $('[data-behavior=daterangepicker]').on('change', function(){
        if ($(this).val().length !== 0 ) {
            var fullDate = $(this).val().split('-');
            var beginDate = fullDate[0].trim();
            var endDate = fullDate[1].trim();
            $('[data=begin_date]').val(beginDate);
            $('[data=end_date]').val(endDate);
        }
    });
});

//datepicker initialization properties
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
