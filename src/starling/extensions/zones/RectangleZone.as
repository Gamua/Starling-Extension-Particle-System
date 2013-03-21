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
         *
         * @param width The width of the rectangle.
         * @param height The height of the rectangle.
         * @param x The center x coordinate of the rectangle.
         * @param y The center y coordinate of the rectangle.
         * @param rotation The rotation of the rectangle around center.
         */
		public function RectangleZone( width:Number = 0, height:Number = 0, x:Number = 0, y:Number = 0 , rotation:Number = 0)
		{
			this.width      = width;
            this.height     = height;
            this._x         = x;
            this._y         = y;
            this._rotation  = rotation;
		}

        /**
         * The center x coordinate of the center of rectangle.
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
         * The center y coordinate of the center of rectangle.
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
		 * The width of the rectangle.
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
		 * The height of the rectangle.
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
		 * 
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		public function contains( x:Number, y:Number ):Boolean
		{
            var p:Point=globalToLocal(x, y);
			return p.x >= 0 && p.x <= _width && p.y >=0 && p.y <= _height;
		}
		
		/**
		 * The getLocation method returns a random point inside the zone.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getLocation():Point
		{
            return localToGlobal(_width*Math.random(),_height*Math.random());
		}
		
		/**
		 * The getArea method returns the size of the zone.
		 * 
		 * @return a random point inside the zone.
		 */
		public function getArea():Number
		{
			return _width * _height;
		}

        /**
         * Transform the local point to global point in the rectangle.
         *
         * @param x
         * @param y
         * @return
         */
        private function localToGlobal(x:Number, y:Number):Point
        {
            // Transform the coordination
            var m:Matrix = new Matrix(1,0,0,1,x-_halfWidth,y-_halfHeight);
            m.rotate(_rotation);
            return new Point(m.tx + _x,m.ty + _y);
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
            // Transform the coordination
            var m:Matrix = new Matrix(1,0,0,1,x-_x,y-_y);
            m.rotate(-_rotation);
            return new Point(m.tx + _halfWidth,m.ty + _halfHeight);
        }

	}
}
