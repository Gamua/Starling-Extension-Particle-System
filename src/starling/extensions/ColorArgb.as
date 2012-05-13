// =================================================================================================
//
//	Starling Framework - Particle System Extension
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.extensions
{
    public class ColorArgb
    {
        public var red:Number;
        public var green:Number;
        public var blue:Number;
        public var alpha:Number;
        
        public function ColorArgb(red:Number=0, green:Number=0, blue:Number=0, alpha:Number=0)
        {
            this.red = red;
            this.green = green;
            this.blue = blue;
            this.alpha = alpha;
        }
        
        public function toRgb():uint
        {
            var r:Number = red;   if (r < 0.0) r = 0.0; if (r > 1.0) r = 1.0;
            var g:Number = green; if (g < 0.0) g = 0.0; if (g > 1.0) g = 1.0;
            var b:Number = blue;  if (b < 0.0) b = 0.0; if (b > 1.0) b = 1.0;
            
            return int(r * 255) << 16 | int(g * 255) << 8 | int(b * 255);
            
            /* // For some reason, the old code creates a mem-leak:
            return int((red   < 0.0 ? 0.0 : red   > 1.0 ? 1.0 : red  ) * 255) << 16 | 
                   int((green < 0.0 ? 0.0 : green > 1.0 ? 1.0 : green) * 255) << 8 | 
                   int((blue  < 0.0 ? 0.0 : blue  > 1.0 ? 1.0 : blue ) * 255);
            */
        }
        
        public function toArgb():uint
        {
            var a:Number = alpha; if (a < 0.0) a = 0.0; if (a > 1.0) a = 1.0;
            var r:Number = red;   if (r < 0.0) r = 0.0; if (r > 1.0) r = 1.0;
            var g:Number = green; if (g < 0.0) g = 0.0; if (g > 1.0) g = 1.0;
            var b:Number = blue;  if (b < 0.0) b = 0.0; if (b > 1.0) b = 1.0;
            
            return int(a * 255) << 24 | int(r * 255) << 16 | int(g * 255) << 8 | int(b * 255);
            
            /* // For some reason, the old code creates a mem-leak:
            return int((alpha < 0.0 ? 0.0 : alpha > 1.0 ? 1.0 : alpha) * 255) << 24 | 
                   int((red   < 0.0 ? 0.0 : red   > 1.0 ? 1.0 : red  ) * 255) << 16 | 
                   int((green < 0.0 ? 0.0 : green > 1.0 ? 1.0 : green) * 255) << 8 | 
                   int((blue  < 0.0 ? 0.0 : blue  > 1.0 ? 1.0 : blue ) * 255);    
            */
        }
    }
}