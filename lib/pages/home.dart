import 'dart:io';

import 'package:flutter/material.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home>{
  final GlobalKey qrKey = GlobalKey( debugLabel: 'QR' );
  Barcode? result;
  QRViewController? controller;

  @override

  void reasemble(){
    super.reassemble();
    if( Platform.isAndroid ){
      controller!.pauseCamera();
    }
    else if(Platform.isIOS){
      controller!.resumeCamera();
    }
  }

  void _onQRCreated( QRViewController controller ){
    this.controller = controller;
    controller.scannedDataStream.listen( (scannedData) {
      setState(() {
        result = scannedData;
      });
    });
  }

  @override
  void dispose(){
    super.dispose();
    controller?.dispose();
  }

  @override
  Widget build( BuildContext context ){
    return Scaffold(
      appBar: AppBar(
        title: Text("QR SCANNER"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 5,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRCreated,
              )
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Text(result != null ? "${result!.code}" : "Scan a code"),
              )
            )
          ]
        )
      )
    );
  }
}