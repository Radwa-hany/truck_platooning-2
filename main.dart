import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'Blue.dart';
void main() {
  runApp( MyApp());
}
void rw(bool f,b,l,r){
if(f & b){
  print(_MyApp()._address);
  BlueDevice().connect(_MyApp()._address,'s');
}
else if(l & r){
  BlueDevice().connect(_MyApp()._address,'n');
}
else if(f){
  BlueDevice().connect(_MyApp()._address,'f');
}
else if(b){
  BlueDevice().connect(_MyApp()._address,'b');
}
else if(l) {
  BlueDevice().connect(_MyApp()._address,'l');
}
else{
  BlueDevice().connect(_MyApp()._address,'r');
}
}
class MyApp extends StatefulWidget {
  @override
  _MyApp createState() => new _MyApp();
}

class _MyApp extends State<MyApp>{
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _address = "...";
  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    bool f=false,b=false,l=false,r=false;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Center(
            child: Text(
              'Truck Platooning',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 23.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        drawer: SafeArea(
          child: Drawer(
            backgroundColor: Colors.black87,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text('Connection',style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold,fontSize: 25.0),),
                  Divider(),
                  SwitchListTile(
                    title: const Text('Enable Bluetooth',style: TextStyle(color: Colors.orange)),
                    value:_bluetoothState.isEnabled ,
                    activeColor: Colors.orange,
                    onChanged: (bool value) {
                      // Do the request and update with the true value then
                      future() async {
                        // async lambda seems to not working
                        if (value)
                          await FlutterBluetoothSerial.instance.requestEnable();
                        else
                          await FlutterBluetoothSerial.instance.requestDisable();
                      }
                      future().then((_) {
                        setState(() {});
                      });
                    },
                  ),
                  ListTile(
                    title: const Text('Bluetooth status',style: TextStyle(color: Colors.orange)),
                    subtitle: Text(_bluetoothState.toString(),style: TextStyle(color: Colors.orangeAccent)),
                    trailing: ElevatedButton(
                      child: const Text('Settings'),
                      onPressed: () {
                        FlutterBluetoothSerial.instance.openSettings();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: Colors.black,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              IconButton(
                onPressed: (){
                  f=true;
                  if(b){
                    Future.delayed(Duration(milliseconds: 100), () {
                      f= false;
                    },
                    );
                  }
                  else {
                    Future.delayed(Duration(milliseconds: 100), () {
                      rw(f, b, l, r);
                      f = false;
                    },

                    );
                  }
                },
                icon: const Icon(
                  Icons.arrow_upward,
                ),
                color: Colors.orange,
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 50,
                      ),
                      child: IconButton(
                        onPressed: (){
                          l=true;
                          if(r){
                            Future.delayed(Duration(milliseconds: 100), () {
                              l= false;
                            },
                            );
                          }
                          else {
                            Future.delayed(Duration(milliseconds: 100), () {
                              rw(f, b, l, r);
                              l = false;
                            },
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                        ),
                        color: Colors.orange,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                        left: 50,
                      ),
                      child: IconButton(
                        onPressed: (){
                          r=true;
                          if(l){
                            Future.delayed(Duration(milliseconds: 100), () {
                              r= false;
                            },
                            );
                          }
                          else {
                            Future.delayed(Duration(milliseconds: 100), () {
                              rw(f, b, l, r);
                              r = false;
                            },
                            );
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_forward,
                        ),
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: (){
                  b=true;
                  if(f){
                    Future.delayed(Duration(milliseconds: 100), () {
                      b= false;
                    },
                    );
                  }
                  else {
                    Future.delayed(Duration(milliseconds: 100), () {
                      rw(f, b, l, r);
                      b = false;
                    },
                    );
                  }
                },
                icon: const Icon(
                  Icons.arrow_downward,
                ),
                color: Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
  // This widget is the root of your application.

class BluetoothDeviceListEntry extends ListTile{
  BluetoothDeviceListEntry({
    required BluetoothDevice device,
    int? rssi,
    GestureTapCallback? onTop,
    GestureLongPressCallback? onLongPress,
    bool enabled = true,
  }): super(
    onTap: onTop,
    onLongPress: onLongPress,
    enabled: enabled,
    leading:
      Icon(Icons.devices),
    title: Text(device.name ??''),
    subtitle: Text(device.address.toString()),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        rssi != null
        ? Container(
          margin: new EdgeInsets.all(8.0),
          child: DefaultTextStyle(
            style:TextStyle(color: Colors.orange),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(rssi.toString()),
                Text('dBm'),
              ],
            ),
          ),
        )
            : Container(
          width: 0,height: 0,
        ),
        device.isConnected
        ? Icon(Icons.import_export)
            : Container(width: 0,height: 0,),
        device.isBonded
        ? Icon(Icons.link)
            : Container(width: 0,height: 0,),

      ],
    ),
  );
}