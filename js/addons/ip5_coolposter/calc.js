var splitsHash = {};

$(document).ready(function() {
	var menu = $("#cool-cat");

	menu.menuAim({
		activate: activateSubmenu,
		deactivate: deactivateSubmenu
	});

	function activateSubmenu(row) {
		try {
			// TODO: calculate during initiation
			var $row = $(row),
				submenuId = $row.data("submenuId"),
				$submenu = $("#" + submenuId),
				left = $row.find('a').width(),
				start = $row.find('a').offset().left;

			$submenu.css({
				display: "inline-block",
				left: start + left + 10
			});
			//console.log('active' + submenuId);
		} catch(err) {
			console.log(err);
		}
	}
	function deactivateSubmenu(row) {
		try {
			var $row = $(row),
				submenuId = $row.data("submenuId"),
				$submenu = $("#" + submenuId);

			$submenu.css("display", "none");
			//console.log('deactive' + submenuId);
		} catch(err) {
			console.log(err);
		}
	}

	$('.cool-mat-radio input').click(function() {
		try {
			var	submenuId = $(this).data("submenuId"),
				$submenu = $("#" + submenuId);

			$('.cool-sub-mat').hide();
			$submenu.show();

			priceRecalculate();
		} catch (err) {
			console.log(err);
		}
	});

	$('.cool-mat-options input').click(function() {
		priceRecalculate();
	});
});

function priceRecalculate() {
	try {
		var stuff = $('input[name=stuff]:checked').val();

		var params = {
			stuff: stuff
		}

		if (stuff == 'glass') {
			var glass_stuff = $('input[name=glass_stuff]:checked').val();
			var glass_holders = $('input[name=glass_holders]:checked').val();

			params.glass_stuff = glass_stuff;
			params.glass_holders = glass_holders;
		}

		$.ceAjax(
			'request',
			fn_url('coolposter.price'),
			{
				data: params,
				callback: function (data) {
					coolUpdatePrice(data.price);
				}
			}
		);
	} catch (err) {
		console.log(err);
	}
}

function coolUpdatePrice(price) {
	try {
		$('#tigr-price').html(price);
		$('#priceholder').val(price);
	} catch (err) {
		console.log(err);
	}
}
/*** /that's exactly your fucking script ***/

function image(src) {
	try {
		initCanvas(src);
		ip5SplitsRetrieveData();
	} catch(err) {
		console.log(err);
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
				console.log(err);
			}
	    }
	});
}

function getLittleCanvas(rectangles, id) {
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

	splitsHash[id] = {
		canvas: canvas
	};

	$(rectangles).each(function() {
		var shape = getLittleShape(this);
		canvas.add(shape);
	});

	return wrapper;
}

function initMenu(data) {
	$(data).each(function() {
		if (!this.splits.length) return;

		var header = document.createElement('span');
		var block = document.createElement('div');


		var rectangles = this.splits[0].rectangles;
		var id = this.splits[0].id;
		var canvas = getLittleCanvas(rectangles, id);

		var subblock = document.createElement('ul');
		$(subblock).addClass('dropbox-choose-form');

		$(header).html(this.name);
		$(block).append(header);
		$(block).append(subblock);
		//$(block).append(canvas);
		$(block).addClass('choose-form-item');
		$('.choose-form-list').append(block);

		$(this.splits).each(function() {
			var rectangles = this.rectangles;
			var id = this.id;
			var canvas = getLittleCanvas(rectangles, id);
			$(subblock).append(canvas);

			splitsHash[id].rectangles = rectangles;
		});

		$('.dropbox-choose-form .cool-wrapper').mouseenter(function(e) {
			var id = this.id;
			var canvas = splitsHash[id].canvas;
			canvas.setBackgroundColor(
				littleCanvasHover,
				canvas.renderAll.bind(canvas)
			);
		});
		$('.dropbox-choose-form .cool-wrapper').mouseout(function(e) {
			var id = this.id;
			var canvas = splitsHash[id].canvas;
			canvas.setBackgroundColor(
				littleCanvasColor,
				canvas.renderAll.bind(canvas)
			);
		});

		$('.dropbox-choose-form .cool-wrapper').click(function(e) {
			//$('.cool-block').hideBalloon();
			var id = this.id;
			var rectangles = splitsHash[id].rectangles;
/*введено*/
			$('#splitsholder').val(JSON.stringify(rectangles))
			//redraw(rectangles);
			_redraw(rectangles);
		});

	});
}

function redraw(rectangles) {
	try {
		var rectangles = this.splits[0].rectangles;
		var id = this.splits[0].id;

		var canvas = getLittleCanvas(rectangles, id);
		canvas.clear();
		canvas.add(img);

		if (!img.filters.length) {
			img.filters.push(
				new fabric.Image.filters.Brightness({
					brightness: 100
				})
			);

			img.applyFilters(canvas.renderAll.bind(canvas));
		}

		$(rectangles).each(function() {
			loadSquair(this);
		});

		canvas.renderAll();
	} catch(err) {
		console.log(canvas);
	}
}

function loadSquair(rect) {
	var shape = new fabric.Rect({
		left: rect.x / xbScale,
		top: rect.y / ybScale,
		width: rect.width / xbScale,
		height: rect.height / ybScale,
		fill: '',
		strokeWidth: 2,
		stroke: rectangleColor,
		lockRotation: true
	});

	shape.on('moving', function() {
		imagePatternReset(this);
	});

	shape.on('scaling', function() {
		imagePatternReset(this);
	});

	imagePatternReset(shape);

	canvas.add(shape);
}

function imagePatternReset(shape) {
	shape.setPatternFill({
		source: imgElement,
		offsetX: - shape.left - 1,
		offsetY: - shape.top - 1
	});

	shape.setWidth(shape.width * shape.scaleX);
	shape.setHeight(shape.height * shape.scaleY);
	shape.setScaleX(1);
	shape.setScaleY(1);
}
