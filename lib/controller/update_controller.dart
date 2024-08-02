import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:install_plugin/install_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:provider/provider.dart';

class UpdateController extends ChangeNotifier {
  double _progress = 0.0;
  bool _isDownloading = false;

  double get progress => _progress;
  bool get isDownloading => _isDownloading;

  void setDownloading(bool downloading) {
    _isDownloading = downloading;
    notifyListeners();
  }

  Future<void>requestPermissionAndDownload(BuildContext context) async {
    if (await Permission.storage.request().isGranted) {
      _showDownloadDialog(context);
      _downloadAndInstall(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Storage permission is required to download the update."),
      ));
    }
  }

  void _showDownloadDialog(BuildContext context) {
    setDownloading(true);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Downloading Update'),
          content: Consumer<UpdateController>(
            builder: (context, provider, child) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LinearProgressIndicator(value: provider.progress),
                  const SizedBox(height: 20),
                  Text('${(provider.progress * 100).toStringAsFixed(0)}%'),
                ],
              );
            },
          ),
        );
      },
    ).then((_) => setDownloading(false));
  }

  Future<void> _downloadAndInstall(BuildContext context) async {
    const url = 'https://iptv.macvision.global/image/macvision.apk';
    const fileName = 'macvision.apk';

    final tempDir = await getTemporaryDirectory();
    final filePath = '${tempDir.path}/$fileName';
    final file = File(filePath);
    final response =
        await http.Client().send(http.Request('GET', Uri.parse(url)));

    final contentLength = response.contentLength;

    List<int> bytes = [];

    response.stream.listen((List<int> newBytes) {
      bytes.addAll(newBytes);
      _progress = bytes.length / contentLength!;
      notifyListeners();
    }).onDone(() async {
      await file.writeAsBytes(bytes);
      if (await file.exists()) {
        try {
          final result = await InstallPlugin.installApk(filePath);
          if (kDebugMode) {
            print('Install result: $result');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Installation error: $e');
          }
        }
      } else {
        if (kDebugMode) {
          print('File not found at $filePath');
        }
      }
      Navigator.of(context).pop();
    });
  }
}
