import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  String? _lastScannedCode;
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode & QR Scanner'),
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: MobileScannerController(
              detectionSpeed: DetectionSpeed.normal,
              facing: CameraFacing.back,
            ),
            onDetect: (capture) {
              if (_hasScanned) return;

              final barcode = capture.barcodes.firstOrNull;
              final scannedValue = barcode?.rawValue;
              if (scannedValue == null || scannedValue.isEmpty) return;

              setState(() {
                _lastScannedCode = scannedValue;
                _hasScanned = true;
              });

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Scanned: $scannedValue'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: Colors.black.withOpacity(0.5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Point the camera at a barcode or QR code',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_lastScannedCode != null)
                    Text(
                      'Last result: $_lastScannedCode',
                      style: const TextStyle(color: Colors.white),
                    )
                  else
                    const Text(
                      'Waiting for scan...',
                      style: TextStyle(color: Colors.white70),
                    ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _lastScannedCode = null;
                        _hasScanned = false;
                      });
                    },
                    child: const Text('Reset'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension on List<Barcode> {
  Barcode? get firstOrNull => isEmpty ? null : first;
}

class Barcode {
  final String? rawValue;

  const Barcode({this.rawValue});
}

// The runtime Barcode type is provided by mobile_scanner and is not redefined here.
// This extension is only used to support firstOrNull access safely.
