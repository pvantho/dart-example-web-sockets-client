/*
 * See LICENSE file.
 */

import 'dart:html';
import 'dart:async';

WebSocket ws;

outputMsg(String msg) {
  var output = query('#output');
  output.text = "${output.text}\n${msg}";
}

void initWebSocket([int retrySeconds = 2]) {
  var encounteredError = false;
  
  outputMsg("Connecting to Web socket");
  ws = new WebSocket('ws://echo.websocket.org');
  
  ws.onOpen.listen((e) {
    outputMsg('Connected');
    ws.send('Hello from Dart!');
  });
  
  ws.onClose.listen((e) {
    outputMsg('web socket closed, retrying in $retrySeconds seconds');
    if (!encounteredError) {
      new Timer(new Duration(seconds:retrySeconds),
          () => initWebSocket(retrySeconds*2));
    }
    encounteredError = true;
  });
  
  ws.onError.listen((e) {
    outputMsg("Error connecting to ws");
    if (!encounteredError) {
      new Timer(new Duration(seconds:retrySeconds),
          () => initWebSocket(retrySeconds*2));
    }
    encounteredError = true;
  });
  
  ws.onMessage.listen((MessageEvent e) {
    outputMsg('received message ${e.data}');
  });
}

void main() {
  initWebSocket();
}