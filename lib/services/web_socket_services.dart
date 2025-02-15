import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketServices {
  final String url;
  late WebSocketChannel _channel;
  final StreamController<String> _controller = StreamController.broadcast();

  WebSocketServices(this.url) {
    connect();
  }

  void connect() {
    // establish connection to web socket
    _channel = WebSocketChannel.connect(Uri.parse(url));

    // listen to changes to the web socket
    _channel.stream.listen((data) {
      // add all incoming data from the server
      _controller.add(data);
    }, onError: (err) {
      if (kDebugMode) {
        print(err.toString());
      }
    }, onDone: () {
      // closing the web socket
      if (kDebugMode) {
        print("Web Socket Closed");
      }
    });
  }

  Stream<String> get messages => _controller.stream;

  void sendMessage(String msg) {
    _channel.sink.add(msg);
  }

  void disconnect() {
    _channel.sink.close();
  }
}
