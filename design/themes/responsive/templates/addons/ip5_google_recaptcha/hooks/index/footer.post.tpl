{if $addons.ip5_google_recaptcha.key}
<script>
    var recaptcha;
    var myCallBack = function() {
        $('.g_recaptcha').each(function(i, elm) {
            recaptcha = grecaptcha.render($(elm).attr('id'), {
                'sitekey' : '{$addons.ip5_google_recaptcha.key}',
                'theme' : '{$addons.ip5_google_recaptcha.theme}',
                'type': '{$addons.ip5_google_recaptcha.type}'
            });  
        });
        (function(_, $){
            $.ceEvent('on', 'ce.dialogshow', function(context) {        
                context.find('.g_recaptcha').each(function () {
                    if($.trim($(this).html())=='') {
                        recaptcha = grecaptcha.render($(this).attr('id'), {
                        'sitekey' : '{$addons.ip5_google_recaptcha.key}',
                        'theme' : '{$addons.ip5_google_recaptcha.theme}',
                        'type': '{$addons.ip5_google_recaptcha.type}'
                        });
                    }
                });
            });
            $.ceEvent('on', 'ce.commoninit', function(context) {
                context.find('.g_recaptcha').each(function () {
                    if($.trim($(this).html())=='') {
                        recaptcha = grecaptcha.render($(this).attr('id'), {
                        'sitekey' : '{$addons.ip5_google_recaptcha.key}',
                        'theme' : '{$addons.ip5_google_recaptcha.theme}',
                        'type': '{$addons.ip5_google_recaptcha.type}'
                        });
                    }
                });
            });    
        })(Tygh, Tygh.$); 
    };
</script>
<script src="//www.google.com/recaptcha/api.js?onload=myCallBack&render=explicit&hl={$smarty.const.CART_LANGUAGE}" async defer></script>
{/if}
