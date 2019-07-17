Б
<div id="cool-container">
	<div id="cool-menu"></div>
	<div id="cool-calc">
		<div id="tigr-canvas">
			<canvas style="border:2px solid black;" id='canvas'>TIGR!!! RRR!!!</canvas>
		</div>
		<div id="tigr-bottom">
			<div id="cool-social">Социальные тигры</div>
			<div id="cool-price">
				Цена: <span id="tigr-price">123</span>
			</div>
			<div id="cool-buy"><input type="button" value="Тигровая кнопка"/></div>
		</div>
	</div>
	<div id="cool-mat">
		<div class="cool-mat-radio">
			<input 	type="radio" 
					name="stuff" 
					value="holst" 
					data-submenu-id="sub_holst"> Холст
		</div>
		<div class="cool-sub-mat" id="sub_holst">
			<div class="cool-better">
				БЛОК: Добавить текст о холсте, чем это выбор лучше. 
				БЛОК: Добавить текст о холсте, чем это выбор лучше. 
				БЛОК: Добавить текст о холсте, чем это выбор лучше. 
				БЛОК: Добавить текст о холсте, чем это выбор лучше.
			</div>
		</div>
		<div class="cool-mat-radio">
			<input 	type="radio" 
					name="stuff" 
					value="glass" 
					data-submenu-id="sub_glass"> Стекло
		</div>
		<div class="cool-sub-mat" id="sub_glass">
			<div class="cool-mat-options">
				Тип: <br/>
				<input	type="radio"
						name="glass_stuff"
						value="organic"
						checked> Органическое <br/>
				<input	type="radio"
						name="glass_stuff"
						value="silicat"> Кремнивое <br/>
				<hr/>
				Держатели: <br/>
				<input	type="radio"
						name="glass_holders"
						value="distance"> Дистанционные <br/>
				<input	type="radio"
						name="glass_holders"
						value="closely"
						checked> Вплотную <br/>
				<input	type="radio"
						name="glass_holders"
						value="without"> Без крепления <br/>
			</div>
			<div class="cool-better">
				БЛОК: Добавить текст о стекле, чем это выбор лучше. 
				БЛОК: Добавить текст о стекле, чем это выбор лучше. 
				БЛОК: Добавить текст о стекле, чем это выбор лучше. 
				БЛОК: Добавить текст о стекле, чем это выбор лучше.
			</div>
		</div>		
		<div class="cool-mat-radio">
			<input 	type="radio" 
					name="stuff" 
					value="vinil" 
					data-submenu-id="sub_vinil"> Винил
		</div>
		<div class="cool-sub-mat" id="sub_vinil">
			<div class="cool-better">
				БЛОК: Добавить текст о виниле, чем это выбор лучше. 
				БЛОК: Добавить текст о виниле, чем это выбор лучше. 
				БЛОК: Добавить текст о виниле, чем это выбор лучше. 
				БЛОК: Добавить текст о виниле, чем это выбор лучше.
			</div>
		</div>		
	</div>
</div>

<script>
	$(document).ready(function() {
		try {
			image("{$image}");
		} catch(err) {
			console.log(err);
		}
	});
</script>
