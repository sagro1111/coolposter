var littleWidth = 150;
var littleHeight = 120;

var globalWidth = 650;
var globalHeight = 450;

var xlScale = littleWidth / globalWidth;
var ylScale = littleHeight / globalHeight;

var littleCanvasColor = 'rgba(170, 170, 170, 0.5)';
var littleCanvasHover = 'rgba(0, 220, 220, 0.5)';
var rectangleColor = 'rgb(0,0,0)';

var canvas;
var width;
var height;
var img;
var imgElement;

var xbScale;
var ybScale;

function initCanvas(src, callback) {
	canvas = new fabric.Canvas('canvas', {
		selection: false
	});

	if (canvas) {
		fabric.Image.fromURL(src,
			function(obj) {
				try {
					width = obj.width;
					height = obj.height;

					xbScale = globalWidth / width;
					ybScale = globalHeight / height;

					canvas.setDimensions({
						width: width,
						height: height
					});

					img = obj;
					imgElement = obj.cloneAsImage()._element;

					canvas.add(img);

					if (callback && (typeof callback == "function")) {
						callback();
					}

					canvas.renderAll();
				} catch(err) {
					console.log(err);
				}
			}, {
				crossOrigin: 'Anonymous',
				selectable: false
			}
		);
	}
}

function getLittleShape(rect) {
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
