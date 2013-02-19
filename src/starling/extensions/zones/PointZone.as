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
	 * The PointZone zone defines a zone that contains a single point.
	 */

	public class PointZone implements Zone
	{

        private var _x : Number;
        private var _y : Number;
		
		/**
		 * The constructor defines a PointZone zone.
		 * 
		 * @param point The point that is the zone.
		 */
		public function PointZone( x:Number = 0, y:Number = 0 )
		{
            _x = x;
            _y = y;
		}

        /**
         * The x coordinate of the center of rectangle.
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
         * The y coordinate of the center of rectangle.
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
		 * The contains method determines whether a point is inside the zone.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			return _x == x && _y == y;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point
		{
			return new Point(_x, _y);
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getArea():Number
		{
			// treat as one pixel square
			return 1;
		}

	}
}
