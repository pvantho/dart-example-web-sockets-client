/*
 * See LICENSE file.
 */

#import('dart:html');

WebSocket ws;

outputMsg(String msg) {
  var output = query('#output');
  output.text = "${output.text}\n${msg}";
}

void initWebSocket([int retrySeconds = 2]) {
  bool encounteredError = false;
  
  outputMsg("Connecting to Web socket");
  ws = new WebSocket('ws://echo.websocket.org');
  
  ws.on.open.add((e) {
    outputMsg('Connected');
    ws.send('Hello from Dart!');
  });
  
  ws.on.close.add((e) {
    outputMsg('web socket closed, retrying in $retrySeconds seconds');
    if (!encounteredError) {
      window.setTimeout(() => initWebSocket(retrySeconds*2), 1000*retrySeconds);
    }
    encounteredError = true;
  });
  
  ws.on.error.add((e) {
    outputMsg("Error connecting to ws");
    if (!encounteredError) {
      window.setTimeout(() => initWebSocket(retrySeconds*2), 1000*retrySeconds);
    }
    encounteredError = true;
  });
  
  ws.on.message.add((MessageEvent e) {
    outputMsg('received message ${e.data}');
  });
}

void main() {
  initWebSocket();
}