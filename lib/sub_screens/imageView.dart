import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:flutter_downloader/flutter_downloader.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageView extends StatefulWidget {
  String imageLink;
  ImageView({required this.imageLink});

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  ReceivePort receivePort = ReceivePort();
  int progress = 0;

  @override
  void initState() {
    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, 'downloadingImage');
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallBack);

    super.initState();
  }

  // _downloadListener() {
  //   IsolateNameServer.registerPortWithName(
  //       receivePort.sendPort, 'downloadingImage');
  //   receivePort.listen((dynamic data) {
  //     String id = data[0];
  //     DownloadTaskStatus status = data[1];
  //     int progress = data[2];
  //     if (status.toString() == "DownloadTaskStatus(3)" && progress == 100) {
  //       String query = "SELECT * FROM task WHERE task_id='" + id + "'";
  //       var tasks = FlutterDownloader.loadTasksWithRawQuery(query: query);
  //       //if the task exists, open it
  //       FlutterDownloader.open(taskId: id);
  //     }
  //   });
  //   FlutterDownloader.registerCallback(downloadCallback);
  // }

  void _downloadImage(BuildContext context, String url) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final id = FlutterDownloader.enqueue(
        url: url,
        savedDir: baseStorage!.path,
        fileName: 'Image',
        showNotification: true,
        openFileFromNotification: true,
      );
      print('the image path = ${baseStorage.path}');
    } else {
      print('No permission');
    }
  }

  static downloadCallBack(id, status, progress) {
    SendPort? sendPort = IsolateNameServer.lookupPortByName('downloadingImage');
    sendPort!.send(progress);
  }

  // static void downloadCallback(
  //     String id, DownloadTaskStatus status, int progress) {
  //   final SendPort? send =
  //       IsolateNameServer.lookupPortByName('downloader_send_port');
  //   send!.send([id, status, progress]);
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () {
                _downloadImage(context, widget.imageLink);
              },
              icon: Icon(
                Icons.download,
                color: Colors.white,
              ))
        ],
      ),
      body: Center(
        child: Image.network(
          widget.imageLink,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
