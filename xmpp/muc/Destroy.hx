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
package xmpp.muc;

import xmpp.XMLUtil;

class Destroy {
	
	public var password : String;
	public var reason : String;
	public var jid : String;
	
	public function new( password : String, reason : String, jid : String ) {
		this.password = password;
		this.reason = reason;
		this.jid = jid;
	}
	
	public function toXml() : Xml {
		var x = Xml.createElement( "destroy" );
		if( jid != null ) x.set( "jid", jid );
		if( password != null ) x.addChild( XMLUtil.createElement( "password", password ) );
		if( reason != null ) x.addChild( XMLUtil.createElement( "reason", reason ) );
		return x;
	}
	
	//TODO public static function parse(x : Xml) {
	
}
