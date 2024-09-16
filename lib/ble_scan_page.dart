import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleScanPage extends StatefulWidget {
  @override
  _BleScanPageState createState() => _BleScanPageState();
}

class _BleScanPageState extends State<BleScanPage> {
  final List<ScanResult> _scanResults = [];

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

    FlutterBluePlus.scanResults.listen((results) {
      setState(() {
        _scanResults.clear();
        _scanResults.addAll(results);
      });
    });
  }

  @override
  void dispose() {
    FlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dispositivos BLE Disponíveis'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _scanResults.length,
              itemBuilder: (context, index) {
                final result = _scanResults[index];
                return ListTile(
                  title: Text(result.device.name.isNotEmpty
                      // ignore: deprecated_member_use
                      ? result.device.name
                      : 'Desconhecido'),
                  subtitle: Text(result.device.id.toString()),
                  trailing: Text('${result.rssi} dBm'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Voltar'),
          ),
        ],
      ),
    );
  }
}
