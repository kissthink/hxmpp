package jabber.net;

import sys.net.Host;
import sys.net.Socket;
import haxe.io.Bytes;

private typedef AbstractSocket = {
	var input(default,null) : haxe.io.Input;
	var output(default,null) : haxe.io.Output;
	function connect( host : Host, port : Int ) : Void;
	function setTimeout( t : Float ) : Void;
	function write( str : String ) : Void;
	function close() : Void;
	function shutdown( read : Bool, write : Bool ) : Void;
	//function setBlocking( b : Bool ) : Void;
	//function setCertificateLocations( ?certFile : String, ?certFolder : String ) : Void;
}

class SocketConnectionBase_sys extends jabber.StreamConnection {
	
	public static var defaultBufSize = #if php 65536 #else 256 #end; //TODO php buf
	public static var defaultMaxBufSize = 1<<22; // 4MB
	public static var defaultTimeout = 10;
	
	public var port(default,null) : Int;
	public var maxbufsize(default,null) : Int;
	public var timeout(default,null) : Int;
	public var socket(default,null) : AbstractSocket;
	public var reading(default,null) : Bool;

	var buf : Bytes;
	var bufpos : Int;
	var bufsize : Int;

	function new( host : String, port : Int, secure : Bool,
				  bufsize : Int = -1, maxbufsize : Int = -1,
				  timeout : Int = -1 ) {
		super( host, secure, false );
		this.port = port;
		this.bufsize = ( bufsize == -1 ) ? defaultBufSize : bufsize;
		this.maxbufsize = ( maxbufsize == -1 ) ? defaultMaxBufSize : maxbufsize;
		this.timeout = ( timeout == -1 ) ? defaultTimeout : timeout;
		#if (neko||cpp||php||rhino)
		this.reading = false;
		#end
	}

	public override function disconnect() {
		if( !connected )
			return;
		reading = connected = false;
		try socket.close() catch( e : Dynamic ) {
			__onDisconnect( e );
			return;
		}
	}
	
	public override function read( ?yes : Bool = true ) : Bool {
		if( yes ) {
			reading = true;
			while( reading  && connected ) {
				readData();
			}
		} else {
			reading = false;
		}
		return true;
	}

	function readData() {
		var len : Int;
		try {
			len = try socket.input.readBytes( buf, bufpos, bufsize );
		} catch( e : Dynamic ) {
			error( "socket read failed" );
			return;
		}
		bufpos += len;
		if( len < bufsize ) {
			__onData( buf.sub( 0, bufpos ) );
			bufpos = 0;
			buf = Bytes.alloc( bufsize = defaultBufSize );
		} else {
			var nsize = buf.length + bufsize;
			if( nsize > maxbufsize ) {
				error( 'max buffer size site reached ($maxbufsize)' );
				return;
			}
			var nbuf = Bytes.alloc( nsize );
			nbuf.blit( 0, buf, 0, buf.length );
			buf = nbuf;
		}
	}
	
	function error( info : String ) {
		reading = connected = false;
		try {
			socket.close();
		} catch( e : Dynamic ) {
			#if jabber_debug trace(e,"error"); #end
		}
		__onDisconnect( info );
	}
	
}
