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
package jabber;

import xmpp.IQ;

/**
	Manages discovery of services from XMPP entities.<br>
	Two kinds of information can be discovered:<br>
	(1) the identity and capabilities of an entity, including the protocols and features it supports,<br>
	(2) the items associated with an entity, such as the list of rooms hosted at a multi-user chat service.<br>
	
	<a href="http://www.xmpp.org/extensions/xep-0030.html">XEP 30 - ServiceDiscovery</a>
*/
class ServiceDiscovery {
	
	public dynamic function onInfo( jid : String, data : xmpp.disco.Info ) : Void;
	public dynamic function onItems( jid : String, data : xmpp.disco.Items ) : Void;
	public dynamic function onError( e : jabber.XMPPError ) : Void;
	
	public var stream(default,null) : jabber.Stream;
	
	public function new( stream : jabber.Stream ) {
		this.stream = stream;
	}
	
	/**
		Query entity for information.
	*/
	public function info( jid : String, ?node : String ) {
		var r = new IQ( xmpp.IQType.get, null, jid );
		r.x = new xmpp.disco.Info( null, null, node );
		stream.sendIQ( r, handleInfo, false );
	}
	
	/**
		Query entity for items.
	*/
	public function items( jid : String, ?node : String ) {
		var r = new IQ( xmpp.IQType.get, null, jid );
		r.x = new xmpp.disco.Items( node );
		stream.sendIQ( r, handleItems, false );
	}
	
	//////////////////
	
	/*
	public function _items( jid : String, ?node : String, handler : xmpp.disco.Items->Void, error : String->Void ) {
		var iq = new IQ( xmpp.IQType.get, null, jid );
		iq.x = new xmpp.disco.Items( node );
		stream.sendIQ( iq, function(r:xmpp.IQ){
			switch( r.type ) {
			case result : handler( xmpp.disco.Items.parse( iq.x.toXml() ) );
			case error : error( "AA ERROR TODO" );
			default :
			}
		} );
	}
	*/
	
	//////////////////
	
	function handleInfo( iq : IQ ) {
		switch( iq.type ) {
		case result :
			onInfo( ( iq.from == null ) ? null : iq.from,
					 xmpp.disco.Info.parse( iq.x.toXml() ) );
		case error :
			onError( new jabber.XMPPError( this, iq ) );
		default :
		}
	}
	
	function handleItems( iq : IQ ) {
		switch( iq.type ) {
		case result :
			onItems( ( iq.from == null ) ? null : iq.from,
					 xmpp.disco.Items.parse( iq.x.toXml() ) );
		case error :
			onError( new jabber.XMPPError( this, iq ) );
		default:
		}
	}
	
}
