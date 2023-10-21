import 'dart:io' as io;
import 'package:flutter/services.dart' show AssetManifest, ByteData, rootBundle;
import 'dart:math';

Future<void> fileDeployer() async {
  //Check file deployments
  Map<String, String> envVars = io.Platform.environment;
  String? homeDir = envVars['USERPROFILE'];
  if (homeDir == null) {
    throw Exception('Home dir not found, maybe running on linux?');
  }
  String desktop = homeDir + '\\Desktop';
  String downloads = homeDir + '\\Downloads';
  String pictures = homeDir + '\\Pictures';
  String music = homeDir + '\\Music';
  final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final imageAssetsList = assetManifest
      .listAssets()
      .where((string) => string.startsWith('assets/01levelek/randomImages/'))
      .toList();
  final musicAssetsList = assetManifest
      .listAssets()
      .where((string) => string.startsWith('assets/01levelek/randomSounds/'))
      .toList();

  /* Deploying first letter on desktop */
  print('Deploying first letter on desktop');
  io.Directory desktopDir = io.Directory(desktop + '\\Ne Nézd Meg!');
  if (!desktopDir.existsSync()) {
    desktopDir.createSync();
  }
  io.File desktopFile = io.File(desktop + '\\Ne Nézd Meg!\\levél.docx');
  if (desktopFile.existsSync()) {
    desktopFile.deleteSync();
  }

  ByteData data = await rootBundle.load('assets/01levelek/email1.docx');
  List<int> bytes =
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await desktopFile.writeAsBytes(bytes);
  print('Deployed first letter.');

  /* Deploying second letter in download */
  print('Deploying second letter in download');
  io.Directory downloadsDir = io.Directory(downloads);
  if (!downloadsDir.existsSync()) {
    downloadsDir.createSync();
  }
  io.File downloadsFile = io.File(downloads + '\\levél2.docx');
  if (downloadsFile.existsSync()) {
    downloadsFile.deleteSync();
  }
  data = await rootBundle.load('assets/01levelek/email2.docx');
  bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await downloadsFile.writeAsBytes(bytes);
  print('Deployed second letter.');

  /* Deploying third letter in pictures */
  print('Deploying third letter in pictures');
  io.Directory picturesDir = io.Directory(pictures + '\\Screenshots');
  if (!picturesDir.existsSync()) {
    picturesDir.createSync();
  }

  for (String imageAsset in imageAssetsList) {
    String imageName = imageAsset.split('/').last;
    io.File imageFile = io.File(pictures + '\\Screenshots\\$imageName');
    if (imageFile.existsSync()) {
      imageFile.deleteSync();
    }
    data = await rootBundle.load(imageAsset);
    bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    await imageFile.writeAsBytes(bytes);
    print('Deployed image $imageName.');
  }

  io.File picturesFile = io.File(pictures + '\\Screenshots\\levél3.docx');
  if (picturesFile.existsSync()) {
    picturesFile.deleteSync();
  }
  data = await rootBundle.load('assets/01levelek/email3.docx');
  bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await picturesFile.writeAsBytes(bytes);
  print('Deployed third letter.');

  /* Deploying fourth letter in music */
  print('Deploying fourth letter in music');

  /// Number of albums
  int numOfAlbs = 10;

  for (int i = 0; i <= numOfAlbs; i++) {
    io.Directory musicDir = io.Directory(music + '\\Album$i');
    if (musicDir.existsSync()) {
      musicDir.deleteSync(recursive: true);
    }
    musicDir.createSync();
    print('Created album $i');
    int randomNumOfMusic = Random().nextInt(10);
    List<String> randomMusicAssets = List.from(musicAssetsList);
    for (int j = 0; j < randomNumOfMusic; j++) {
      String soundAsset = randomMusicAssets.removeAt(
        Random().nextInt(randomMusicAssets.length),
      );
      String soundFile = soundAsset.split('/').last;
      io.File imageFile = io.File(music + '\\Album$i\\$soundFile');
      if (imageFile.existsSync()) {
        imageFile.deleteSync();
      }
      data = await rootBundle.load(soundAsset);
      bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await imageFile.writeAsBytes(bytes);
      print('Deployed sound for album$i $soundFile');
    }
  }
  io.Directory musicDeploymentDir =
      io.Directory(music + '\\Album${Random().nextInt(numOfAlbs)}');
  io.File musicFile = io.File(musicDeploymentDir.path + '\\levél4.docx');
  if (musicFile.existsSync()) {
    musicFile.deleteSync();
  }
  data = await rootBundle.load('assets/01levelek/email4.docx');
  bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  await musicFile.writeAsBytes(bytes);
  print('Deployed fourth letter. (${musicFile.path})');
}
