<script>
$(document).ready(function () {
   
        $.widget("ui.dialog", $.ui.dialog, {
            _allowInteraction: function (event) {
                //This function fixes issue with IE11 not able to verify Recaptcha v2
                if (this._super(event)) {
                    return true;
                }
                // address interaction issues with general iframes with the dialog
                if (event.target.ownerDocument != this.document[0]) {
                    return true;
                }

                // address interaction issues with iframe based drop downs in IE
                if ($(event.target).closest("iframe").length) {
                    return true;
                }
            }
        });
       
});
</script>
