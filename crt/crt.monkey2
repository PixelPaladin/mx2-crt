
Namespace crt

#Import "<std>"
#Import "<mojo>"

#import "assets/tvscreen.png"
#import "assets/crt.glsl"

Using std..
Using mojo..

Class GraphicsCRT
Private

	Field crtCanvas:Canvas
	Field crtImage:Image
	Field resolution:Vec2i
	Field _rgbSplitIntensity:Float = 0.4
	
	Global crtShader:Shader = Null
	Global overlayImg:Image = Null

Public

	#rem monkeydoc The scale of the screen image.
	#end
	Property Scale:Vec2f()
		Return crtImage.Material.GetVec2f("scale")
	Setter(v:Vec2f)
		crtImage.Material.SetVec2f("scale", v)
	End
	
	#rem monkeydoc The screen curvature.
	#end
	Property Curvature:Vec2f()
		Return crtImage.Material.GetVec2f("curve")
	Setter(v:Vec2f)
		crtImage.Material.SetVec2f("curve", v)
	End
	
	#rem monkeydoc The virtual screen resolution (between 32x16 and 800x600, default value is 320x240).
	#end
	Property Resolution:Vec2i()
		Return resolution
	Setter(v:Vec2i)
		If v.x < 32  Then v.x = 32
		If v.x > 800 Then v.x = 800
		If v.y < 16  Then v.y = 16
		If v.y > 600 Then v.y = 600
		resolution = v
		crtImage.Material.SetVec2f("resolution", v)
	End
	
	#rem monkeydoc The scanline intensity (between 0.0 and 1.0, default value is 0.2).
	#end
	Property ScanlineIntensity:Float()
		Return crtImage.Material.GetFloat("scanline_intensity")
	Setter(v:Float)
		If v < 0.0 Then v = 0.0
		If v > 1.0 Then v = 1.0
		crtImage.Material.SetFloat("scanline_intensity", v)
	End
	
	#rem monkeydoc The grb split intensity (between 0.0 and 1.0, default value is 0.4).
	#end
	Property RGBSplitIntensity:Float()
		Return crtImage.Material.GetFloat("rgb_split_intensity")
	Setter(v:Float)
		If v < 0.0 Then v = 0.0
		If v > 1.0 Then v = 1.0
		crtImage.Material.SetFloat("rgb_split_intensity", v)
	End
	
	#rem monkeydoc The brightness of the virtual screen (between 0.0 and 1.0, default value is 0.5).
	#end
	Property Brightness:Float()
		Return crtImage.Material.GetFloat("brightness")
	Setter(v:Float)
		If v < 0.0 Then v = 0.0
		If v > 1.0 Then v = 1.0
		crtImage.Material.SetFloat("brightness", v)
	End
	
	#rem monkeydoc The contrast of the virtual screen (between 0.0 and 1.0, default value is 0.5).
	#end
	Property Contrast:Float()
		Return crtImage.Material.GetFloat("contrast")
	Setter(v:Float)
		If v < 0.0 Then v = 0.0
		If v > 1.0 Then v = 1.0
		crtImage.Material.SetFloat("contrast", v)
	End
	
	#rem monkeydoc The gamma of the virtual screen (between 0.0 and 1.0, default value is 0.5).
	#end
	Property Gamma:Float()
		Return crtImage.Material.GetFloat("gamma")
	Setter(v:Float)
		If v < 0.0 Then v = 0.0
		If v > 1.0 Then v = 1.0
		crtImage.Material.SetFloat("gamma", v)
	End
	
	#rem monkeydoc Creates a new virtual crt screen.
	#end
	Method New(width:UInt = 320, height:UInt = 240)
		If width < 32 Then width = 32
		If width > 800 Then width = 800
		If height < 16 Then height = 16
		If height > 600 Then height = 600
		
		resolution = New Vec2i(width, height)
		
		Local CRT_ShaderCode:String
		
		CRT_ShaderCode = LoadString("asset::crt.glsl")
		If crtShader = Null Then crtShader = New Shader("crtshader", CRT_ShaderCode, "")
		crtImage = New Image(800, 600, TextureFlags.Dynamic|TextureFlags.Filter|TextureFlags.Mipmap, crtShader)
		'crtImage = New Image(800, 600, TextureFlags.Dynamic|TextureFlags.Filter, crtShader)
		
		crtImage.Material.SetVec2f("curve", New Vec2f(1.0, 1.0))
		crtImage.Material.SetVec2f("scale", New Vec2f(1.0, 1.0))
		crtImage.Material.SetVec2f("translate", New Vec2f(0.0, 0.0))
		crtImage.Material.SetVec2f("resolution", resolution)
		crtImage.Material.SetFloat("scanline_intensity", 0.2)
		crtImage.Material.SetFloat("rgb_split_intensity", 0.4)
		crtImage.Material.SetFloat("brightness", 0.5)
		crtImage.Material.SetFloat("contrast", 0.5)
		crtImage.Material.SetFloat("gamma", 0.5)
		
		crtCanvas = New Canvas(crtImage)
		If overlayImg = Null Then overlayImg = Image.Load("asset::tvscreen.png")
	End
	
	#rem monkeydoc The screen canvas.
	#end
	Property Canvas:Canvas()
		Return crtCanvas
	End
	
	#rem monkeydoc This renders the crt screen on a canvas.
	#end
	Method DrawScreen:Void(targetCanvas:Canvas, x:Float, y:Float, width:Float, height:Float)
		crtCanvas.Flush()
		If targetCanvas = Null Then Return
		targetCanvas.DrawRect(x, y, width, height, crtImage)
		
		Local tempColor := targetCanvas.Color
		targetCanvas.Color = Color.White
		targetCanvas.DrawRect(x, y, width, height, overlayImg)
		targetCanvas.Color = tempColor
	End
End

