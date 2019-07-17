<div class="clearfix">
	<div class="right-block-lb">
		<h2>Появились вопросы? Задайте по телефону</h2>
		<div class="home-info-phone">
			<span class="sprite-main phone-ico"></span>
			<span>{$settings.Company.company_phone}</span>
		</div>
		<div class="home-info-phone">
			<span class="sprite-main phone-ico"></span>
			<span>{$settings.Company.company_phone_2}</span>
		</div>
		<div class="home-info-support">
		Поддержка клиента в вашем распоряжении <br>с понедельника по пятницу с 10.00 до 19.00
		</div>
		
		<h2>Занято?</h2>
		<div class="write-us">
		Напишите нам: <a href="mailto:{$settings.Company.company_support_department}">{$settings.Company.company_support_department}</a> <br>или воспользуйтесь онлайн <br>консультантом в правом, нижнем углу.
		</div>
		
		<h3>НОВОСТИ И  СКИДКИ</h3>
		<div class="sub-us">Подпишитесь на рассылку и получите код-скидку!</div>
	</div>
	<div class="right-block-rb">
		<div id="vk_groups"></div>
	</div>
</div>


<div class="ty-footer-form-block no-help">

	<form action="{""|fn_url}" method="post" name="subscribe_form" class="cm-processed-form">
        <input type="hidden" name="redirect_url" value="{$config.current_url}" />
        <input type="hidden" name="newsletter_format" value="2" />
        <div class="ty-footer-form-block__form ty-control-group">
            <div class="ty-footer-form-block__input">
                <input type="text" name="subscribe_email" id="subscr_email{$block.block_id}" size="20" placeholder="{__("email")}" class="ty-valign-top cm-hint" />
	            {include file="buttons/button-subsc.tpl" but_role="submit" but_name="dispatch[newsletters.add_subscriber]" but_text=__("subscribe") but_meta="ty-btn__subscribe"}
    		</div>        
        </div>
    </form>
	
	<p>Ваши данные безопасны, Вы можете отказаться от рассылки в любой момент.</p>
</div>
