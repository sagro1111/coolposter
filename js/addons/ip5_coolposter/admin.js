function editor() {
	try {
		src = "/design/backend/media/images/addons/ip5_coolposter/cubs.jpg";

		initCanvas(src, initCanvasLocal);

		$('#add-square').click(function() {
			var shape = getShape({
				x: 10,
				y: 10,
				width: 80,
				height: 80
			});

			canvas.add(shape);
		});

		$('#del-square').click(function() {
			var rect = canvas.getActiveObject();
			canvas.remove(rect);
		});

		$.ceEvent('on', 'ce.formpre_update_split_form', function(form, elm) {
			var shapes = [];

			try {
				$(canvas.getObjects()).each(function() {
					if (this.type == 'rect') {
						var rect = {
							x: this.left * xbScale,
							y: this.top * ybScale,
							width: this.width * xbScale,
							height: this.height * ybScale
						}

						shapes.push(rect);
					}
				});

				$('#rectangles').val(JSON.stringify(shapes));

			} catch(err) {
				console.log(err);
			}
		});
	} catch(err) {
		console.log(err);
	}
}

function canvas(id, rectangles) {
	try {
		initLittleCanvas(id, rectangles);
	} catch(err) {
		console.log(err);
	}
}

function initLittleCanvas(id, rectangles) {
	var canvas = new fabric.StaticCanvas(id, {
		width: littleWidth,
		height: littleHeight,
		backgroundColor: littleCanvasColor
	});

	rectangles = $.parseJSON(String(rectangles).replace(/&quot;/g, '"'));

	$(rectangles).each(function() {
		var shape = getLittleShape(this);
		canvas.add(shape);
	});
}

function initCanvasLocal() {

	canvas.on('selection:cleared', function(options) {
		$('#del-square').addClass('hidden');
	});

	var grid = 5;

	for (var i = 1; i < (canvas.width / grid); i++) {
		canvas.add(new fabric.Line([ i * grid, 0, i * grid, canvas.width], { stroke: 'rgba(156,207,232,0.4)', selectable: false }));
		canvas.add(new fabric.Line([ 0, i * grid, canvas.width, i * grid], { stroke: 'rgba(156,207,232,0.4)', selectable: false }));
	}
	var jsonShapes = $('#rectangles').val();

	if (jsonShapes) {
		try {
			var shapes = $.parseJSON(jsonShapes);

			$(shapes).each(function() {
				var shape = getShape(this);
				canvas.add(shape);
			});
		} catch(err) {
			console.log(err);
		}
	}

	canvas.on('object:moving', function(options) { 
		console.log(options);
		options.target.set({
			left: Math.round(options.target.left / grid) * grid,
			top: Math.round(options.target.top / grid) * grid
		});
	});

	canvas.on('object:scaling', function (options) {
		var target = options.target;
		var type = canvas.getActiveObject().get('type');
		var corner = target.__corner;
		var w = target.getWidth();
		var h = target.getHeight();
        var snap = {   // Closest snapping points
        	top: Math.round(target.top / grid) * grid,
        	left: Math.round(target.left / grid) * grid,
        	bottom: Math.round((target.top + h) / grid) * grid,
        	right: Math.round((target.left + w) / grid) * grid,
        };
        snap.height = snap.top - snap.bottom;
        if(snap.height < 0) {
        	snap.height *= - 1;
        }
        snap.width = snap.left - snap.right;
        if(snap.width < 0) {
        	snap.width *= - 1;
        }
        switch (corner) {
        	case 'mt':
        	case 'mb':
        	target.top = snap.top;
        	target.height = snap.height;
        	target.scaleY = 1;
        	break;
        	case 'ml':
        	case 'mr':
        	target.left = snap.left;
        	target.width = snap.width;
        	target.scaleX = 1;
        	break;
        	case 'tl':
        	case 'bl':
        	case 'tr':
        	case 'br':
        	target.top = snap.top;
        	target.left = snap.left;

        	target.height = snap.height;
        	target.width = snap.width;

        	target.scaleY = 1;
        	target.scaleX = 1;
        }

        if(type == 'ellipse') {
        	target.rx = (target.width / 2);
        	target.ry = (target.height / 2);
        }
    });

}

function getShape(rect) {
	var shape = new fabric.Rect({
		left: rect.x / xbScale,
		top: rect.y / ybScale,
		width: rect.width / xbScale,
		height: rect.height / ybScale,
		fill: 'rgba(255,255,255,.2)',
		strokeWidth: 2,
		stroke: rectangleColor,
		lockRotation: true
	});

	shape.on('scaling', function() {
		this.setWidth(this.width * this.scaleX);
		this.setHeight(this.height * this.scaleY);
		this.setScaleX(1);
		this.setScaleY(1);
	});

	shape.on('selected', function() {
		$('#del-square').removeClass('hidden');
	});

	return shape;
}
