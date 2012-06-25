/*
 * Copyright (c) 2012, tong, disktree.net
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package xmpp;

using xmpp.XMLUtil;

class PubSub {
	
	public static var XMLNS = xmpp.Packet.PROTOCOL+"/pubsub";
	
	public var subscribe : { node : String, jid : String };
	public var options : xmpp.pubsub.Options;
	public var affiliations : xmpp.pubsub.Affiliations;
	public var create : String;
	public var configure : xmpp.DataForm;
	public var items : xmpp.pubsub.Items;
	public var publish : xmpp.pubsub.Publish;
	public var retract : xmpp.pubsub.Retract;
	public var subscription : xmpp.pubsub.Subscription;
	public var subscriptions : xmpp.pubsub.Subscriptions;
	//public var default : { node : String, type : NodeType };
	public var unsubscribe : { node : String, jid : String, subid : String };
	
	public function new() {}
	
	public function toXml() : Xml {
		var x = IQ.createQueryXml( XMLNS, "pubsub" );
		var c =	if( subscribe != null ) {
			var e = Xml.createElement( "subscribe" );
			e.set( "jid", subscribe.jid );
			if( subscribe.node != null ) e.set( "node", subscribe.node );
			e;
		} else if( unsubscribe != null ) {
			var e = Xml.createElement( "unsubscribe" );
			e.set( "jid", unsubscribe.jid );
			if( unsubscribe.node != null ) e.set( "node", unsubscribe.node );
			if( unsubscribe.subid != null ) e.set( "subid", unsubscribe.subid );
			e;
		} else if( create != null ) {
			var e = Xml.createElement( "create" );
			e.set( "node", create );
//			var conf = Xml.createElement( "configure" );
//			if( configure != null ) conf.addChild( configure.toXml() );
//			e.addChild( conf );
			e;
		} else if( subscription != null ) {
			subscription.toXml();
		} else if( subscriptions != null ) {
			subscriptions.toXml();
		} else if( publish != null ) {
			publish.toXml();
		} else if( items != null ) {
			items.toXml();
		} else if( retract != null ) {
			retract.toXml();
		} else if( affiliations != null ) {
			affiliations.toXml();
		}
		if( options != null )
			x.addChild( options.toXml() );
		if( c != null )
			x.addChild( c );
		if( configure != null ) {	
			var c = Xml.createElement( "configure" );
			c.addChild( configure.toXml() );
			x.addChild( c );
		}
		return x;
	}
	
	public static function parse( x : Xml ) : xmpp.PubSub {
		var p = new xmpp.PubSub();
		for( e in x.elements() ) {
			switch( e.nodeName ) {
			case "subscribe" :
				p.subscribe = { node : e.get( "node" ), jid : e.get( "jid" ) };
			case "unsubscribe" :
				p.unsubscribe = { node : e.get( "node" ), jid : e.get( "jid" ), subid : e.get( "subid" )  };
			case "create" :
				p.create = e.get( "node" );
				if( p.create == null ) p.create = "";
			case "configure" :
				p.configure = xmpp.DataForm.parse( e.firstElement() );
			case "subscription" :
				p.subscription = xmpp.pubsub.Subscription.parse( e );
			case "subscriptions" :
				p.subscriptions = xmpp.pubsub.Subscriptions.parse( e );
			case "items" :
				p.items = xmpp.pubsub.Items.parse( e );
			case "retract" :
				p.retract = xmpp.pubsub.Retract.parse( e );
			case "publish" :
				p.publish = xmpp.pubsub.Publish.parse( e );
			case "affiliations" :
				p.affiliations = xmpp.pubsub.Affiliations.parse( e );
			case "options" :
				p.options = xmpp.pubsub.Options.parse( e );
			}
		}
		return p;
	}
	
	/*
	public static function fromPacket( p : xmpp.Packet ) : Caps {
	}
	*/
	
}
