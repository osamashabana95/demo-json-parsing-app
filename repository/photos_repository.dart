import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'package:http/http.dart' as http;
import '../data/photo.dart';

class PhotosRepository {
  Future<List<Photo>> fetchPhotos() async {
    try {
      final response = await http
          .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
      if (response.statusCode == 200) {
        return parsePhotosInIsolate(response.body);
      } else {
        throw Exception('Failed to load photos');
      }
    } on SocketException catch (e) {
      print('No internet connection: $e');
      throw Exception('No internet connection');
    }
  }

  Future<List<Photo>> parsePhotos(String jsonString) async {
    final jsonData = jsonDecode(jsonString);
    if (jsonData is List<dynamic>) {
      return jsonData.map((item) => Photo.fromJson(item)).toList();
    } else {
      throw Exception('Invalid JSON format');
    }
  }

  Future<List<Photo>> parsePhotosInIsolate(String jsonString) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(parsePhotosIsolate, receivePort.sendPort);
    final sendPort = await receivePort.first;
    final answer = ReceivePort();
    sendPort.send([jsonString, answer.sendPort]);
    return await answer.first;
  }

  static void parsePhotosIsolate(SendPort sendPort) async {
    final port = ReceivePort();
    sendPort.send(port.sendPort);
    await for (var msg in port) {
      final jsonString = msg[0] as String;
      final send = msg[1] as SendPort;
      final repository = PhotosRepository();
      send.send(await repository.parsePhotos(jsonString));
    }
  }
}
