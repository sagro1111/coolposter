<div class="ty-search-block">
	<form action="{"?dispatch=coolposter.view"|fn_url}" name="search_form" method="get">
		{hook name="search:additional_fields"}{/hook}
		{strip}
			<input	type="text"
				name="search"
				value="{$search.q}"
				id="search_input{$smarty.capture.search_input_id}"
				class="ty-search-block__input cm-hint"
				placeholder="Что будем искать ?" />

			{include	file="buttons/magnifier.tpl"
						but_name="coolposter.view"
						alt=__("search")}
		{/strip}
	</form>
</div>
