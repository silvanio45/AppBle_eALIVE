import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class BleScanPage extends StatefulWidget {
  @override
  _BleScanPageState createState() => _BleScanPageState();
}

class _BleScanPageState extends State<BleScanPage> {
  final List<ScanResult> _scanResults = [];

  @override
  void initState() {
    super.initState();
    _checkPermissionsAndStartScan();
  }

  Future<void> _checkPermissionsAndStartScan() async {
    // Solicita permissões necessárias
    var locationStatus = await Permission.location.status;
    var bluetoothScanStatus = await Permission.bluetoothScan.status;
    var bluetoothConnectStatus = await Permission.bluetoothConnect.status;

    if (!locationStatus.isGranted) {
      await Permission.location.request();
    }

    if (!bluetoothScanStatus.isGranted) {
      await Permission.bluetoothScan.request();
    }

    if (!bluetoothConnectStatus.isGranted) {
      await Permission.bluetoothConnect.request();
    }

    // Verifica se todas as permissões foram concedidas
    if (await Permission.location.isGranted &&
        await Permission.bluetoothScan.isGranted &&
        await Permission.bluetoothConnect.isGranted) {
      // Inicia o escaneamento
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));

      FlutterBluePlus.scanResults.listen((results) {
        setState(() {
          _scanResults.clear();
          _scanResults.addAll(results);
        });
      }).onError((error) {
        print('Erro ao escanear dispositivos: $error');
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Permissões necessárias não concedidas.')),
      );
    }
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
