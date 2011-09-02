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
    import flash.display3D.Context3DBlendFactor;
    import flash.utils.Dictionary;
    import flash.xml.XMLNode;
    
    import flashx.textLayout.elements.BreakElement;
    
    import starling.core.RenderSupport;
    import starling.core.Starling;
    import starling.textures.Texture;
    import starling.utils.Color;
    import starling.utils.deg2rad;
    
    public class ParticleDesignerPS extends ParticleSystem
    {
        private const EMITTER_TYPE_GRAVITY:int = 0;
        private const EMITTER_TYPE_RADIAL:int  = 1;
        
        private var mEmissionRate:Number;
        
        // emitter configuration                            // .pex element name
        private var mEmitterType:int;                       // emitterType
        private var mEmitterXVariance:Number;               // sourcePositionVariance x
        private var mEmitterYVariance:Number;               // sourcePositionVariance y
        
        // particle configuration
        private var mMaxNumParticles:int;                   // maxParticles
        private var mLifespan:Number;                       // particleLifeSpan
        private var mLifespanVariance:Number;               // particleLifeSpanVariance
        private var mStartSize:Number;                      // startParticleSize
        private var mStartSizeVariance:Number;              // startParticleSizeVariance
        private var mEndSize:Number;                        // finishParticleSize
        private var mEndSizeVariance:Number;                // finishParticleSize
        private var mEmitAngle:Number;                      // angle
        private var mEmitAngleVariance:Number;              // angleVariance
        // [rotation not yet supported!]
        
        // gravity configuration
        private var mSpeed:Number;                          // speed
        private var mSpeedVariance:Number;                  // speedVariance
        private var mGravityX:Number;                       // gravity x
        private var mGravityY:Number;                       // gravity y
        private var mRadialAcceleration:Number;             // radialAcceleration
        private var mRadialAccelerationVariance:Number;     // radialAccelerationVariance
        private var mTangentialAcceleration:Number;         // tangentialAcceleration
        private var mTangentialAccelerationVariance:Number; // tangentialAccelerationVariance
        
        // radial configuration 
        private var mMaxRadius:Number;                      // maxRadius
        private var mMaxRadiusVariance:Number;              // maxRadiusVariance
        private var mMinRadius:Number;                      // minRadius
        private var mRotatePerSecond:Number;                // rotatePerSecond
        private var mRotatePerSecondVariance:Number;        // rotatePerSecondVariance
        
        // color configuration
        private var mStartColor:ColorArgb;                  // startColor
        private var mStartColorVariance:ColorArgb;          // startColorVariance
        private var mEndColor:ColorArgb;                    // finishColor
        private var mEndColorVariance:ColorArgb;            // finishColorVariance
        
        public function ParticleDesignerPS(config:XML, texture:Texture)
        {
            parseConfig(config);
            
            var emissionRate:Number = mMaxNumParticles / mLifespan;
            super(texture, emissionRate, mMaxNumParticles, 
                  mBlendFactorSource, mBlendFactorDestination);
            
            mPremultipliedAlpha = false;
        }
        
        protected override function createParticle():Particle
        {
            return new PDParticle();
        }
        
        protected override function initParticle(aParticle:Particle):void
        {
            var particle:PDParticle = aParticle as PDParticle; 
         
            var lifespan:Number = getRandomVariance(mLifespan, mLifespanVariance);
            if (lifespan <= 0.0) return;
            
            particle.currentTime = 0.0;
            particle.totalTime = lifespan;
            
            particle.x = getRandomVariance(mEmitterX, mEmitterXVariance);
            particle.y = getRandomVariance(mEmitterY, mEmitterYVariance);
            particle.startX = mEmitterX;
            particle.startY = mEmitterY;
            
            var angle:Number = getRandomVariance(mEmitAngle, mEmitAngleVariance);
            var speed:Number = getRandomVariance(mSpeed, mSpeedVariance);
            particle.velocityX = speed * Math.cos(angle);
            particle.velocityY = speed * Math.sin(angle);
            
            particle.radius = getRandomVariance(mMaxRadius, mMaxRadiusVariance);
            particle.radiusDelta = mMaxRadius / lifespan;
            particle.rotation = getRandomVariance(mEmitAngle, mEmitAngleVariance);
            particle.rotationDelta = getRandomVariance(mRotatePerSecond, mRotatePerSecondVariance);
            particle.radialAcceleration = mRadialAcceleration;
            particle.tangentialAcceleration = mTangentialAcceleration;
            
            var startSize:Number = Math.max(0.1, getRandomVariance(mStartSize, mStartSizeVariance));
            var endSize:Number = Math.max(0.1, getRandomVariance(mEndSize, mEndSizeVariance));
            particle.scale = startSize / texture.width;
            particle.scaleDelta = ((endSize - startSize) / lifespan) / texture.width;
            
            var startColor:ColorArgb = getRandomColorVariance(mStartColor, mStartColorVariance);
            var endColor:ColorArgb   = getRandomColorVariance(mEndColor,   mEndColorVariance);
            
            var colorDelta:ColorArgb = new ColorArgb();
            colorDelta.red   = (endColor.red   - startColor.red)   / lifespan;
            colorDelta.green = (endColor.green - startColor.green) / lifespan;
            colorDelta.blue  = (endColor.blue  - startColor.blue)  / lifespan;
            colorDelta.alpha = (endColor.alpha - startColor.alpha) / lifespan;
            
            particle.colorArgb = startColor;
            particle.colorArgbDelta = colorDelta;
        }
        
        protected override function advanceParticle(aParticle:Particle, passedTime:Number):void
        {
            var particle:PDParticle = aParticle as PDParticle;
            
            passedTime = Math.min(passedTime, particle.totalTime - particle.currentTime);
            particle.currentTime += passedTime;
            var timeToLive:Number = particle.totalTime - particle.currentTime;
            
            if (mEmitterType == EMITTER_TYPE_RADIAL)
            {
                particle.rotation += particle.rotationDelta * passedTime;
                particle.radius   -= particle.radiusDelta   * passedTime;
                particle.x = mEmitterX - Math.cos(particle.rotation) * particle.radius;
                particle.y = mEmitterY - Math.sin(particle.rotation) * particle.radius;
                
                if (particle.radius < mMinRadius)
                    particle.currentTime = particle.totalTime;
            }
            else
            {
                var distanceX:Number = particle.x - particle.startX;
                var distanceY:Number = particle.y - particle.startY;
                var distanceScalar:Number = 
                    Math.max(0.01, Math.sqrt(distanceX * distanceX + distanceY * distanceY));
                
                var radialX:Number = distanceX / distanceScalar;
                var radialY:Number = distanceY / distanceScalar;
                var tangentialX:Number = radialX;
                var tangentialY:Number = radialY;
                
                radialX *= particle.radialAcceleration;
                radialY *= particle.radialAcceleration;
                
                var newY:Number = tangentialX;
                tangentialX = -tangentialY * particle.tangentialAcceleration;
                tangentialY = newY * particle.tangentialAcceleration;
                
                particle.velocityX += passedTime * (mGravityX + radialX + tangentialX);
                particle.velocityY += passedTime * (mGravityY + radialY + tangentialY);
                particle.x += particle.velocityX * passedTime;
                particle.y += particle.velocityY * passedTime;
            }
            
            particle.scale += particle.scaleDelta * passedTime;
            
            particle.colorArgb.red   += particle.colorArgbDelta.red   * passedTime;
            particle.colorArgb.green += particle.colorArgbDelta.green * passedTime;
            particle.colorArgb.blue  += particle.colorArgbDelta.blue  * passedTime;
            particle.colorArgb.alpha += particle.colorArgbDelta.alpha * passedTime;
            
            particle.color = particle.colorArgb.toRgb();
            particle.alpha = particle.colorArgb.alpha;
        }
        
        private function parseConfig(config:XML):void
        {
            mEmitterXVariance = parseFloat(config.sourcePositionVariance.attribute("x"));
            mEmitterYVariance = parseFloat(config.sourcePositionVariance.attribute("y"));
            mGravityX = parseFloat(config.gravity.attribute("x"));
            mGravityY = parseFloat(config.gravity.attribute("y"));
            mEmitterType = getIntValue(config.emitterType);
            mMaxNumParticles = getIntValue(config.maxParticles);
            mLifespan = Math.max(0.01, getFloatValue(config.particleLifeSpan));
            mLifespanVariance = getFloatValue(config.particleLifespanVariance);
            mStartSize = getFloatValue(config.startParticleSize);
            mStartSizeVariance = getFloatValue(config.startParticleSizeVariance);
            mEndSize = getFloatValue(config.finishParticleSize);
            mEndSizeVariance = getFloatValue(config.FinishParticleSizeVariance);
            mEmitAngle = deg2rad(getFloatValue(config.angle));
            mEmitAngleVariance = deg2rad(getFloatValue(config.angleVariance));
            mSpeed = getFloatValue(config.speed);
            mSpeedVariance = getFloatValue(config.speedVariance);
            mRadialAcceleration = getFloatValue(config.radialAcceleration);
            mTangentialAcceleration = getFloatValue(config.tangentialAcceleration);
            mMaxRadius = getFloatValue(config.maxRadius);
            mMaxRadiusVariance = getFloatValue(config.maxRadiusVariance);
            mMinRadius = getFloatValue(config.minRadius);
            mRotatePerSecond = deg2rad(getFloatValue(config.rotatePerSecond));
            mRotatePerSecondVariance = deg2rad(getFloatValue(config.rotatePerSecondVariance));
            mStartColor = getColor(config.startColor);
            mStartColorVariance = getColor(config.startColorVariance);
            mEndColor = getColor(config.finishColor);
            mEndColorVariance = getColor(config.finishColorVariance);
            mBlendFactorSource = getBlendFunc(config.blendFuncSource);
            mBlendFactorDestination = getBlendFunc(config.blendFuncDestination);
            
            function getIntValue(element:XMLList):int
            {
                return parseInt(element.attribute("value"));
            }
            
            function getFloatValue(element:XMLList):Number
            {
                return parseFloat(element.attribute("value"));
            }
            
            function getColor(element:XMLList):ColorArgb
            {
                var color:ColorArgb = new ColorArgb();
                color.red   = parseFloat(element.attribute("red"));
                color.green = parseFloat(element.attribute("green"));
                color.blue  = parseFloat(element.attribute("blue"));
                color.alpha = parseFloat(element.attribute("alpha"));
                return color;
            }
            
            function getBlendFunc(element:XMLList):String
            {
                var value:int = getIntValue(element);
                switch (value)
                {
                    case 0:     return Context3DBlendFactor.ZERO; break;
                    case 1:     return Context3DBlendFactor.ONE; break;
                    case 0x300: return Context3DBlendFactor.SOURCE_COLOR; break;
                    case 0x301: return Context3DBlendFactor.ONE_MINUS_SOURCE_COLOR; break;
                    case 0x302: return Context3DBlendFactor.SOURCE_ALPHA; break;
                    case 0x303: return Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA; break;
                    case 0x304: return Context3DBlendFactor.DESTINATION_ALPHA; break;
                    case 0x305: return Context3DBlendFactor.ONE_MINUS_DESTINATION_ALPHA; break;
                    case 0x306: return Context3DBlendFactor.DESTINATION_COLOR; break;
                    case 0x307: return Context3DBlendFactor.ONE_MINUS_DESTINATION_COLOR; break;
                    default:    throw new ArgumentError("unsupported blending function: " + value);
                }
            }
        }
        
        // utility functions
        
        private function clamp(x:Number, a:Number, b:Number):Number
        {
            return x < a ? a : (x > b ? b : x);
        }
        
        private function getRandomVariance(base:Number, variance:Number):Number
        {
            return base + variance * (Math.random() * 2.0 - 1.0);
        }
        
        private function getRandomColorVariance(base:ColorArgb, variance:ColorArgb):ColorArgb
        {
            var color:ColorArgb = new ColorArgb();
            color.red   = clamp(getRandomVariance(base.red,   variance.red),   0.0, 1.0);
            color.green = clamp(getRandomVariance(base.green, variance.green), 0.0, 1.0);
            color.blue  = clamp(getRandomVariance(base.blue,  variance.blue),  0.0, 1.0);
            color.alpha = clamp(getRandomVariance(base.alpha, variance.alpha), 0.0, 1.0);
            return color;
        }
    }
}

class PDParticle extends starling.extensions.Particle
{
    public var colorArgb:ColorArgb;
    public var colorArgbDelta:ColorArgb;
    public var startX:Number, startY:Number;
    public var velocityX:Number, velocityY:Number;
    public var radialAcceleration:Number;
    public var tangentialAcceleration:Number;
    public var radius:Number, radiusDelta:Number;
    public var rotationDelta:Number;
    public var scaleDelta:Number;
    
    public function PDParticle()
    {
        colorArgb = new ColorArgb();
        colorArgbDelta = new ColorArgb();
    }
}

class ColorArgb
{
    public var alpha:Number;
    public var red:Number;
    public var green:Number;
    public var blue:Number;
    
    public function toRgb():uint
    {
        return int(red   * 255) << 16 | int(green * 255) << 8 | int(blue  * 255);       
    }
}