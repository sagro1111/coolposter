$(document).ready(function(){

    var cp = new Poster({
        elem : document.querySelector('#canvas'),//dom-элемент
        bg   : imgurl,//'/img/img.jpg',//url картинки
        canvasWidth : 691,//ширина холста
        canvasHeight : 465,//высота холста
        splits: splits,//шаблоны
        id: 1,//id шаблона
        scale: 1,//масштаб по умолчанию
        pricePlastic: 100,//стоимость кв метра печати на пластике
        pricePlasticM: 100,//стоимость погонного метра профиля при печати на пластике
        priceGlass: 100,//стоимость кв метра печати на орг.стекле
        priceCanvasFrame: 100,//стоимость погонного метра подрамника при печати на холсте
        priceCanvasCornerFrame: 100,//уголок подрамника
        priceCanvas: 100,//стоимость кв метра печати на холсте
        priceSilicate: 100,//стоимость кв метра печати на силикатном стекле
        fasteningKitModule: 100,//комплет крепежа на модуль
        fasteningKitGlass: 100,//комплет держателей при печати на стекле
        varnishing: 100//стоимость лакироваки, по умолчанию
    });

    //===============================Seydali========================================
    $.ceAjax(
        'request',
        fn_url('coolposter.get'),
        {
            callback: function (data) {
                try {
                    splits = $.parseJSON(data.cool_splits);
                    cp.init();

                } catch(err) {
                    console.log('ip5SplitsRetrieveData', err);
                }
            }
        });
    var view_size_value = function($value, size) {
        $value.val(size[0] + " см x " + size[1] + " см");
    };

    //===============================Seydali========================================


    $("canvas").on('click', function(e) {
        e.preventDefault();
    });

    $('.picture-options-btn-prev').on('click', function (e) {
        e.preventDefault();
        cp.historyPrev();
    });

    $('.picture-options-btn-next').on('click', function (e) {
        e.preventDefault();
        cp.historyNext();
    });

    $("#scale-slipper").on('input', function (){
        cp.setScale($(this).val());
        view_size($('#size-value'), cp.getRealSize());
        view_size_value($('#size-data'), cp.getRealSize());
    });

    $("#unlock-button").on('click', function(e) {
        e.preventDefault();
        cp.init(true);
    });

    view_material($('.choose-material-link'), $("#material-value"));

    $('.choose-material-link').on('click', function(e) {
        e.preventDefault();
        view_material($(this), $("#material-value"));
    });

    view_size($('#size-value'), cp.getRealSize());
    view_size_value($('#size-data'), cp.getRealSize());
});

var view_size = function($value, size) {
    $value.html(size[0] + " см x " + size[1] + " см");
};


var view_material = function($option, $value) {
    $value.html($option.html());
};