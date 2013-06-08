/*
 * Copyright (c), disktree.net
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
package jabber.net;

import js.html.WebSocket;

class SocketConnection_js extends SocketConnectionBase_js {
	
	public var url(default,null) : String;
	public var port(default,null) : Int;
	public var socket(default,null) : WebSocket;
	
	public function new( host : String = "localhost", port : Int = 5222, secure : Bool = false ) {
		
		super( host, secure );
		this.port = port;
		this.secure = secure;
		
		url = 'ws'+(secure?'s':'')+'://$host:$port'; // (unofficial) specs do not support secure websocket connections
	}
	
	public override function connect() {
		socket = new WebSocket( url );
		socket.onopen = onConnect;
		socket.onclose = onClose;
		socket.onerror = onError;
	}
	
	public override function disconnect() {
		socket.close();
	}
	
	public override function read( ?yes : Bool = true ) : Bool {
		socket.onmessage = onData;
		//if( yes ) socket.onmessage = onData;
		//socket.onmessage = yes ? onData : null;
		return true;
	}
	
	public override function write( t : String ) : Bool {
		socket.send( t );
		return true;
	}
	
	function onConnect(e) {
		connected = true;
		__onConnect();
	}
	
	function onClose(e) {
		connected = false;
		__onDisconnect(null);
	}
	
	function onError(e) {
		connected = false;
		__onDisconnect( "websocket error" ); // no error message?
	}
	
	function onData( m : Dynamic ) {
		__onString( m.data );
	}
	
	public static inline function isSupported() : Bool {
		return untyped window.WebSocket != null;
	}
}