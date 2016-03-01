package
{
    import flash.ui.Keyboard;

    import starling.core.Starling;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.events.KeyboardEvent;
    import starling.events.Touch;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    import starling.extensions.PDParticleSystem;
    import starling.extensions.ParticleSystem;
    import starling.textures.Texture;

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
        
        [Embed(source="../media/drugs_particle.png")]
        private static const DrugsParticle:Class;
        
        [Embed(source="../media/fire_particle.png")]
        private static const FireParticle:Class;
        
        [Embed(source="../media/sun_particle.png")]
        private static const SunParticle:Class;
        
        [Embed(source="../media/jellyfish_particle.png")]
        private static const JellyfishParticle:Class;

        // member variables
        
        private var _particleSystems:Vector.<ParticleSystem>;
        private var _particleSystem:ParticleSystem;
        
        public function Demo()
        {
            var drugsConfig:XML = XML(new DrugsConfig());
            var drugsTexture:Texture = Texture.fromEmbeddedAsset(DrugsParticle);

            var fireConfig:XML = XML(new FireConfig());
            var fireTexture:Texture = Texture.fromEmbeddedAsset(FireParticle);

            var sunConfig:XML = XML(new SunConfig());
            var sunTexture:Texture = Texture.fromEmbeddedAsset(SunParticle);

            var jellyConfig:XML = XML(new JellyfishConfig());
            var jellyTexture:Texture = Texture.fromEmbeddedAsset(JellyfishParticle);

            _particleSystems = new <ParticleSystem>[
                new PDParticleSystem(drugsConfig, drugsTexture),
                new PDParticleSystem(fireConfig, fireTexture),
                new PDParticleSystem(sunConfig, sunTexture),
                new PDParticleSystem(jellyConfig, jellyTexture)
            ];
            
            // add event handlers for touch and keyboard
            
            addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
        
        private function startNextParticleSystem():void
        {
            if (_particleSystem)
            {
                _particleSystem.stop();
                _particleSystem.removeFromParent();
                Starling.juggler.remove(_particleSystem);
            }
            
            _particleSystem = _particleSystems.shift();
            _particleSystems.push(_particleSystem);

            _particleSystem.emitterX = 320;
            _particleSystem.emitterY = 240;
            _particleSystem.start();
            
            addChild(_particleSystem);
            Starling.juggler.add(_particleSystem);
        }
        
        private function onAddedToStage(event:Event):void
        {
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
            stage.addEventListener(TouchEvent.TOUCH, onTouch);
            
            startNextParticleSystem();
        }
        
        private function onRemovedFromStage(event:Event):void
        {
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
            stage.removeEventListener(TouchEvent.TOUCH, onTouch);
        }
        
        private function onKey(event:Event, keyCode:uint):void
        {
            if (keyCode == Keyboard.SPACE)
                startNextParticleSystem();
        }
        
        private function onTouch(event:TouchEvent):void
        {
            var touch:Touch = event.getTouch(stage);
            if (touch && touch.phase != TouchPhase.HOVER)
            {
                _particleSystem.emitterX = touch.globalX;
                _particleSystem.emitterY = touch.globalY;
            }
        }
    }
}