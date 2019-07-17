function Poster(options) {
	var splitsHash = {},
	canvas = {},
	lastActiveRect = null;

	var module = this;

	module.ratioW = options.bg.width;
	module.ratioH = options.bg.height;

	module.prop = module.ratioW/module.ratioH;
	if (module.prop > 1) {
		module.imageWidth = options.canvasWidth;
		module.imageHeight = options.canvasWidth/module.prop;

		module.canvasWidth = options.canvasWidth;
		module.canvasHeight = options.canvasWidth/module.prop;
	}else{
		module.imageWidth = options.canvasWidth;
		module.imageHeight = options.canvasWidth*module.prop;

		module.canvasWidth = options.canvasWidth;
		module.canvasHeight = options.canvasWidth*module.prop;
	}

	$("#canvas").parent().css({"height":module.canvasHeight+50});

	module.ex_splits = options.ex_splits;
	module.saved_ex = options.ex_splits;
	module.formChosen = false;
	module.scaleSizes = 1;
	module.PROPORTIONAL =  0.02636;
	module.DE_PROPORTIONAL =  37.79527;
	module.history = [];
	module.blocked = true;
	module.domElementCanvas = options.elem;
	module.domElementPrice = options.elPrice;
	module.image = options.bg.src;
	module.templateId = module.templateId || options.id;
	module.borderColor = 'rgba(26,67,125,1)';
	module.adhesionScale = 10;
	module.proportionalXY = module.canvasHeight / module.canvasWidth;
	module.realImage = options.bg;
	module.offsetX = 25;
	module.offsetY = 25;
	module.littleWidth = 150;
	module.littleHeight = 120;
	module.littleCanvasColor = 'rgba(255,0,255,1)';
	module.littleCanvasHoverColor = 'rgba(255,255,0,1)';
	module.littleScaleX = module.littleWidth / module.canvasWidth;
	module.littleScaleY = module.littleHeight / module.canvasHeight;
	module.propKoef = (module.realImage.width-options.canvasWidth>module.realImage.height-options.canvasHeight?options.canvasWidth/module.realImage.width:options.canvasHeight/module.realImage.height);
	module.propHeight=module.propKoef*module.realImage.height;
	module.propWidth=module.propKoef*module.realImage.width;
	/* Area and Perimeter */
	module.square = 0;
	module.printHeight = 0;
	module.printWidth = 0;
	/* History */
	module.isMoved = false;
	module.isPressed = false;
	/* Group Params */
	module.isGrouped = 0;
	module.groupCurrent = [];
	fabric.Group.prototype.lockScalingX = true;
	fabric.Group.prototype.lockScalingY = true;

	/** Прорисовка шаблона */
	var _generateSplitsHash = function(data) {
		if (module.current >= 0) {
			splitsHash[module.templateId].rectangles = module.history[module.current];
			return;
		}
		data.forEach(function(item){
			item.splits.forEach(function(item){
				if (item.id != module.templateId) {
					return;
				}
				var id = item.id;
				splitsHash[id] = {};
				splitsHash[id].rectangles = item.rectangles;
				$('#splits-coord').val(JSON.stringify(splitsHash[id].rectangles));
				
				var res = splitsHash[id].rectangles;
				var resultParams = "Размер полотна: "+Math.round(module.imageWidth*module.PROPORTIONAL*module.scaleSizes)+"x"+Math.round(module.imageHeight*module.PROPORTIONAL*module.scaleSizes)+" см";
				for (var index = 0; index < res.length; index++) {
					var rx = Math.round(res[index].x*module.PROPORTIONAL*module.scaleSizes),
					ry = Math.round(res[index].y*module.PROPORTIONAL*module.scaleSizes),
					rw = Math.round(res[index].width*module.PROPORTIONAL*module.scaleSizes),
					rh = Math.round(res[index].height*module.PROPORTIONAL*module.scaleSizes);
					resultParams += ";"+(index+1)+" -> "+"x: "+rx+", y: "+ry+", Ширина: "+rw+", Высота: "+rh;
				}

				$('#splits-info').val(resultParams);
			});
		});
	};
	
	
	function _updateRuler() {

		var width = module.imageWidth;
		var height = module.imageHeight;
		var delW = parseInt(width*module.PROPORTIONAL);
		var delH = parseInt(height*module.PROPORTIONAL);
		var offsetXY = 25;
		var tickSize = 8;

		if ( module.scaleSizes <= 0 ) { module.scaleSizes = 1 }

			var line0X = new fabric.Line([offsetXY, offsetXY, width+25, offsetXY], { stroke: module.borderColor, selectable: false });
		var line0Y = new fabric.Line([offsetXY, offsetXY, offsetXY, height+25], { stroke: module.borderColor, selectable: false });
		canvas.add(line0X);
		canvas.add(line0Y);

		for (var i = 0; i < delH+1; i++) {

			var offset = i * module.DE_PROPORTIONAL + offsetXY;
			var line1 =	new fabric.Line([offsetXY - tickSize, offset, offsetXY, offset], { stroke: module.borderColor, selectable: false });
			
			var text1 = new fabric.Text(Math.round(i*module.scaleSizes) + "", {
				stroke: module.borderColor,
				left: offsetXY - (tickSize * 2) - 4,
				top: offset - tickSize/2,
				fontSize: 10,
				fontFamily: 'san-serif',
				selectable: false
			});

			canvas.add(line1);
			canvas.add(text1);
		}
		for (var i = 0; i < delW+1; i++) {

			var offset = i * module.DE_PROPORTIONAL + offsetXY;
			var line2 = new fabric.Line([offset, offsetXY - tickSize, offset, offsetXY], { stroke: module.borderColor, selectable: false });

			var text2 = new fabric.Text(Math.round(i*module.scaleSizes) + "", {
				stroke: module.borderColor,
				left: offset - 3,
				top: offsetXY - (tickSize * 2) - 4,
				fontSize: 10,
				fontFamily: 'san-serif',
				selectable: false
			});

			canvas.add(line2);
			canvas.add(text2);
		}
	}

	function _updateCanvas(rect) {

		var LabeledRect = fabric.util.createClass(fabric.Rect, {

			type: 'labeledRect',

			initialize: function(options) {
				options || (options = { });

				this.callSuper('initialize', options);
			},

			toObject: function() {
				return fabric.util.object.extend(this.callSuper('toObject'), {
					//label: this.get('label')
				});
			},

			_render: function(ctx) {
				this.callSuper('_render', ctx);


				if (this.get('active')) {
					ctx.fillStyle = module.borderColor;

					var w = this.width,
					h = this.height,
					x = -this.width / 2,
					y = -this.height / 2,
					length = 999;

					ctx.beginPath();

					ctx.moveTo(x, y + h);
					ctx.lineTo(x, length);

					ctx.moveTo(x + w, y + h);
					ctx.lineTo(x + w, length);

					ctx.moveTo(x + w, y);
					ctx.lineTo(length, y);

					ctx.moveTo(x + w, y + h);
					ctx.lineTo(length, y + h);

					ctx.moveTo(x, y);
					ctx.lineTo(x, -length);

					ctx.moveTo(x + w, y);
					ctx.lineTo(x + w, -length);

					ctx.moveTo(x , y);
					ctx.lineTo(-length, y);

					ctx.moveTo(x , y + h);
					ctx.lineTo(-length, y + h);

					ctx.stroke();
				}
			}
		});

		var rx = rect.x, ry = rect.y;

		if (module.isGrouped == 0) {
			rx = rect.x + module.offsetX;
			ry = rect.y + module.offsetY;
		}

		var shape = new LabeledRect({
			left: rx,
			top: ry,
			width: rect.width,
			height: rect.height,
			fill: 'rgba(255,255,255,0)',
			strokeWidth: 1,
			stroke: module.borderColor,
			lockRotation: true,
			hasRotatingPoint : false,
			cornerSize: 8,
			cornerColor: 'rgba(0,0,0,1)',
			scaleX: rect.scaleX || 1.0,
			scaleY: rect.scaleY || 1.0
		});

		/* Tooltip width and height */
		shape.on('mousemove', function(pos) {
			$("#sizetip").css('left',(pos.e.pageX+10)+'px').css('top',(pos.e.pageY-45)+'px');
			$("#sizetip").show();
			var rW = this.width*this.scaleX*module.PROPORTIONAL*module.scaleSizes;
			var rH = this.height*this.scaleY*module.PROPORTIONAL*module.scaleSizes;
			$("#stW i").html(rW.toFixed(0)+" см");
			$("#stH i").html(rH.toFixed(0)+" см");
			_check150(this);
		});

		shape.on('mouseout', function() {
			$("#sizetip").hide();
		});

		shape.on('moving', function() {
			_checkRectBorders(this);
			_checkMatrix(this);
			_check150(this);
			_checkS();
		});


		shape.on('scaling', function() {
			_checkMatrix(this);
			_checkRectScaleBorder(this);
			_check150(this);
			_checkS();
		});


		/* Пересчет площади */
		var _checkS = function() {
			module.square = 0;
			canvas.getObjects('labeledRect').forEach(function(item) {
				module.square += Math.round(item.get('width')*item.get('scaleX')*module.scaleSizes*module.PROPORTIONAL)*Math.round(item.get('height')*item.get('scaleY')*module.scaleSizes*module.PROPORTIONAL);
			});
			setSize(canvas.getObjects('labeledRect'));
		};

		/**  Проверка границ холста с блоками	 */
		var _checkRectBorders = function(that) {

			var params = {};
			params.width = that.get('width') * that.get('scaleX');
			params.height = that.get('height') * that.get('scaleY');
			params.left = that.get('left');
			params.top = that.get('top');
			params.right = params.left + params.width;
			params.bottom = params.top + params.height;

			if (params.left < module.offsetX) {
				that.set('left', module.offsetX);
			}
			if (params.right > canvas.getWidth()) {
				that.set('left', canvas.getWidth() - params.width);
			}
			if (params.top < module.offsetY) {
				that.set('top', module.offsetY);
			}
			if (params.bottom > canvas.getHeight()) {
				that.set('top', canvas.getHeight() - params.height);
			}

			module.square = 0;

			canvas.getObjects('labeledRect').forEach(function(item) {

				var itemParams = {}, borderSize = 1;

				itemParams.width = item.get('width') * item.get('scaleX');
				itemParams.height = item.get('height') * item.get('scaleY');
				itemParams.top = item.get('top');
				itemParams.left = item.get('left');
				itemParams.right = itemParams.left + itemParams.width;
				itemParams.bottom = itemParams.height + itemParams.top;

				if (!(itemParams.left < module.offsetX || itemParams.right > canvas.getWidth() || itemParams.top < module.offsetY || itemParams.bottom > canvas.getHeight())) {
					
					/** Направляющие */
					if (params.left - module.adhesionScale < itemParams.left && params.left + module.adhesionScale > itemParams.left) {
						that.left = itemParams.left;
					}
					if (params.right - module.adhesionScale < itemParams.right && params.right + module.adhesionScale > itemParams.right) {
						that.left = itemParams.right - params.width;
					}
					if (params.top - module.adhesionScale < itemParams.top && params.top + module.adhesionScale > itemParams.top) {
						that.top = itemParams.top;
					}
					if (params.bottom + module.adhesionScale > itemParams.bottom && params.bottom - module.adhesionScale < itemParams.bottom) {
						that.top = itemParams.bottom - params.height;
					}

					/** Прилипание */
					if (params.left - module.adhesionScale < itemParams.right && params.left + module.adhesionScale > itemParams.right) {
						that.left = itemParams.right;
					}
					if (params.right - module.adhesionScale < itemParams.left && params.right + module.adhesionScale > itemParams.left) {
						that.left = itemParams.left - params.width - borderSize * that.get('scaleX');
					}
					if (params.top - module.adhesionScale < itemParams.bottom && params.top + module.adhesionScale > itemParams.bottom) {
						that.top = itemParams.bottom;
					}
					if (params.bottom - module.adhesionScale < itemParams.top && params.bottom + module.adhesionScale > itemParams.top) {
						that.top = itemParams.top - params.height - borderSize * that.get('scaleY');
					}

				}
			});

		};

		
		/**	 * Проверка границ блоков с блоками    */
		var _checkMatrix = function() {

			canvas.getObjects('labeledRect').forEach(function(thisElement) {

				var thisParams = {};

				thisParams.width = thisElement.get('width') * thisElement.get('scaleX');
				thisParams.top = thisElement.get('top');
				thisParams.height = thisElement.get('height') * thisElement.get('scaleY');
				thisParams.left = thisElement.get('left');
				thisParams.right = thisParams.left + thisParams.width;
				thisParams.bottom = thisParams.height + thisParams.top;

				var error = false;
				canvas.getObjects('labeledRect').forEach(function(item) {

					if (item === thisElement) return;
					var itemParams = {};

					itemParams.width = item.get('width') * item.get('scaleX');
					itemParams.height = item.get('height') * item.get('scaleY');
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


		/* Ограничение одной стороны до 150 см*/
		var _check150 = function(thisElement){

			cmWidth = Math.round(thisElement.get('width')*thisElement.get('scaleX')*module.scaleSizes*module.PROPORTIONAL);
			cmHeight = Math.round(thisElement.get('height')*thisElement.get('scaleY')*module.scaleSizes*module.PROPORTIONAL);

			if (cmHeight >= 150) {
				if ( cmWidth > 150) {
					$("#err").text("Одна из сторон не должна превышать 150 см");
					thisElement.set('stroke', 'red');
				}
				else{
					if (cmWidth > 300 || cmHeight > 300) {
						$("#err").text("Максимальный размер одной стороны 300 см");
						thisElement.set('stroke', 'red');
					}else{
						thisElement.set('stroke', module.borderColor);
						$("#err").text("");
					}
				}	
			}else if (cmWidth >= 150) {
				if ( cmHeight > 150) {
					$("#err").text("Одна из сторон не должна превышать 150 см");
					thisElement.set('stroke', 'red');
				}
				else{
					if (cmWidth > 300 || cmHeight > 300) {
						$("#err").text("Максимальный размер одной стороны 300 см");
						thisElement.set('stroke', 'red');
					}else{
						thisElement.set('stroke', module.borderColor);
						$("#err").text("");
					}
				}	
			}


		}

		var _checkRectScaleBorder = function(thisElement) {

			var thisParams = {};
			thisParams.width = thisElement.get('width') * thisElement.get('scaleX');
			thisParams.top = thisElement.get('top');
			thisParams.height = thisElement.get('height') * thisElement.get('scaleY');
			thisParams.left = thisElement.get('left');
			thisParams.right = thisParams.left + thisParams.width;
			thisParams.bottom = thisParams.height + thisParams.top;
			var error = false;

			if (thisParams.left <= module.offsetX || thisParams.right >= canvas.getWidth()) {
				error = true;
			}

			if (thisParams.top <= module.offsetY || thisParams.bottom >= canvas.getHeight()) {
				error = true;
			}


			if (error) {
				thisElement.set('stroke', 'red');
			} else {
				thisElement.set('stroke', module.borderColor);
			}

		};

		canvas.add(shape);
	}


	/* Перерисовка картинки	 */
	function _setBg(callback) {
		var data2;
		fabric.Image.filters.Invertify = fabric.util.createClass({

			type: 'Invertify',

			inArea: function(group, items, e, width, height) {
				var x = (e % width ) / width * module.canvasWidth + module.offsetY,
				y = (Math.floor(e / width)) / height * module.canvasHeight + module.offsetY,
				result = false;
				items.forEach(function(item) {

					if ((item.rTop < y) && (y < item.rBottom) && (item.rLeft < x) && (x < item.rRight)) {
						result = true;
					}
				});
				return result;
			},

			applyTo: function(canvasEl) {
				var context = canvasEl.getContext('2d'),
				width = canvasEl.width;
				height = canvasEl.height;
				module.imageWidth = width;
				module.imageHeight = height;
				height = canvasEl.height;
				imageData = context.getImageData(0, 0, width, height);
				var data2=imageData.data;
				var context = canvasEl.getContext('2d'),

				width = canvasEl.width,
				height = canvasEl.height,
				imageData = context.getImageData(0, 0, width, height),
				data = imageData.data,
				iLen = data.length,
				items = canvas.getObjects('labeledRect'),
				group = canvas.getActiveGroup();
				items.forEach(function(item) {
					var width, height, top, left, right, bottom;

					if (!group) {
						left = item.get('left');
						top = item.get('top');
						width = item.get('width') * item.get('scaleX');
						height = item.get('height') * item.get('scaleY');
					}
					else {
						left = item.get('left') * group.get('scaleX') + group.get('left');
						top = item.get('top') * group.get('scaleY') + group.get('top');
						width = item.get('width') * item.get('scaleX') * group.get('scaleX');
						height = item.get('height') * item.get('scaleY') * group.get('scaleY');
					}

					right = left + width;
					bottom = top + height;

					item.set('rTop', top);
					item.set('rBottom', bottom);
					item.set('rLeft', left);
					item.set('rRight', right);
				});
				for (var i = 0; i < iLen; i += 4) {
					if (!this.inArea(group, items, i / 4, width, height)) {
						data[i] = 255;
						data[i + 1] = 255;
						data[i + 2] = 255;
					}
				}
				context.putImageData(imageData, 0, 0);
				$('#splits-img').val(canvasEl.toDataURL());

				for (var i = 0; i < iLen; i += 4) {
					if (!this.inArea(group, items, i / 4, width, height)) {
						data[i] = 255 - data2[i];
						data[i + 1] = 255 - data2[i + 1];
						data[i + 2] = 255 - data2[i + 2];
					}
				}
				context.putImageData(imageData, 0, 0);

			}

		});

		fabric.Image.filters.Invertify.fromObject = function(object) {
			return new fabric.Image.filters.Invertify(object);

		};


		if (module.image) {
			if (module.prop > 1) {
				var options = {
					left: module.offsetX,
					top: module.offsetY,
					width:  module.canvasWidth,
					height: module.canvasWidth/module.prop
				}
			}else{
				var options = {
					left: module.offsetX,
					top: module.offsetY,
					width:  module.canvasWidth,
					height: module.canvasWidth*module.prop
				}
			}
			

			canvas.setBackgroundImage(module.image, function() {
				canvas.backgroundImage.filters.push(new fabric.Image.filters.Invertify());
				callback && callback();
			}, options);


		}
	}

	/* Функция вывода размера и преобразования единиц */
	function setSize(rectangles){
		var mX,mY,minX = module.canvasWidth,maxX = module.offsetX,minY = module.canvasHeight,maxY = module.offsetY;
		rectangles.forEach(function(item){
			if (item.left == undefined) {
				if (item.scaleX == undefined || item.scaleY == undefined) {
					mX = 1;
					mY = 1;
				}else{
					mX = item.scaleX;
					mY = item.scaleY;
				}
				if (item.y < minY) {
					minY = item.y;
				}
				if (item.x < minX) {
					minX = item.x;
				}
				if (item.x+item.width*mX > maxX) {
					maxX = item.x+item.width*mX;
				}
				if (item.y+item.height*mY > maxY) {
					maxY = item.y+item.height*mY;
				}
			}else{
				if (item.scaleX == undefined || item.scaleY == undefined) {
					mX = 1;
					mY = 1;
				}else{
					mX = item.scaleX;
					mY = item.scaleY;
				}
				if (item.top-module.offsetY < minY) {
					minY = item.top-module.offsetY;
				}if (item.left-module.offsetX < minX) {
					minX = item.left-module.offsetX;
				}
				if (item.left-module.offsetX+item.width*mX > maxX) {
					maxX = item.left-module.offsetX+item.width*mX;
				}
				if (item.top-module.offsetY+item.height*mY > maxY) {
					maxY = item.top-module.offsetY+item.height*mY;
				}
			}
		});

		var rW = Math.round((maxX-minX)*module.scaleSizes*module.PROPORTIONAL),
		rH = Math.round((maxY-minY)*module.scaleSizes*module.PROPORTIONAL);

		$('#size-value').html(rW+"x"+rH).fadeIn(300);
		if (module.square >= 10000) {
			$('#size-value-real').html(module.square/10000+" м<sup>2</sup>");
		}else{
			$('#size-value-real').html(module.square+" см<sup>2</sup>");
		}

	}


	/** Перерисовка холста **/
	function _redraw(rectangles) {
		canvas.clear();
		_setBg(function(){
			_updateRuler();
			module.square = 0;
			rectangles.forEach(function(item){
				module.square += Math.round(item.width*module.scaleSizes*module.PROPORTIONAL)*Math.round(item.height*module.scaleSizes*module.PROPORTIONAL);
				_updateCanvas(item);
			});
			setSize(rectangles);
			canvas.renderAll();
			_updateFilter();
		});
	}

	// @param id
	var _addShape = function(id) {
		var rectangles;
		if (!module.ex_splits) {
			rectangles = splitsHash[id].rectangles;
		}else{
			rectangles = module.ex_splits;
			module.saved_ex = module.ex_splits;
			module.ex_splits = false;
		}
		_redraw(rectangles);
	};

	
	/** Рассчет стоимости */
	var _calculateCoast = function(type) {
		var calculator = {},

		result;

		// Площадь в сантиметрах в квадрате
		calculator.area = 0;

		// Периметр в сантиметрах в квадрате
		calculator.perimeter = 0;

		// Кол-во модулей
		calculator.countModules = 0;
		canvas.getObjects('labeledRect').forEach(function(item) {
			calculator.area += (Math.round(item.get('width')*item.get('scaleX')*module.scaleSizes*module.PROPORTIONAL)*Math.round(item.get('height')*item.get('scaleY')*module.scaleSizes*module.PROPORTIONAL))/10000;
			calculator.perimeter += ((Math.round(item.get('width')*item.get('scaleX')*module.scaleSizes*module.PROPORTIONAL)+Math.round(item.get('height')*item.get('scaleY')*module.scaleSizes*module.PROPORTIONAL))*2)/100;
			calculator.countModules += 1;
		});
		
		calculator.varnishing = options.varnishing;

		calculator.KitGlass = options.fasteningKitGlass;
		/*pict_cost: v_pict_cost,
        pricePlastic: sm_plast,//стоимость кв метра печати на пластике
        pricePlasticM: profile_cost,//стоимость погонного метра профиля при печати на пластике
        priceGlass: sm_plexiglass,//стоимость кв метра печати на орг.стекле
        priceSilicate: sm_slglass,//стоимость кв метра печати на силикатном стекле
        priceCanvasFrame: stretcher_cost,//стоимость погонного метра подрамника при печати на холсте
        priceCanvasCornerFrame: stretcher_angle,//уголок подрамника
        priceCanvas: sm_canvas,//стоимость кв метра печати на холсте
        fasteningKitModule: fastener_cost,//комплетт крепежа на модуль
        fasteningKitGlass: holder_cost,//комплет держателей при печати на стекле
        varnishing: varnish_cost//стоимость лакироваки, по умолчанию*/
        console.log(options);
		// Типы
		if (type == 1) {
			// Условия
			if ($("#ramka5").is(":checked")) {
				calculator.perimeter = 0;
			}
			result = options.maket + options.pict_cost + calculator.area * options.pricePlastic + calculator.perimeter * options.pricePlasticM + calculator.countModules * options.fasteningKitModule;
		}
		if (type == 2) {
			if ($("#holst_varnish1").is(":checked")) {
				calculator.varnishing = 0;
			}
			result = options.maket + options.pict_cost  + calculator.area * options.priceCanvas + calculator.perimeter * options.priceCanvasFrame + calculator.countModules * options.priceCanvasCornerFrame + calculator.area * calculator.varnishing;
		}
		if (type == 3) {
			if ($("#holder1").is(":checked")) {
				calculator.KitGlass = 0;
			}
			if ($("#glass-type1").is(":checked")) {
				result = options.maket + options.pict_cost + calculator.area * options.priceGlass + calculator.countModules * calculator.KitGlass + calculator.perimeter * options.obr_akril;
			}else if ($("#glass-type2").is(":checked")) {
				result = options.maket + options.pict_cost + calculator.area * options.priceSilicate + calculator.countModules * calculator.KitGlass + calculator.perimeter * options.obr_silikat;
			}
		}

		return Math.round(result);
	};

	/**
	 * Добавление изменений в историю
	 */
	 var _updateHistory = function() {
	 	if (module.isMoved && module.isPressed) {
	 		module.history = [];
	 		module.isMoved = false;
	 		module.isPressed = false;
	 	}
	 	var current;
	 	if (module.groupCurrent.length > 0) {
	 		current = module.groupCurrent;
	 	}else{
	 		current = canvas._objects;
	 	}
	 	var step = [];
	 	if (current.length === 0) {
	 		return;
	 	}
	 	for(var key in current) {
	 		if (current[key].get('type') === 'labeledRect') {
	 			if (current.hasOwnProperty(key)) {
	 				step[key] = {};
	 				step[key].x = current[key].get('left');
	 				step[key].y = current[key].get('top');
	 				step[key].width = current[key].get('width');
	 				step[key].height = current[key].get('height');
	 				step[key].scaleX = current[key].get('scaleX');
	 				step[key].scaleY = current[key].get('scaleY');

	 			}
	 		}
	 	}
	 	splitsHash[module.templateId].rectangles = step;
	 	module.history = [];
	 	module.history.push(step);
	 	module.current = 0;
	 };

	 var _updateFilter = function() {
	 	if (canvas.backgroundImage) {
	 		canvas.backgroundImage.applyFilters(function(){
	 			canvas.renderAll();

	 		});
	 	}
	 };

	/**
	 * Изменение выбранного шаблона прямоугольников
	 * @param id идентификатор шаблона
	 */
	 this.chooseTemplate = function(id){
	 	module.templateId = id || module.templateId;
	 	_generateSplitsHash(splits);
	 	_addShape(module.templateId);
	 };

	/**
	 * Установка масштаба изображения
	 * @param scale коэфициент масштаба
	 */
	 this.setScale = function(scale) {
	 	module.scaleSizes = scale;
	 	_updateRuler();
	 	//_generateSplitsHash(splits);
	 	_addShape(module.templateId);
	 };

	/**
	 * Возвращает все прямоугольники с координатами и размерами
	 */
	 this.getCoordinates = function() {
	 	return module.history[module.current];
	 };

	 this.getPrice = function(type) {

		return _calculateCoast(type); //test
	};

	this.saveCoords= function()	{
		var res = module.getCoordinates();
		if(res==undefined) return;
		res = res.filter(function(n){ return n != null });
		if(res) {
			var resultParams = "Размер полотна: "+Math.round(module.imageWidth*module.PROPORTIONAL*module.scaleSizes)+"x"+Math.round(module.imageHeight*module.PROPORTIONAL*module.scaleSizes)+" см";
			for (index = 0; index < res.length; index++) {
				res[index].x-=module.offsetX;
				res[index].y-=module.offsetY;
				var rx = Math.round(res[index].x*module.PROPORTIONAL*module.scaleSizes),
				ry = Math.round(res[index].y*module.PROPORTIONAL*module.scaleSizes),
				rw = Math.round(res[index].width*res[index].scaleX*module.PROPORTIONAL*module.scaleSizes),
				rh = Math.round(res[index].height*res[index].scaleY*module.PROPORTIONAL*module.scaleSizes);
				resultParams += ";"+(index+1)+" -> "+"x: "+rx+", y: "+ry+", Ширина: "+rw+", Высота: "+rh;
			}
			$('#splits-coord').val(JSON.stringify(res));
			$('#splits-info').val(resultParams);
		}
	}

	this.finalSave= function()	{
		var res = module.getCoordinates();
		if(res==undefined) return;
		res = res.filter(function(n){ return n != null });
		if(res) {
			var resultParams = "Размер полотна: "+Math.round(module.imageWidth*module.PROPORTIONAL*module.scaleSizes)+"x"+Math.round(module.imageHeight*module.PROPORTIONAL*module.scaleSizes)+" см";
			for (index = 0; index < res.length; index++) {
				var rx = Math.round(res[index].x*module.PROPORTIONAL*module.scaleSizes),
				ry = Math.round(res[index].y*module.PROPORTIONAL*module.scaleSizes),
				rw = Math.round(res[index].width*res[index].scaleX*module.PROPORTIONAL*module.scaleSizes),
				rh = Math.round(res[index].height*res[index].scaleY*module.PROPORTIONAL*module.scaleSizes);
				resultParams += ";"+(index+1)+" -> "+"x: "+rx+", y: "+ry+", Ширина: "+rw+", Высота: "+rh;
			}
			$('#splits-info').val(resultParams);
		}
	}

	this.setPrice = function() {
		module.domElementPrice.textContent = module.getPrice(module.domElementPrice.getAttribute('data-type'));
		$('#price-val').val(module.domElementPrice.textContent);
	};

	/**
	 * Выравнивание
	 */
	 this.align = function(type) {
	 	var rect = lastActiveRect;
	 	if (!(canvas.getObjects().indexOf(rect) >= 0)) {
	 		return;
	 	}
	 	canvas.getObjects('labeledRect').forEach(function(item) {

	 		if (item === rect) {
	 			return;
	 		}

	 		switch (type) {
	 			case 'top':
	 			item.set('top', rect.get('top'));
	 			break;
	 			case 'middle':
	 			item.set('left', rect.get('left') + rect.get('width') * rect.get('scaleX') / 2 - item.get('width') * item.get('scaleX') / 2);
	 			break;
	 			case 'justify':
	 			item.set('top', rect.get('top') + rect.get('height') * rect.get('scaleY') / 2 - item.get('height') * item.get('scaleY') / 2);
	 			break;
	 			case 'bottom':
	 			item.set('top', rect.get('top') + rect.get('height') * rect.get('scaleY') - item.get('height') * item.get('scaleY'));
	 			break;
	 			case 'left':
	 			item.set('left', rect.get('left'));
	 			break;
	 			case 'right':
	 			item.set('left', rect.get('left') + rect.get('width') * rect.get('scaleX') - item.get('width') * item.get('scaleX'));
	 			break;
	 		}

	 		item.setCoords();
	 		_updateFilter();

	 	});

	 };

	 this.active = function() {

	 	return (canvas.setActiveGroup);
	 };

	 this.selectAll = function(select) {

	 	if (!this.active()) {
	 		false;
	 	}

	 	if (select && (!canvas.getActiveGroup())) {

	 		var _checkGroupBorders = function(that) {

	 			var params = {};
	 			params.width = that.get('width') * that.get('scaleX');
	 			params.height = that.get('height') * that.get('scaleY');
	 			params.left = that.get('left') - params.width / 2;
	 			params.right = that.get('left') + params.width / 2;
	 			params.top = that.get('top') - params.height / 2;
	 			params.bottom = that.get('top') + params.height / 2;

	 			if (params.left < module.offsetX) {
	 				that.set('left', module.offsetX + params.width / 2);
	 			}
	 			if (params.right > canvas.getWidth()) {
	 				that.set('left', canvas.getWidth() - params.width / 2);
	 			}
	 			if (params.top < module.offsetY) {
	 				that.set('top', module.offsetY + params.height / 2);
	 			}
	 			if (params.bottom > canvas.getHeight()) {
	 				that.set('top', canvas.getHeight() - params.height / 2);
	 			}

	 		};

	 		var _checkGroupScaleBorder = function(that) {

	 			var params = {};
	 			params.width = that.get('width') * that.get('scaleX');
	 			params.height = that.get('height') * that.get('scaleY');
	 			params.left = that.get('left'); - params.width / 2;
	 			params.right = that.get('left'); + params.width / 2;
	 			params.top = that.get('top'); - params.height / 2;
	 			params.bottom = that.get('top'); + params.height / 2;

	 			var error = false;

	 			if (params.left <= module.offsetX || params.right >= canvas.getWidth()) {
	 				error = true;
	 			}

	 			if (params.top <= module.offsetY || params.bottom >= canvas.getHeight()) {
	 				error = true;
	 			}

	 			if (error) {
	 				that.set('stroke', 'red');
	 			} else {
	 				that.set('stroke', module.borderColor);
	 			}
	 		};

	 		var objs = canvas.getObjects('labeledRect').map(function(item) {
	 			return item.set('active', true);
	 		});

	 		var group = new fabric.Group(objs, {
	 			originX: 'center',
	 			originY: 'center'
	 		});

	 		module.isGrouped += 1;

	 		group.on('moving', function() {
	 			_checkGroupBorders(group);
	 		});

	 		group.on('scaling', function() {
	 			_checkGroupScaleBorder(group);
	 		});

	 		group.setControlsVisibility({
	 			mt: false, 
	 			mb: false, 
	 			ml: false, 
	 			mr: false, 
	 			bl: false,
	 			br: false, 
	 			tl: false, 
	 			tr: false,
	 			mtr: false, 
	 		});

	 		canvas.setActiveGroup(group).renderAll();

	 	} else {

	 		canvas.deactivateAllWithDispatch().renderAll();
	 	}
	 };

	 function _getLittleShape(rect) {

	 	return new fabric.Rect({
	 		left: rect.x * module.littleScaleX,
	 		top: rect.y * module.littleScaleY,
	 		width: rect.width * module.littleScaleX,
	 		height: rect.height * module.littleScaleY,
	 		fill: '',
	 		stroke: 'black',
	 		strokeWidth: 1
	 	});
	 }

	 function _getLittleCanvas(rectangles, id) {
	 	var canvasTemp = document.createElement('canvas');
	 	var wrapper = document.createElement('div');

	 	wrapper.id = id;
	 	$(wrapper).append(canvasTemp);
	 	$(wrapper).addClass('cool-wrapper');

	 	var canvas = new fabric.StaticCanvas(canvasTemp, {
	 		width: module.littleWidth,
	 		height: module.littleHeight,
	 		backgroundColor: module.littleCanvasColor
	 	});

	 	$(rectangles).each(function() {
	 		var shape = _getLittleShape(this);
	 		canvas.add(shape);
	 	});

	 	return wrapper;
	 }



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




	 function _initMenu (data) {
	 	_splitsHash = {};
	 	$('.choose-form-list').html('');

	 	$(data).each(function() {

	 		if (!this.splits.length) return;

	 		var header = document.createElement('span');
	 		var block = document.createElement('div');
	 		var subBlock = document.createElement('ul');
			//var namef = this.name;//
			$(subBlock).addClass('dropbox-choose-form');

			$(header).html(this.name);
			$(block).append(header);
			$(block).append(subBlock);
			$(block).addClass('choose-form-item');
			$('.choose-form-list').append(block);

			$(this.splits).each(function() {
				var rectangles = this.rectangles,
				id = this.id;
				$(subBlock).append(_getLittleCanvas2(rectangles, id));
				//$(canvas).attr('namef', namef);
			});
		});

	 	$("button[onclick='saveAll()']").on('click',function(){
	 		module.finalSave();
	 	});

	 	$('.dropbox-choose-form .cool-wrapper').click(function() {
	 		$("#ajax_loading_box").show();
	 		var form = $(this).parent('.dropbox-choose-form');
	 		form.css('display', 'none');
	 		module.current = -1;
	 		module.history = [];
	 		module.isGrouped = 0;
	 		module.groupCurrent = [];
	 		var form_name = form.prev().html();
	 		var putText = '';
	 		module.formChosen = true;

	 		switch(form_name){
	 			case 'Сложные формы':
	 			putText = 'Сложная';
	 			break;
	 			case 'Простые формы':
	 			putText = 'Простая';
	 			break;
	 			default:
	 			putText = 'Эксклюзив';
	 			break;
	 		}

	 		$("#templpate-value").html(putText);

	 		module.chooseTemplate(this.id);

	 		setTimeout(function(){
	 			$("#ajax_loading_box").hide();
	 			form.css('display', '');
	 			module.setPrice();
	 		}, 300);

	 	});
	 };


	/**
	 * Инициализация модуля
	 */
	 this.init = function (unlock) {
	 	_generateSplitsHash(splits);
	 	_initMenu(splits);
	 	module.isGrouped = 0;

	 	if (unlock) {
	 		canvas = new fabric.Canvas(module.domElementCanvas, {
	 			selection: false
	 		});
	 		/* Был удален метод mouse:up который сбивал всю историю */
	 		canvas.on('object:modified', function(e) {
	 			module.isMoved = true;
	 			_updateHistory();
	 			_updateFilter();
	 			module.setPrice();
	 			module.saveCoords();
	 		});
	 		canvas.on('object:selected', function(e) {
	 			lastActiveRect = e.target;
	 		});
	 		canvas.on('selection:cleared', function() {
	 			module.groupCurrent = [];
	 			if (module.isGrouped > 0) {
	 				canvas.deactivateAllWithDispatch().renderAll();
	 				canvas.getObjects('labeledRect').forEach(function(item) {
	 					module.groupCurrent.push(item);
	 				});
	 				_updateHistory();
	 			}
	 		});

	 		if (module.formChosen || !module.saved_ex) {
	 			_addShape(module.templateId);
	 		}else{
	 			_redraw(module.saved_ex);
	 		}
	 		
	 	} else {
	 		canvas = new fabric.StaticCanvas(module.domElementCanvas, {
	 			selection: false
	 		});

	 		module.saveCoords();
	 	}

	 };

	}