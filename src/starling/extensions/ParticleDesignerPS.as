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
    
    import starling.textures.Texture;
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
         
            // for performance reasons, the random variances are calculated inline instead
            // of calling a function
            
            var lifespan:Number = mLifespan + mLifespanVariance * (Math.random() * 2.0 - 1.0); 
            if (lifespan <= 0.0) return;
            
            particle.currentTime = 0.0;
            particle.totalTime = lifespan;
            
            particle.x = mEmitterX + mEmitterXVariance * (Math.random() * 2.0 - 1.0);
            particle.y = mEmitterY + mEmitterYVariance * (Math.random() * 2.0 - 1.0);
            particle.startX = mEmitterX;
            particle.startY = mEmitterY;
            
            var angle:Number = mEmitAngle + mEmitAngleVariance * (Math.random() * 2.0 - 1.0);
            var speed:Number = mSpeed + mSpeedVariance * (Math.random() * 2.0 - 1.0);
            particle.velocityX = speed * Math.cos(angle);
            particle.velocityY = speed * Math.sin(angle);
            
            particle.radius = mMaxRadius + mMaxRadiusVariance * (Math.random() * 2.0 - 1.0);
            particle.radiusDelta = mMaxRadius / lifespan;
            particle.rotation = mEmitAngle + mEmitAngleVariance * (Math.random() * 2.0 - 1.0); 
            particle.rotationDelta = mRotatePerSecond + mRotatePerSecondVariance * (Math.random() * 2.0 - 1.0); 
            particle.radialAcceleration = mRadialAcceleration;
            particle.tangentialAcceleration = mTangentialAcceleration;
            
            var startSize:Number = mStartSize + mStartSizeVariance * (Math.random() * 2.0 - 1.0); 
            var endSize:Number = mEndSize + mEndSizeVariance * (Math.random() * 2.0 - 1.0);
            if (startSize < 0.1) startSize = 0.1;
            if (endSize < 0.1)   endSize = 0.1;
            particle.scale = startSize / texture.width;
            particle.scaleDelta = ((endSize - startSize) / lifespan) / texture.width;
            
            // colors
            
            var startColor:ColorArgb = particle.colorArgb;
            var colorDelta:ColorArgb = particle.colorArgbDelta;
            
            startColor.red   = mStartColor.red;
            startColor.green = mStartColor.green;
            startColor.blue  = mStartColor.blue;
            startColor.alpha = mStartColor.alpha;
            
            if (mStartColorVariance.red != 0)   startColor.red   += mStartColorVariance.red   * (Math.random() * 2.0 - 1.0);
            if (mStartColorVariance.green != 0) startColor.green += mStartColorVariance.green * (Math.random() * 2.0 - 1.0);
            if (mStartColorVariance.blue != 0)  startColor.blue  += mStartColorVariance.blue  * (Math.random() * 2.0 - 1.0);
            if (mStartColorVariance.alpha != 0) startColor.alpha += mStartColorVariance.alpha * (Math.random() * 2.0 - 1.0);
            
            var endColorRed:Number   = mEndColor.red;
            var endColorGreen:Number = mEndColor.green;
            var endColorBlue:Number  = mEndColor.blue;
            var endColorAlpha:Number = mEndColor.alpha;

            if (mEndColorVariance.red != 0)   endColorRed   += mEndColorVariance.red   * (Math.random() * 2.0 - 1.0);
            if (mEndColorVariance.green != 0) endColorGreen += mEndColorVariance.green * (Math.random() * 2.0 - 1.0);
            if (mEndColorVariance.blue != 0)  endColorBlue  += mEndColorVariance.blue  * (Math.random() * 2.0 - 1.0);
            if (mEndColorVariance.alpha != 0) endColorAlpha += mEndColorVariance.alpha * (Math.random() * 2.0 - 1.0);
            
            colorDelta.red   = (endColorRed   - startColor.red)   / lifespan;
            colorDelta.green = (endColorGreen - startColor.green) / lifespan;
            colorDelta.blue  = (endColorBlue  - startColor.blue)  / lifespan;
            colorDelta.alpha = (endColorAlpha - startColor.alpha) / lifespan;
        }
        
        protected override function advanceParticle(aParticle:Particle, passedTime:Number):void
        {
            var particle:PDParticle = aParticle as PDParticle;
            
            var restTime:Number = particle.totalTime - particle.currentTime;
            passedTime = restTime > passedTime ? passedTime : restTime;
            particle.currentTime += passedTime;
            
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
                var distanceScalar:Number = Math.sqrt(distanceX*distanceX + distanceY*distanceY);
                if (distanceScalar < 0.01) distanceScalar = 0.01;
                
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