import 'package:cisco_szabadulas/helpers/check_conf/is_ip_conf_right.dart';
import 'package:cisco_szabadulas/helpers/debug_menu/debug_menu.dart';
import 'package:flutter/material.dart';
import 'package:window_size/window_size.dart';

class StageTwo extends StatefulWidget {
  const StageTwo({super.key});

  @override
  State<StageTwo> createState() => _StageTwoState();
}

class _StageTwoState extends State<StageTwo> {
  @override
  void initState() {
    setWindowTitle('Cisco Szabadulás - Második stádium');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(
            'Cisco Szabadulás - Második stádium (Egyszerű kapcsolat)',
          ),
          onDoubleTap: () {
            showDebugMenu();
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc est dolor, rhoncus pellentesque lobortis ut, porttitor at sem. Morbi nisl odio, ultrices eu vestibulum sit amet, faucibus a nisl. Nam porta luctus massa. Vivamus interdum, magna interdum elementum rhoncus, quam eros interdum sem, non dictum est sem nec tortor. Mauris eget imperdiet sapien. Sed volutpat sapien lobortis faucibus feugiat. Donec faucibus vel felis et molestie. Duis feugiat semper augue, non dictum augue. Suspendisse ultricies, erat a scelerisque efficitur, nisi metus fringilla augue, vitae aliquet lacus ipsum condimentum mi. Donec justo dui, vestibulum quis fringilla nec, tincidunt eu sapien. Phasellus dictum tristique fermentum. Sed finibus diam tincidunt diam ornare consequat.',
            ),
          ),
          TextButton(
            child: Text('Ellenőrzés'),
            onPressed: () async {
              // Check one
              bool result = await isIpConfRight('192.168.1.93');
              print('Result: ' + result.toString());
              // Check two, connectivity?
            },
          ),
        ],
      ),
    );
  }
}
