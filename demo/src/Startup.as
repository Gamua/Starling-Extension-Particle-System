package 
{
    import flash.display.Sprite;

    import starling.core.Starling;

    [SWF(width="640", height="480", frameRate="60", backgroundColor="#222222")]
    public class Startup extends Sprite
    {
        private var _starling:Starling;
        
        public function Startup()
        {
            _starling = new Starling(Demo, stage);
            _starling.showStats = true;
            _starling.start();
        }
    }
}