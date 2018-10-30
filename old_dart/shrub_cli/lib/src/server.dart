import 'dart:async';
import 'dart:io';
import 'package:html/parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart' as p;

class Server {
  Future<HttpServer> start(address, int port) async {
    var server = await HttpServer.bind(address, port);
    server.listen((request) async {
      var path = request.uri.path.replaceAll(new RegExp(r'^/+'), '');
      if (path.isEmpty) path = 'index.html';
      var file = new File(path);
      await sendFile(file, request);
    });
    return server;
  }

  Future sendFile(File file, HttpRequest request) async {
    var ext = p.extension(file.path);
    var response = request.response;

    if (!await file.exists()) {
      var dir = new Directory(file.path);

      if (await dir.exists()) {
        var index = new File.fromUri(dir.uri.resolve('index.html'));
        return await sendFile(index, request);
      }

      response
        ..statusCode = 404
        ..write('404 Not Found')
        ..close();
    } else {
      if (ext == '.html') {
        var doc = parse(await file.readAsString());
        var shrubScripts =
            doc.querySelectorAll('script[type="application/shrub"]');

        for (var script in shrubScripts) {
          var src = script.attributes['src'];

          if (src?.isNotEmpty == true) {
            var wasmName = p.setExtension(src, '.wasm');
            script.attributes..remove('src')..remove('type');
            script.innerHtml = '''
window.addEventListener('load', function () {
  WebAssembly.instantiateStreaming(fetch('$wasmName')).then(obj => {
    console.log(obj.instance.exports.main());
  });
});''';
          }
        }

        response
          ..headers.contentType = ContentType.html
          ..headers
              .set('last-modified', HttpDate.format(await file.lastModified()))
          ..write(doc.outerHtml)
          ..close();
      } else {
        if (request.headers.ifModifiedSince != null) {
          var mod = await file.lastModified();
          if (!mod.isAfter(request.headers.ifModifiedSince)) {
            response
              ..statusCode = 304
              ..close();
            return null;
          }
        }

        if (ext == '.wasm') {
          response.headers.contentType = new ContentType('application', 'wasm');
        } else {
          response.headers.contentType =
              ContentType.parse(lookupMimeType(file.path)) ??
                  'application/octet-stream';
        }

        file.openRead().pipe(response
          ..headers.set(
              'last-modified', HttpDate.format(await file.lastModified())));
      }
    }
  }
}
