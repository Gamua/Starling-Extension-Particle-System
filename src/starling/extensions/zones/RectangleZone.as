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
import flash.geom.Matrix;
import flash.geom.Point;

	/**
	 * The RectangleZone zone defines a rectangular shaped zone with rotation.
	 */

	public class RectangleZone implements Zone
	{

        private var _x : Number;
        private var _y : Number;
        private var _rotation:Number;
		private var _width : Number;
		private var _height : Number;
        private var _halfWidth : Number;
        private var _halfHeight : Number;
		
		/**
		 * The constructor creates a RectangleZone zone.
		 * 
		 * @param left The left coordinate of the rectangle defining the region of the zone.
		 * @param top The top coordinate of the rectangle defining the region of the zone.
		 * @param right The right coordinate of the rectangle defining the region of the zone.
		 * @param bottom The bottom coordinate of the rectangle defining the region of the zone.
		 */
		public function RectangleZone( width:Number = 0, height:Number = 0, x:Number = 0, y:Number = 0 , rotation:Number = 0)
		{
			this.width=width;
            this.height=height;
            _x = x;
            _y = y;
            _rotation = rotation;

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
         * The rotation of the rectangle around center.
         */
        public function set rotation(value:Number):void
        {
            _rotation = value;
        }
        public function get rotation():Number
        {
            return _rotation;
        }
		
		/**
		 * The left coordinate of the rectangle defining the region of the zone.
		 */
		public function get width() : Number
		{
			return _width;
		}

		public function set width( value : Number ) : void
		{
            _width = value;
			_halfWidth=_width*.5;
		}

		/**
		 * The right coordinate of the rectangle defining the region of the zone.
		 */
		public function get height() : Number
		{
			return _height;
		}

		public function set height( value : Number ) : void
		{
            _height = value;
            _halfHeight=_height*.5;
		}


		/**
		 * The contains method determines whether a point is inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
			return true;//x >= _left && x <= _right && y >= _top && y <= _bottom;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * This method is used by the initializers and actions that
		 * use the zone. Usually, it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point
		{
            return globalToLocal(_width*Math.random()-_halfWidth,_height*Math.random()-_halfHeight);
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * This method is used by the MultiZone class. Usually, 
		 * it need not be called directly by the user.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getArea():Number
		{
			return _width * _height;
		}

        /**
         * Transform the global point to local point in the rectangle.
         *
         * @param x
         * @param y
         * @return
         */
        private function globalToLocal(x:Number, y:Number):Point
        {

            var m:Matrix = new Matrix();
            m.tx = x;
            m.ty = y;
            m.rotate(_rotation);

//            var p:Point=new Point(m.tx + _x,m.ty + _y);
//            trace(p);
//            return p;
            return new Point(m.tx + _x,m.ty + _y);
        }


	}
}
