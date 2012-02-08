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
            return int(red * 255) << 16 | int(green * 255) << 8 | int(blue * 255);       
        }
        
        public function toArgb():uint
        {
            return int(alpha * 255) << 24 | int(red * 255) << 16 | int(green * 255) << 8 | int(blue * 255);       
        }
    }
}