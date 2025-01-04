import 'dart:io';
import 'dart:typed_data';

import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:gcloud/storage.dart';
import 'package:mime/mime.dart';

const _BUCKET_NAME = 'carlogbucket';

class CloudApi {
  final auth.ServiceAccountCredentials _credentials;
  auth.AutoRefreshingAuthClient? _client;

  CloudApi(String json)
      : _credentials = auth.ServiceAccountCredentials.fromJson(json);

  Future<Bucket> initBucket() async {
    if (_client == null) {
      _client =
          await auth.clientViaServiceAccount(_credentials, Storage.SCOPES);
    }

    var storage = Storage(_client!, 'Image Upload Google Storage');
    return storage.bucket(_BUCKET_NAME);
  }

  Future<ObjectInfo> save(String name, Uint8List imgBytes) async {
    var bucket = await initBucket();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final type = lookupMimeType(name);

    return await bucket.writeBytes(name, imgBytes,
        metadata: ObjectMetadata(
          contentType: type,
          custom: {
            'timestamp': '$timestamp',
          },
        ));
  }

  Future<void> delete(String name) async {
    var bucket = await initBucket();
    bucket.delete(name);
  }

  Future<Uint8List> download(String name) async {
    var bucket = await initBucket();

    try {
      final reader = bucket.read(name);
      final bytes = await reader
          .fold<BytesBuilder>(
              BytesBuilder(), (builder, data) => builder..add(data))
          .then((builder) => builder.takeBytes());
      if (bytes.isEmpty) {
        throw Exception("Downloaded file is empty");
      }
      return bytes;
    } catch (e) {
      throw Exception("Error downloading file: $e");
    }
  }
}
