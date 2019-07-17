var cp;
$(document).ready(function(){

    /* Tooltip width and height creation*/
    $("body").append("<div id='sizetip'><span id='stW'>Ш: <i></i></span><span id='stH'>В: <i></i></span><span id='err'></span></div>");

    function htmlEntities(str) {
        return String(str).replace(/&amp;/g, '&').replace(/&lt;/g, '<').replace(/&gt;/g,'>').replace(/&quot;/g, '"');
    }
    if(typeof ex_splits != "undefined" && ex_splits.length > 10 && ex_splits != false && ex_splits.indexOf('width') > 0)
    {
       ex_splits = $.parseJSON(htmlEntities(ex_splits));
   }
   else
   {
    ex_splits = false;
}

var imgPoster = new Image();
if(typeof imgurl != "undefined"){
   imgPoster.src = imgurl; 
}
imgPoster.onload = function() {

    /* Loaded image cost */
    var imgRealPrice = 0;
    if(!$(".ty-breadcrumbs__a:contains(Фото загруженные пользователями)").length){
        imgRealPrice = v_pict_cost;
    }

    cp = new Poster({
        elem : document.querySelector('#canvas'),//dom-элемент
        elPrice : document.querySelector('#price'),//dom-элемент
        ex_splits: ex_splits,
        bg : imgPoster,
        canvasWidth : 640,//ширина холста
        canvasHeight : 640,//высота холста
        elGlassType: document.querySelector('#glass-id'),
        id: 1,//id шаблона
        scale: 5.5,//масштаб по умолчанию
        
        pict_cost: imgRealPrice,
        maket: maket_cost,
        pricePlastic: sm_plast,//стоимость кв метра печати на пластике
        pricePlasticM: profile_cost,//стоимость погонного метра профиля при печати на пластике
        priceGlass: sm_plexiglass,//стоимость кв метра печати на орг.стекле
        priceSilicate: sm_slglass,//стоимость кв метра печати на силикатном стекле
        priceCanvasFrame: stretcher_cost,//стоимость погонного метра подрамника при печати на холсте
        priceCanvasCornerFrame: stretcher_angle,//уголок подрамника
        priceCanvas: sm_canvas,//стоимость кв метра печати на холсте
        fasteningKitModule: fastener_cost,//комплетт крепежа на модуль
        fasteningKitGlass: holder_cost,//комплет держателей при печати на стекле
        varnishing: varnish_cost,//стоимость лакироваки, по умолчанию
        obr_akril: obr_akril_cost,//стоимость обработки акрила
        obr_silikat: obr_silikat_cost//стоимость обработки силиката
    });


    $.ceAjax(
        'request',
        fn_url('coolposter.get'),
        {
            callback: function (data) {
                try {
                    splits = $.parseJSON(data.cool_splits);
                    cp.init();
                    cp.setScale(5.5);
                    $("#scale-slipper").val(5.5);
                    $(".controller-info span").html("90");
                    cp.init(true);
                    $(".move-group-action,#scale-slipper,.picture-options-btn-prev,.picture-options-btn-next").removeAttr('disabled');
                } catch(err) {
                    console.log(err);
                }
            }
        });

    $( '#price' ).change(function() {
        $('#price-val').val(cp.getPrice(this.getAttribute('data-type')));
    });

    $("canvas").on('click', function(e) {
        e.preventDefault();
    });

    $("#scale-slipper").on('mouseup', function (){
        $("#price").html("...");
        cp.selectAll(false);
        cp.setScale($(this).val());
        setTimeout(function() {
            cp.setPrice();
        }, 500);
    });

    $("#scale-slipper").on('input', function() {
        $(".controller-info span").html(Math.round(650*$(this).val()*0.02636*0.95));
    });

    $("#return-size").on('click', function (e){
        e.preventDefault();
        cp.setScale(0);
        $("#scale-slipper").val(0);
    });

    $("#unlock-button").on('click', function(e) {
        e.preventDefault();
        $(this).attr("disabled", true);
        $(".move-group-action,#scale-slipper,.picture-options-btn-prev,.picture-options-btn-next").removeAttr('disabled');
        cp.init(true);
        $(".controller-info-unlock").slideDown(300);
    });

    $(".placeholder-type").on('click', function(e) {
        $("#price").html("...");
        cp.setPrice();
    });

    $(".align-action").on('click', function(e) {
        e.preventDefault();
        cp.align($(this).data('align'));

    });

    $(".move-group-action").on('click', function(e) {
        e.preventDefault();
        var $this = $(this);
        var active = $this.attr('data-active') == 'false';
        $this.attr('data-active', !active);
        cp.selectAll(!active);
    });

    view_material($('.choose-material-link'), $("#material-value"));

    $('.choose-material-link').on('click', function(e) {
        e.preventDefault();
        view_material($(this), $("#material-value"));
    });

    $('.choose-material-link').on('click', function(e) {
        e.preventDefault();
        $('#price').attr('data-type', $(this).data('type')).text(cp.getPrice($(this).data('type')));
    });

    setTimeout(function() {
        $(".choose-material-link")[0].click();
    }, 1000);
    
};

});

var view_material = function($option, $value) {
    $value.html($option.data('material'));
};

/* Edited */
$('body').on('click', '.choose-form-item', function() {
    $('.dropbox-choose-form').removeClass('active');
    $(this).find('.dropbox-choose-form').addClass('active');
    $('.dropbox-choose-form:not(.active)').hide();
    $(this).find('.dropbox-choose-form').toggle();
});     

/* Save all before Submit */
function saveAll() {
    $('#size-data').val($('#size-value').html()+' см');
    $('#form-name').val($('#templpate-value').html());
    $('#shutter').val($('.shuter-foot span').html());
    $('#price-val').val($('#price').html());
    var material = $("#material-value").html();
    $('.harOpen').next().find('.placeholder-type:checked').each(function( i ) {
      material+=" | "+$(this).data('type')+": "+$(this).val();
    });
    $("#material-val").val(material);
}