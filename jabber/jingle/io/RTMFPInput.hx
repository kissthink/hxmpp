package jabber.jingle.io;

import flash.events.NetStatusEvent;
import flash.net.NetStream;

class RTMFPInput extends RTMFPTransport {
	
	var id : String;
	var pubid : String;
	
	public function new( url : String, id : String, pubid : String ) {
		super( url );
		this.id = id;
		this.pubid = pubid;
	}
	
	public override function init() {
		ns.play( pubid );
	}
	
	public override function toXml() : Xml {
		//TODO
		var x = Xml.createElement( "candidate" );
		//x.set( "id", nc.nearID );
		/*
		var r = ~/(rtmfp:\/\/)([A-Z0-9.-]+\.[A-Z][A-Z][A-Z]?)(\/([A-Z0-9\-]+))?/i;
		if( !r.match( url ) ) {
			//TODO
			trace("IIIIIIIIIINVAID RTMFP URL");	
			return null;
		}
		x.set( "url", r.matched(1)+r.matched(2) );
		*/
		//x.set( "url", url );
		return x;
	}
	
	override function netConnectionHandler( e : NetStatusEvent ) {
		trace(e.info.code);
		switch( e.info.code ) {
		case "NetConnection.Connect.Failed" :
			__onFail( e.info.code );
		case "NetConnection.Connect.Success" :
			ns = new NetStream( nc, id );
			ns.addEventListener( NetStatusEvent.NET_STATUS, netStreamHandler );
			__onConnect();
		case "NetConnection.Connect.Closed" :
			__onDisconnect();
		}
	}
	
	override function netStreamHandler( e : NetStatusEvent ) {
		trace(e.info.code);
		switch( e.info.code ) {
		case "NetStream.Play.UnpublishNotify" :
		case "NetStream.Play.Start" :
			//__onInit();
		}
	}
	
	public static function ofCandidate( x : Xml ) {
		//var url = x.get( "url" );
		//rtmfp://p2p.rtmfp.net/b02c232849248fdbbec2f9f1-0b1622211560
		//var r = ~/(rtmfp:\/\/)([A-Z0-9.-]+\.[A-Z][A-Z][A-Z]?)(\/([A-Z0-9.-]+)?/i;
		/*
		var r = ~/(rtmfp:\/\/)(.+)(\/(.+))?/i;
		if( !r.match( url ) ) {
			trace("IIIIIIIIIIIIIIIIIIIIINVALID RTMFP URL");
			return null;
		}
		trace( r.matched(1) );
		trace( r.matched(2) );
		trace( r.matched(3) );
		trace( r.matched(4) );
		*/
		return new RTMFPInput( x.get( "url" ), x.get( "id" ), x.get( "pubid" ) );
	}
	
}
