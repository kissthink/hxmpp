/*
 *	This file is part of HXMPP.
 *	Copyright (c)2009 http://www.disktree.net
 *	
 *	HXMPP is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU Lesser General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  HXMPP is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *	See the GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with HXMPP. If not, see <http://www.gnu.org/licenses/>.
*/
package xmpp.filter;

/**
	Filters IQ packets: namespace/node-name/iq-type
*/
class IQFilter {
	
	public var xmlns : String;
	public var node : String;
	public var iqType : xmpp.IQType;
	
	//TODO public function new( ?xmlns : String, ?type : xmpp.IQType, ?node : String = "query" ) {
	public function new( ?xmlns : String, ?node : String, ?type : xmpp.IQType ) {
		this.xmlns = xmlns;
		this.node = node;
		this.iqType = type;
	}
	
	public function accept( p : xmpp.Packet ) : Bool {
		if( !Type.enumEq( p._type, xmpp.PacketType.iq ) )
			return false;
		var iq : xmpp.IQ = untyped p; //cast( p, xmpp.IQ );
		if( iqType != null ) {
			if( !Type.enumEq( iqType, iq.type ) )
				return false;
		}
		var x : Xml = null;
		if( xmlns != null ) {
			if( iq.x == null )
				return false;
			x = iq.x.toXml();
			if( x.get( "xmlns" ) != xmlns )
				return false;
		}
		if( node != null ) {
			if( iq.x == null )
				return false;
			if( x == null ) x = iq.x.toXml();
			if( node != x.nodeName )
				return false;
		}
		return true;
	}
	
}
