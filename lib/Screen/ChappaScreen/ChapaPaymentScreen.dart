import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ChapaPaymentScreen extends StatefulWidget {
  final String paymentUrl;
  final String returnUrl; // zeyo return or base_url("payment/success")

  const ChapaPaymentScreen({
    super.key,
    required this.paymentUrl,
    required this.returnUrl,
  });

  @override
  State<ChapaPaymentScreen> createState() => _ChapaPaymentScreenState();
}

class _ChapaPaymentScreenState extends State<ChapaPaymentScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (url.startsWith(widget.returnUrl)) {
              // ✅ Payment success — close webview
              Navigator.pop(context, true);
            }
          },
          onPageFinished: (_) {
            setState(() => _isLoading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complete Payment")),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
