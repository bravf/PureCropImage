package PureFlash
{
	import PureFlash.Base64;
	import PureFlash.JPGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	
	public class Tool
	{		
		public static function trim(str:String):String
		{
			return str.replace(/^\s+|\s+$/g, "");
		}
		
		// 得到等比缩放率
		public static function getZoomScale(contWidth:Number, contHeight:Number, imgWidth:Number, imgHeight:Number):Number
		{
			var zoom:Number = 1;
			
			if ( (contWidth / contHeight) <= (imgWidth / imgHeight) )
			{
				zoom = contWidth / imgWidth;
			}
			else
			{
				zoom = contHeight / imgHeight;
			}	
			
			return zoom;
		}
		
		// 缩放图片
		public static function zoomImage(bitData:BitmapData, scaleX:Number, scaleY:Number):BitmapData
		{
			var mc:Matrix = new Matrix();
			mc.scale(scaleX, scaleY);
			
			var retBitData:BitmapData = new BitmapData(Math.round(bitData.width * scaleX), Math.round(bitData.height * scaleY));
			retBitData.draw(bitData, mc, null, null, null, true);
			
			return retBitData;
		}
		
		// 截图
		public static function cropImage(bitData:BitmapData, rect:Rectangle):BitmapData
		{
			var retBitData:BitmapData = new BitmapData(rect.width, rect.height);
			retBitData.copyPixels(bitData, rect, new Point(0, 0));
			
			return retBitData;
		}
		
		// 得到一个区域
		public static function createDiv(x:Number, y:Number, width:Number, height:Number, borderWidth:Number, borderColor:uint, bgColor:uint, alpha:Number, borderAplpha:Number = 1):Sprite
		{	
			var div:Sprite = new Sprite();
			div.x = x;
			div.y = y;

			// draw rect
			div.graphics.beginFill(bgColor, alpha);
			div.graphics.drawRect(0, 0, width, height);
			div.graphics.endFill();
			
			// draw border
			if (borderWidth > 0){
				var x_1:Number = borderWidth;
				var x_2:Number = width - borderWidth;
				var y_1:Number = borderWidth;
				var y_2:Number = height - borderWidth;
				
				div.graphics.lineStyle(borderWidth, borderColor, borderAplpha);
				div.graphics.moveTo(x_1, y_1);
				
				div.graphics.lineTo(x_2, y_1);
				div.graphics.lineTo(x_2, y_2);
				div.graphics.lineTo(x_1, y_2);
				div.graphics.lineTo(x_1, y_1);
			}			
			return div;
		}
		
		// 得到一个按钮
		public static function createBtn(x:Number, y:Number, borderColor:Number, bgColor:Number, text:String):Sprite
		{	
			var btnWidth:Number = 80;
			var btnHeight:Number = 20;
			
			var btn:Sprite = createDiv(x, y, btnWidth, btnHeight, 1, borderColor, bgColor, 1);
			var txt:TextField = new TextField();
			txt.text = text;
			
			txt.width = btnWidth;
			txt.height = btnHeight;
			txt.autoSize = TextFieldAutoSize.CENTER;
			txt.y = 1;
			
			btn.addChild(txt);
			btn.addEventListener(MouseEvent.MOUSE_OVER, function():void{
				Mouse.cursor = MouseCursor.BUTTON;
			});
			btn.addEventListener(MouseEvent.MOUSE_OUT, function():void{
				Mouse.cursor = MouseCursor.AUTO;
			});
			
			return btn;
		}
		
		// 右旋转90
		public static function rotateRight(bitData:BitmapData):BitmapData
		{
			var mc:Matrix = new Matrix();
			
			mc.rotate(Math.PI/2);
			mc.translate(bitData.height, 0);
			
			var retBitData:BitmapData = new BitmapData(bitData.height, bitData.width);
			retBitData.draw(bitData, mc);
			
			return retBitData;
		}
		
		// 左旋转90
		public static function rotateLeft(bitData:BitmapData):BitmapData
		{
			var mc:Matrix = new Matrix();
			
			mc.rotate(-Math.PI/2);
			mc.translate(0, bitData.width);
			
			var retBitData:BitmapData = new BitmapData(bitData.height, bitData.width);
			retBitData.draw(bitData, mc);
			
			return retBitData;
		}
		
		// 下载图片
		public static function downloadImage(url:String, cbSuccess:Function, cbError:Function):void
		{
			var fileLoader:Loader = new Loader();
			var fileRequest:URLRequest = new URLRequest(url);
			fileLoader.load(fileRequest);
	
			
			fileLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void{
				cbSuccess(e);
			});
			fileLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				cbError("下载文件失败!");
			});
		};
		
		// 上传图片
		public static function uploadImage(url:String, bitData:BitmapData, cbSuccess:Function, cbError:Function):void
		{
//			var imgBytes:ByteArray = new JPGEncoder(80).encode(bitData);
//			var imgStr:String = Base64.encodeByteArray(imgBytes);
//			
//			url = encodeURI(url);
//			
//			var request:URLRequest = new URLRequest(url);
//			request.method = URLRequestMethod.POST;
//			//request.contentType = "text/xml";
//			
//			var urlvars:URLVariables = new URLVariables();
//			urlvars.cropImage = imgStr;
//			request.data = urlvars;
			
			url = encodeURI(url);
			var imgBytes:ByteArray = new JPGEncoder(80).encode(bitData);
			var request:URLRequest = new URLRequest(url);
			request.data = imgBytes;
			request.method = URLRequestMethod.POST;
			request.contentType = "application/octet-stream";
			
			var loader:URLLoader = new URLLoader();
			try
			{
				loader.load(request);
			}
			catch(err:Error)
			{
				trace(err.message);
			}
			
			loader.addEventListener(Event.COMPLETE, function(e:Event):void{
				if (cbSuccess != null) cbSuccess(loader.data);
			});
			loader.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void{
				if (cbError != null) cbError(IOErrorEvent.IO_ERROR);
			});
		}
	}
}




