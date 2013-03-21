// =================================================================================================
//
//	Starling Framework - Particle System Extension
//	Copyright 2011 Gamua OG. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

/**
 * Author: William Tsang
 * Copyright (c) Digicrafts 2013
 * https://github.com/digicrafts
 */

package starling.extensions.zones
{

	import flash.geom.Point;

	/**
	 * The CircleZone zone defines a circular zone. The zone may
	 * have a hole in the middle, like a doughnut.
	 */

	public class CircleZone implements Zone
	{

        private var _x : Number;
        private var _y : Number;
		private var _innerRadius:Number;
		private var _outerRadius:Number;
		private var _innerSq:Number;
		private var _outerSq:Number;
		
		private static const TWOPI:Number = Math.PI * 2;

        /**
         *
         * @param x The x coordinate of the center of the the circle
         * @param y The y coordinate of the center of the the circle
         * @param outerRadius The radius of the outer edge of the disc.
         * @param innerRadius If set, this defines the radius of the inner
         */
		public function CircleZone( x:Number = 0, y:Number = 0, outerRadius:Number = 0, innerRadius:Number = 0 )
		{
			if( outerRadius < innerRadius )
			{
				throw new Error( "The outerRadius (" + outerRadius + ") can't be smaller than the innerRadius (" + innerRadius + ") in your DiscZone. N.B. the outerRadius is the second argument in the constructor and the innerRadius is the third argument." );
			}
			_x = x;
            _y = y;
			_innerRadius = innerRadius;
			_outerRadius = outerRadius;
			_innerSq = _innerRadius * _innerRadius;
			_outerSq = _outerRadius * _outerRadius;
		}

        /**
         * The x coordination of the center of rectangle.
         */
        public function set x(value:Number):void
        {
            _x = value;
        }
        public function get x():Number
        {
            return _x;
        }

        /**
         * The y coordination of the center of rectangle.
         */
        public function set y(value:Number):void
        {
            _y = value;
        }

        public function get y():Number
        {
            return _y;
        }

		/**
		 * The radius of the inner edge of the disc.
		 */
		public function get innerRadius() : Number
		{
			return _innerRadius;
		}

		public function set innerRadius( value : Number ) : void
		{
			_innerRadius = value;
			_innerSq = _innerRadius * _innerRadius;
		}

		/**
		 * The radius of the outer edge of the disc.
		 */
		public function get outerRadius() : Number
		{
			return _outerRadius;
		}

		public function set outerRadius( value : Number ) : void
		{
			_outerRadius = value;
			_outerSq = _outerRadius * _outerRadius;
		}

		/**
		 * The contains method determines whether a point is inside the zone.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			x -= _x;
			y -= _y;
			var distSq:Number = x * x + y * y;
			return distSq <= _outerSq && distSq >= _innerSq;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point
		{
			var rand:Number = Math.random();
			var point:Point =  Point.polar( _innerRadius + (1 - rand * rand ) * ( _outerRadius - _innerRadius ), Math.random() * TWOPI );
			point.x += _x;
			point.y += _y;
			return point;
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getArea():Number
		{
			return Math.PI * ( _outerSq - _innerSq );
		}


	}
}
