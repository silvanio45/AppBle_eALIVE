import 'package:flutter/material.dart';
import 'package:appble/App_controller.dart';
import 'ble_scan_page.dart';

class HomeApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeAppState();
  }
}

class HomeAppState extends State<HomeApp> {
  final List<Map<String, int>> _dataList = [];
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 161, 173),
        title: Image.asset(
          'assets/Imagens/ImgLive.png',
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        actions: [CustomSw()],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Especificações'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _controller1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Tamanho do Json (em bytes)',
                      ),
                    ),
                    TextField(
                      controller: _controller2,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Tamanho do Chunk (em bytes)',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        int input1 = int.parse(_controller1.text);
                        int input2 = int.parse(_controller2.text);
                        _dataList.add({'json': input1, 'chunk': input2});
                      });
                      Navigator.of(context).pop();
                    },
                    child: Text('Salvar'),
                  ),
                ],
              );
            },
          );
        },
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BleScanPage(),
                ),
              );
            },
            child: const Text('Iniciar Scaneamento BLE'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _dataList.length,
              itemBuilder: (context, index) {
                final item = _dataList[index];
                return Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 167, 179, 189),
                    ),
                    child: ListTile(
                      title: Text(
                        'Tamanho do Json ${item['json']} e tamanho do chunk ${item['chunk']}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomSw extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Switch(
      value: ThemeController.instance.switchValue,
      onChanged: (value) {
        ThemeController.instance.changeTheme();
      },
    );
  }
}
