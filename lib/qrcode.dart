import 'dart:developer';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class qrCode extends StatefulWidget {
  const qrCode({super.key});

  @override
  State<qrCode> createState() => _qrCodeState();
}

class _qrCodeState extends State<qrCode> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrCode;

  void _onQRViewCreated(QRViewController newController) {
    setState(() {
      controller = newController;
    });

    if (controller == null) {
      log('Controller belum terinisialisasi');
      return;
    }

    // Panggil method flash setelah controller telah terinisialisasi
    controller!.toggleFlash();

    controller!.scannedDataStream.listen((scanData) {
      setState(() {
        qrCode = scanData.code;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _MyAppBar(flash: controller?.toggleFlash),
      body: Column(children: [
        Expanded(
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
        ),
        if (qrCode != null)
          RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: <TextSpan>[
                TextSpan(
                  text: qrCode,
                  style: TextStyle(color: Colors.blue, fontSize: 14),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launch(qrCode!);
                    },
                ),
              ],
            ),
          )
      ]),
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final flash;

  _MyAppBar({required this.flash});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('QR Code Scanner'),
      actions: [
        IconButton(
          onPressed: flash,
          icon: Icon(
            Icons.flash_on,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
