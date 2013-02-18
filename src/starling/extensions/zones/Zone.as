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
	 * The Zones interface must be implemented by all zones.
	 * 
	 * <p>A zone is a class that defined a region in 2d space. The two required methods 
	 * make it easy to get a random point within the zone and to find whether a specific
	 * point is within the zone. Zones are used to define the start location for particles
	 * (in the Position initializer).</p>
	 */
	public interface Zone
	{

		/**
		 * Determines whether a point is inside the zone.
         *
		 * @param x The x coordinate of the location to test for.
		 * @param y The y coordinate of the location to test for.
		 * @return true if point is inside the zone, false if it is outside.
		 */
		function contains( x:Number, y:Number ):Boolean;

		/**
		 * Returns a random point inside the zone.
		 * 
		 * @return a random point inside the zone.
		 */
		function getLocation():Point;

		/**
		 * Returns the size of the zone.
		 * This method is used by the MultiZone class to manage the balancing between the
		 * different zones.
		 * 
		 * @return the size of the zone.
		 */
		function getArea():Number;

        /**
         * The x coordination of the center of zone.
         */
        function set x(value:Number):void;
        function get x():Number;

        /**
         * The x coordination of the center of zone.
         */
        function set y(value:Number):void;
        function get y():Number;
	}
}