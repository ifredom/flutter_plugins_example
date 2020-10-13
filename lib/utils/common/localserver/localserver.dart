import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:mime/mime.dart';

class CopyInAppLocalhostServer {
  // final _log = Logger("CopyInAppLocalhostServer");
  HttpServer _server;
  int _port = 8080;

  CopyInAppLocalhostServer({int port = 8080}) {
    this._port = port;
  }
  Future<void> start() async {
    if (this._server != null) {
      throw Exception('Server already started on http://localhost:$_port');
    }

    var completer = Completer();

    runZoned(() {
      HttpServer.bind('127.0.0.1', _port).then((server) {
        print('本地服务 http://localhost:' + _port.toString());

        this._server = server;
        server.listen((HttpRequest request) async {
          var body = List<int>();
          var path = request.requestedUri.path;
          path = (path.startsWith('/')) ? path.substring(1) : path;
          path += (path.endsWith('/')) ? 'index.html' : '';

          try {
            body = (await rootBundle.load(path)).buffer.asUint8List();
          } catch (e) {
            print(e.toString());
            await request.response.close();
            return;
          }

          var contentType = ['text', 'html'];
          if (!request.requestedUri.path.endsWith('/') && request.requestedUri.pathSegments.isNotEmpty) {
            var mimeType = lookupMimeType(request.requestedUri.path, headerBytes: body);
            if (mimeType != null) {
              contentType = mimeType.split('/');
            }
          }

          request.response.headers.contentType = ContentType(contentType[0], contentType[1], charset: 'utf-8');
          request.response.add(body);
          await request.response.close();
        });

        completer.complete();
      });
    }, onError: (e, stackTrace) => print('Error: $e $stackTrace'));
    return completer.future;
  }

  ///Closes the server.
  Future<void> close() async {
    if (this._server != null) {
      await this._server.close(force: true);
      print('本地服务 on http://localhost:$_port closed');
      this._server = null;
    }
  }
}
