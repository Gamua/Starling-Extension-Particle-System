package
{
    import flash.geom.Point;
    
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.EnterFrameEvent;
    import starling.events.Event;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.extensions.ParticleDesignerPS;
    import starling.extensions.ParticleSystem;
    import starling.text.TextField;
    import starling.textures.Texture;
    import starling.utils.HAlign;
    
    public class Demo extends Sprite
    {
        // particle designer configurations
        
        [Embed(source="../media/drugs.pex", mimeType="application/octet-stream")]
        private static const DrugsConfig:Class;
        
        [Embed(source="../media/fire.pex", mimeType="application/octet-stream")]
        private static const FireConfig:Class;
        
        [Embed(source="../media/sun.pex", mimeType="application/octet-stream")]
        private static const SunConfig:Class;
        
        [Embed(source="../media/jellyfish.pex", mimeType="application/octet-stream")]
        private static const JellyfishConfig:Class;
        
        // particle textures
        
        [Embed(source = "../media/drugs_particle.png")]
        private static const DrugsParticle:Class;
        
        [Embed(source = "../media/fire_particle.png")]
        private static const FireParticle:Class;
        
        [Embed(source = "../media/sun_particle.png")]
        private static const SunParticle:Class;
        
        [Embed(source = "../media/jellyfish_particle.png")]
        private static const JellyfishParticle:Class;
        
        // member variables
        
        private var mParticleSystem:ParticleSystem;
        private var mFrameLabel:TextField;
        private var mFrameCount:int;
        private var mFrameTime:Number;
        
        public function Demo()
        {
            // create particle system
            // (change first 2 lines to try out other configurations)
            
            var psConfig:XML = XML(new DrugsConfig());
            var psTexture:Texture = Texture.fromBitmap(new DrugsParticle());
            
            mParticleSystem = new ParticleDesignerPS(psConfig, psTexture);
            mParticleSystem.emitterX = 320;
            mParticleSystem.emitterY = 240;
            mParticleSystem.start();
            addChild(mParticleSystem);
            
            // create FPS label
            
            mFrameCount = mFrameTime = 0;
            mFrameLabel = new TextField(64, 16, "FPS:", "Arial", 12, 0xffffff);
            mFrameLabel.hAlign = HAlign.LEFT;
            addChild(mFrameLabel);
            
            // add event handlers for touch and FPS
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            addEventListener(Event.ENTER_FRAME, onEnterFrame);
        }
        
        private function onAddedToStage(event:Event):void
        {
            stage.addEventListener(TouchEvent.TOUCH, onTouch);
            Starling.juggler.add(mParticleSystem);
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(TouchEvent.TOUCH, onTouch);
            Starling.juggler.remove(mParticleSystem);
        }
        
        private function onEnterFrame(event:EnterFrameEvent):void
        {
            mFrameCount++;
            mFrameTime += event.passedTime;
            
            if (mFrameTime > 1)
            {
                mFrameLabel.text = "FPS: " + int(mFrameCount / mFrameTime);
                mFrameTime = mFrameCount = 0;
            }
        }
        
        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage);
            if (touch && touch.phase != TouchPhase.HOVER)
            {
                mParticleSystem.emitterX = touch.globalX;
                mParticleSystem.emitterY = touch.globalY;
            }
        }
    }
}