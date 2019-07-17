;

/*** /that's exactly your fucking script ***/

function image(src) {
	try {
		initCanvas(src);
		ip5SplitsRetrieveData();
	} catch(err) {
		console.log('image', err);
	}
}

function ip5SplitsRetrieveData() {
	$.ceAjax(
		'request',
		fn_url('coolposter.get'),
		{
			callback: function (data) {
				try {
					var splits = $.parseJSON(data.cool_splits);
					initMenu(splits);
				} catch(err) {
					console.log('ip5SplitsRetrieveData', err);
				}
			}
		});
}
var splits = $.parseJSON('[{"name":"Простые фигуры","splits":[{"id":"1","rectangles":[{"x":6.1139896373058,"y":10,"width":281.82696145101,"height":373.46468865742},{"x":313.60103626943,"y":10.91743119266,"width":277.07411777779,"height":370.71236113616}]},{"id":"2","rectangles":[{"x":10,"y":10,"width":574.8385734257,"height":176.21185014104},{"x":10.777202072539,"y":207.24770642202,"width":573.28417496204,"height":172.56161280304}]},{"id":"4","rectangles":[{"x":20.880829015544,"y":10,"width":182.3427284754,"height":372.54724620677},{"x":409.97409326425,"y":8.1651376146789,"width":171.88826862104,"height":376.21701568079},{"x":222.95336787565,"y":9.0825688073394,"width":167.57529750704,"height":374.38213105332}]},{"id":"5","rectangles":[{"x":10,"y":10,"width":574.06137420551,"height":107.39824533506},{"x":9.2227979274611,"y":135.77981651376,"width":574.83856201847,"height":111.0073621806},{"x":8.4455958549223,"y":266.88073394495,"width":574.06137420551,"height":112.00111035826}]}]},{"name":"\u0421\u043b\u043e\u0436\u043d\u044b\u0435 \u0444\u043e\u0440\u043c\u044b","splits":[{"id":"3","rectangles":[{"x":10,"y":10,"width":50,"height":50},{"x":261.03626943005,"y":276.05504587156,"width":50,"height":50},{"x":481.76165803109,"y":12.752293577982,"width":50,"height":50},{"x":269.58549222798,"y":32.018348623853,"width":50,"height":50}]}]},{"name":"\u042d\u043a\u0441\u043a\u043b\u044e\u0437\u0438\u0432","splits":[{"id":"6","rectangles":[{"x":9.9999999999999,"y":11.834862385321,"width":227.43245850626,"height":172.39233708965},{"x":10.777202072539,"y":199.90825688073,"width":225.86733795507,"height":172.76092609536},{"x":251.70984455959,"y":11.834862385321,"width":180.80170059098,"height":171.62443368025},{"x":252.48704663212,"y":201.74311926605,"width":178.45657180961,"height":171.13574526723},{"x":446.78756476684,"y":13.669724770642,"width":139.59455452207,"height":168.87197697164},{"x":448.34196891192,"y":204.49541284404,"width":137.2802967147,"height":167.97472067529}]}]}]');

function Poster(options) {
	var splitsHash = {},
		canvas = {};




	/** TODO LittleCanvas */
	function _getLittleCanvas(rectangles, id) {
		var canvasTemplate = document.createElement('canvas');
		var canvas = new fabric.StaticCanvas(canvasTemplate, {
			width: littleWidth,
			height: littleHeight,
			backgroundColor: littleCanvasColor
		});

		rectangles.forEach(function(item) {
			var shape = _getLittleShape(item);
			canvas.add(shape);
		});
	}
	function _getLittleShape(rect) {
		return new fabric.Rect({
			left: rect.x * xlScale,
			top: rect.y * ylScale,
			width: rect.width * xlScale,
			height: rect.height * ylScale,
			fill: '',
			stroke: 'black',
			strokeWidth: 1
		});
	}

	function _imageTemplateReset(shape) {
		shape.setWidth(shape.width * shape.scaleX);
		shape.setHeight(shape.height * shape.scaleY);
		shape.setScaleX(1);
		shape.setScaleY(1);
	}

	var module = this;
    module.PROPORTIONAL = 0.02636;
	module.history = [];
	module.blocked = true;
	module.scaleCanvas = options.scale;
	module.domElement = options.elem;
	module.image = options.bg;
	module.templateId = module.templateId || options.id;
	module.borderColor = 'rgb(100,200,200)';
	module.adhesionScale = 15;
	module.canvasWidth = options.canvasWidth;
	module.canvasHeight = options.canvasHeight;
    module.proportionalXY = module.canvasHeight / module.canvasWidth;
	module.realImage = new Image();
	module.realImage.src = module.image;
	module.realWidth = module.realImage.width * module.PROPORTIONAL;
	module.realHeight = module.realImage.height * module.PROPORTIONAL;
	module.realWidthView = module.realWidth;
	module.realHeightView = module.realHeight;
    module.scaleReal = module.realWidth / module.canvasWidth;

	/**
	 * Прорисовка шаблона
     */
	var _generateSplitsHash = function(data) {

		if (module.current >= 0) {
			splitsHash[module.templateId] = {
				canvas: canvas
			};
			splitsHash[module.templateId].rectangles = module.history[module.current];

			return;
		}

		data.forEach(function(item){
			item.splits.forEach(function(item){
				if (item.id != module.templateId) {
					return;
				}
				var id = item.id;
				splitsHash[id] = {
					canvas: canvas
				};
				splitsHash[id].rectangles = item.rectangles;
			});
		});
	};

	/**
	 * Метод обновляет положение прямоугольников
	 */
	function _updateCanvas(rect) {


		var shape = new fabric.Rect({
			left: rect.x ,
			top: rect.y ,
			width: rect.width,
			height: rect.height,
			fill: 'rgba(255,255,255,.2)',
			strokeWidth: 1,
			stroke: module.borderColor,
			lockRotation: true,
			hasRotatingPoint : false,
			cornerSize: 8
		});

		var _updateScale = function(that) {
			that.set('left', that.get('left') * module.scaleCanvas);
			that.set('top', that.get('top') * module.scaleCanvas);
			that.set('width', that.get('width') * module.scaleCanvas);
			that.set('height', that.get('height') * module.scaleCanvas);
		};

		shape.on('moving', function() {
			_checkBorders(this);
			_checkMatrix(this);
		});



		shape.on('scaling', function() {
			_imageTemplateReset(this);
			_checkMatrix(this);
			_checkScaleBorder(this);

		});


		/**
		 * Проверка границ холста с блоками
		 */
		var _checkBorders = function(that) {
			var params = {};
			_imageTemplateReset(that);
			params.width = that.get('width');
			params.height = that.get('height');
			params.left = that.get('left');
			params.right = that.get('left') + that.get('width');
			params.top = that.get('top');
			params.bottom = that.get('top') + that.get('height');

			if (params.left < 0) {
				that.set('left', 0);
			}
			if (params.right > canvas.getWidth()) {
				that.set('left', canvas.getWidth() - params.width);
			}
			if (params.top < 0) {
				that.set('top', 0);
			}
			if (params.bottom > canvas.getHeight()) {
				that.set('top', canvas.getHeight() - params.height);
			}

			canvas.forEachObject(function(item) {

				var itemParams = {};

				itemParams.width = item.get('width');
				itemParams.height = item.get('height');
				itemParams.top = item.get('top');
				itemParams.left = item.get('left');
				itemParams.right = itemParams.left + itemParams.width;
				itemParams.bottom = itemParams.height + itemParams.top;

				if (!(itemParams.left < 0 || itemParams.right > canvas.getWidth() || itemParams.top < 0 || itemParams.bottom > canvas.getHeight())) {
					/**
					 * Прилипание
					 */
					if (params.left - module.adhesionScale < itemParams.right && params.left + module.adhesionScale > itemParams.right) {
						that.left = itemParams.right;
					}
					if (params.right - module.adhesionScale < itemParams.left && params.right + module.adhesionScale > itemParams.left) {
						that.left = itemParams.left - that.width - 1;
					}
					if (params.top - module.adhesionScale < itemParams.bottom && params.top + module.adhesionScale > itemParams.bottom) {
						that.top = itemParams.bottom;
					}
					if (params.bottom + module.adhesionScale > itemParams.top && params.bottom - module.adhesionScale < itemParams.top) {
						that.top = itemParams.top - that.height;
					}

					/**
					 * Направляющие
					 */
					if (params.left - module.adhesionScale < itemParams.left && params.left + module.adhesionScale > itemParams.left) {
						that.left = itemParams.left;
					}
					if (params.right - module.adhesionScale < itemParams.right && params.right + module.adhesionScale > itemParams.right) {
						that.left = itemParams.right - that.width;
					}
					if (params.top - module.adhesionScale < itemParams.top && params.top + module.adhesionScale > itemParams.top) {
						that.top = itemParams.top;
					}
					if (params.bottom + module.adhesionScale > itemParams.bottom && params.bottom - module.adhesionScale < itemParams.bottom) {
						that.top = itemParams.bottom - that.height;
					}
				}
			});
		};

		/**
		 * Проверка границ блоков с блоками
         */
		var _checkMatrix = function() {

			canvas.forEachObject(function(thisElement) {
				var thisParams = {};

				thisParams.width = thisElement.get('width');
				thisParams.top = thisElement.get('top');
				thisParams.height = thisElement.get('height');
				thisParams.left = thisElement.get('left');
				thisParams.right = thisParams.left + thisParams.width;
				thisParams.bottom = thisParams.height + thisParams.top;

				var error = false;
				canvas.forEachObject(function(item) {

					if (item === thisElement) return;
					var itemParams = {};

					itemParams.width = item.get('width');
					itemParams.height = item.get('height');
					itemParams.top = item.get('top');
					itemParams.left = item.get('left');
					itemParams.right = itemParams.left + itemParams.width;
					itemParams.bottom = itemParams.height + itemParams.top;

					if (
						(thisParams.left < itemParams.right && thisParams.right > itemParams.left) &&
						(thisParams.top < itemParams.bottom && thisParams.bottom > itemParams.top)
					) {
						error = true;
					}
				});
				if (error) {
					thisElement.set('stroke', 'red');
				} else {
					thisElement.set('stroke', module.borderColor);
				}

			});
		};

		var _checkScaleBorder = function(thisElement) {

			var thisParams = {};
			thisParams.width = thisElement.get('width');
			thisParams.top = thisElement.get('top');
			thisParams.height = thisElement.get('height');
			thisParams.left = thisElement.get('left');
			thisParams.right = thisParams.left + thisParams.width;
			thisParams.bottom = thisParams.height + thisParams.top;

			if (thisParams.left <= 0 || thisParams.right >= canvas.getWidth()) {

			}

			if (thisParams.top <= 0 || thisParams.bottom >= canvas.getHeight()) {

			}
		};

		_updateScale(shape);
		canvas.add(shape);

	}

	/**
	 * Перерисовка картинки
	 */
	function _setBg() {
		if (module.image) {
			canvas.setBackgroundImage(module.image, function(){}, {
				width: module.canvasWidth,
				height: module.canvasHeight
			});
			canvas.renderAll();
		}
	}

	/**
	 * Перерисовка холста
	 */
	function _redraw(rectangles) {
		try {

			canvas.clear();
			_setBg(module.image);
			canvas.renderAll();

			rectangles.forEach(function(item){
				_updateCanvas(item);
			});
			console.log(rectangles);

		} catch(err) {
			console.log('_redraw', err);
		}
	}

	/**
	 *
	 * @param id
     */
	var _addShape = function(id) {
		try {
			var rectangles = splitsHash[id].rectangles;
			_redraw(rectangles);
		} catch(err) {
			console.log('_addShape', err);
		}
	};

	/**
	 * Рассчет стоимости
	 */
	var _calculateCoast = function(type, price) {
		var calculator = {},
			result;

		calculator.area = 0;
		calculator.perimeter = 0;
		calculator.countModules = canvas._objects.length;
        canvas.forEachObject(function(item){
            var perimeter = (item.get('width') + item.get('height')) * 2,
                area = item.get('width') * item.get('height');
            calculator.perimeter += perimeter;
            calculator.area += area;
        });

        calculator.area = calculator.area * module.PROPORTIONAL * module.scaleReal;
        calculator.perimeter = calculator.perimeter * module.PROPORTIONAL * module.scaleReal;
		if (type == 1) {
			result = price + calculator.area * options.pricePlastic + calculator.perimeter * options.pricePlasticM + calculator.countModules * options.fasteningKitModule;
		}
		if (type == 2) {
            result = price + calculator.area * options.priceCanvas + calculator.perimeter * options.priceCanvasFrame + calculator.countModules * options.priceCanvasCornerFrame + calculator.area * varnishing;
        }
		if (type == 3) {
            result = price + calculator.area * options.priceGlass + calculator.countModules * options.fasteningKitGlass;
        }
		if (type == 4) {
            result = price + calculator.area * options.priceGlass + calculator.countModules * options.priceSilicate;
        }
        return Math.round(result);
	};

	/**
	 * Добавление изменений в историю
     */
	var _updateHistory = function() {
		var current = canvas._objects;
		var step = [];
		if (current.length === 0) {
			return;
		}
		for(var key in current) {
			if (current.hasOwnProperty(key)) {
				step[key] = {};
				step[key].x = current[key].get('left');
				step[key].y = current[key].get('top');
				step[key].width = current[key].get('width');
				step[key].height = current[key].get('height');
			}
		}
		splitsHash[module.templateId].rectangles = step;
		module.history.push(step);
		module.current = module.history.length - 1;
	};

	/**
	 * Изменение выбранного шаблона прямоугольников
	 * @param id идентификатор шаблона
     */
	module.chooseTemplate = function(id){

		module.templateId = id || module.templateId;
		_generateSplitsHash(splits);
		_addShape(module.templateId);
	};

	/**
	 * Установка масштаба изображения
	 * @param scale коэфициент масштаба
     */
	this.setScale = function(scale){
		//canvas.trigger('mouse:up');

		scale = scale * 1;
		module.scaleCanvas = 1 - scale * 0.01;
        module.realWidthView = module.realWidth + scale;
		module.realHeightView = module.realHeight + scale * module.proportionalXY;
        module.scaleReal = module.realWidthView / module.canvasWidth;
        _generateSplitsHash(splits);
		_addShape(module.templateId);
	};

	/**
	 * Движение по истории - вперед
	 */
	this.historyNext = function() {
		if (module.current <= module.history.length - 2) {
			module.current = module.current + 1;
			_generateSplitsHash(splits);
			_addShape(module.templateId);
		}
	};

	this.getRealSize = function() {
		return [
			Math.round(module.realWidthView),
			Math.round(module.realHeightView)
		];
	};

	/**
	 * Движение по истории - назад
	 */
	this.historyPrev = function() {
		if (module.current >= 0) {
			module.current = module.current - 1;
			_generateSplitsHash(splits);
			_addShape(module.templateId);
		}
	};

	/**
	 * Возвращает все прямоугольники с координатами и размерами
     */
	this.getCoordinates = function() {
		return module.history[module.current];
	};

	this.getPrice = function(type) {
		return _calculateCoast(type, 100); //test
	};

//*************************************************************************************
	//Seydali++
	var _splitsHash = {};
	function _getLittleCanvas2(rectangles, id) {
		var canvasTempl = document.createElement('canvas');
		var wrapper = document.createElement('div');

		wrapper.id = id;
		$(wrapper).append(canvasTempl);
		$(wrapper).addClass('cool-wrapper');

		var canvas = new fabric.StaticCanvas(canvasTempl, {
			width: littleWidth,
			height: littleHeight,
			backgroundColor: littleCanvasColor
		});

		_splitsHash[id] = {
			canvas: canvas
		};

		$(rectangles).each(function() {
			var shape = getLittleShape(this);
			canvas.add(shape);
		});

		return wrapper;
	}
	//Seydali++
	module.initMenu =  function _initMenu(data) {
		_splitsHash = {};//Seydali++
		$('.choose-form-list').html('');

		$(data).each(function() {

			if (!this.splits.length) return;

			var header = document.createElement('span');
			var block = document.createElement('div');
			var subblock = document.createElement('ul');
			var namef = this.name;
			$(subblock).addClass('dropbox-choose-form');

			$(header).html(this.name);
			$(block).append(header);
			$(block).append(subblock);
			$(block).addClass('choose-form-item');
			$('.choose-form-list').append(block);

			$(this.splits).each(function() {
				var rectangles = this.rectangles;
				var id = this.id;
				var canvas = _getLittleCanvas2(rectangles, id);
				$(subblock).append(canvas);
				$(canvas).attr('namef', namef);

				_splitsHash[id].rectangles = rectangles;
				//cp.splitsHash[id];
			});
			//Seydali++
			$('.dropbox-choose-form .cool-wrapper').mouseenter(function(e) {
				var id = this.id;
				var canvas = _splitsHash[id].canvas;
				canvas.setBackgroundColor(
					littleCanvasHover,
					canvas.renderAll.bind(canvas)
				);
			});
			$('.dropbox-choose-form .cool-wrapper').mouseout(function(e) {
				var id = this.id;
				var canvas = _splitsHash[id].canvas;
				canvas.setBackgroundColor(
					littleCanvasColor,
					canvas.renderAll.bind(canvas)
				);
			});
			//Seydali++

			$('.dropbox-choose-form .cool-wrapper').click(function(e) {
				module.current =-1;
				module.history=[];
				module.chooseTemplate(this.id);
				$('#form-name').val($(this).attr("namef"));

			});

		});
	}




















	/**
	 * Инициализация модуля
	 */
	this.init = function (unlock) {




		_generateSplitsHash(splits);
		this.initMenu(splits);

		if (unlock) {
			canvas = new fabric.Canvas(module.domElement, {
				selection: false
			});
			canvas.on('mouse:up', function() {
				_updateHistory(this);
			});
		} else {
			canvas = new fabric.StaticCanvas(module.domElement, {
				selection: false
			});
		}
		_setBg(module.image);
		_addShape(module.templateId);

		/** crutch */
		setTimeout(function(){
			module.chooseTemplate();
		},10);



	};
}