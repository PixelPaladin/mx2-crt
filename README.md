# mx2-crt

*mx2-crt* is a module for monkey2 that makes it possible to render graphics into a configurable virtual crt monitor.

<p align="center">
  <img src="https://i.imgur.com/7q1E9mD.jpg" alt="image: crt module">
</p>

## Installation

1. copy the folder `crt` into your monkey2 modules folder (`YOUR-MONKEY2-PATH/modules/`)
2. open Ted2 and update your modules:

        Menu bar > Build > Update modules

3. rebuild your documentation:

        Menu bar > Build > Rebuild documentation

## Code Example

The following example code creates a virtual crt screen and renders a circle at its center:

```monkey
Namespace application

#Import "<std>"
#Import "<mojo>"
#Import "<crt>"

Using std..
Using mojo..
Using crt..

Class AppWindow Extends Window
    Field crt:GraphicsCRT
    
    Method New(title:String, width:Int, height:Int)
        Super.New(title, width, height)', WindowFlags.Resizable)
        SwapInterval = 1
        
        ' initialize crt screen:
        crt = New GraphicsCRT(160, 120)
    End

    Method OnRender(canvas:Canvas) Override
        App.RequestRender()
        
        ' clear screen and render circle:
        crt.Canvas.Clear(Color.Black)
        crt.Canvas.Color = Color.White
        crt.Canvas.DrawCircle(crt.Resolution.X/2, crt.Resolution.Y/2, 50)
        
        ' draw crt screen on main canvas:
        crt.DrawScreen(canvas, 0, 0, Width, Height)
    End
End

Function Main()
    New AppInstance
    New AppWindow("crt example", 640, 480)
    App.Run()
End
```

The result should look like this:

<p align="center">
  <img src="https://i.imgur.com/77Z3e55.jpg" alt="image: example application">
</p>
