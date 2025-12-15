import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../Provider/AdvertisingPackageProvider.dart';
import 'dart:io';
// import 'package:image_picker/image_picker.dart';

class AdvertisingPackagesScreen extends StatefulWidget {
  final int userId;

  const AdvertisingPackagesScreen({super.key, required this.userId});

  @override
  State<AdvertisingPackagesScreen> createState() =>
      _AdvertisingPackagesScreenState();
}

class _AdvertisingPackagesScreenState extends State<AdvertisingPackagesScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    // Fetch packages when screen loads
    Future.microtask(() {
      final provider = Provider.of<AdvertisingPackageProvider>(
        context,
        listen: false,
      );
      print('🔄 Loading advertising packages for user: ${widget.userId}');
      provider.getAdvertisingPackages();
      // print(
      //   "hi i am getAdvertisingPackage: ${provider.getAdvertisingPackages()}",
      // );
      // Also load user's existing packages
      provider.getUserPackages(widget.userId);
    });
  }

  void _showPurchaseDialog(String packageName, int packageId, double price) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Purchase $packageName"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Price: $price ETB"),
            const SizedBox(height: 8),
            const Text("Are you sure you want to purchase this package?"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _purchasePackage(packageId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text("Purchase"),
          ),
        ],
      ),
    );
  }
  //   void _showPurchaseDialog(String packageName, int packageId, double price) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: Text("Purchase $packageName"),
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Text("Price: $price ETB"),
  //           const SizedBox(height: 8),
  //           const Text("Choose your payment method:"),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text("Cancel"),
  //         ),
  //         ElevatedButton.icon(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             _purchaseWithChapa(packageId);
  //           },
  //           icon: const Icon(Icons.payment),
  //           label: const Text("Pay with Chapa"),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.green,
  //             foregroundColor: Colors.white,
  //           ),
  //         ),
  //         ElevatedButton.icon(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             _showBankPaymentDialog(packageName, packageId, price);
  //           },
  //           icon: const Icon(Icons.account_balance),
  //           label: const Text("Pay with Bank"),
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Colors.blue,
  //             foregroundColor: Colors.white,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  // void _purchaseWithChapa(int packageId) {
  //   _purchasePackage(packageId);
  // }

  // void _showBankPaymentDialog(String packageName, int packageId, double price) {
  //   XFile? receiptImage;

  //   showDialog(
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) => AlertDialog(
  //           title: Text("Bank Payment for $packageName"),
  //           content: SingleChildScrollView(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Text("💰 Price: $price ETB"),
  //                 const SizedBox(height: 8),
  //                 const Text(
  //                   "🏦 Bank Details:",
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 4),
  //                 const Text("Bank: Abyssinia Bank"),
  //                 const Text("Account Name: YourCompany PLC"),
  //                 const Text("Account Number: 1234567890123"),
  //                 const SizedBox(height: 16),
  //                 const Text(
  //                   "Upload your receipt photo:",
  //                   style: TextStyle(fontWeight: FontWeight.bold),
  //                 ),
  //                 const SizedBox(height: 8),
  //                 if (receiptImage != null)
  //                   Image.file(
  //                     File(receiptImage!.path),
  //                     height: 150,
  //                     fit: BoxFit.cover,
  //                   ),
  //                 const SizedBox(height: 8),
  //                 ElevatedButton.icon(
  //                   onPressed: () async {
  //                     final picker = ImagePicker();
  //                     final pickedFile = await picker.pickImage(
  //                       source: ImageSource.gallery,
  //                     );
  //                     if (pickedFile != null) {
  //                       setState(() => receiptImage = pickedFile);
  //                     }
  //                   },
  //                   icon: const Icon(Icons.upload),
  //                   label: const Text("Upload Receipt"),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () => Navigator.pop(context),
  //               child: const Text("Cancel"),
  //             ),
  //             ElevatedButton(
  //               onPressed: () {
  //                 if (receiptImage == null) {
  //                   ScaffoldMessenger.of(context).showSnackBar(
  //                     const SnackBar(
  //                       content: Text("Please upload a receipt first."),
  //                       backgroundColor: Colors.red,
  //                     ),
  //                   );
  //                   return;
  //                 }

  //                 Navigator.pop(context);
  //                 _submitBankPayment(packageId, receiptImage!);
  //               },
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.green,
  //                 foregroundColor: Colors.white,
  //               ),
  //               child: const Text("Submit Payment"),
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // void _submitBankPayment(int packageId, XFile receiptImage) async {
  //   print('📤 Submitting bank payment for package $packageId');
  //   print('🧾 Receipt file: ${receiptImage.path}');

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text("Receipt uploaded successfully! We'll verify your payment soon."),
  //       backgroundColor: Colors.green,
  //       duration: Duration(seconds: 3),
  //     ),
  //   );
  // }

  void _purchasePackage(int packageId) async {
    final provider = Provider.of<AdvertisingPackageProvider>(
      context,
      listen: false,
    );

    print('🛒 Purchasing package: $packageId for user: ${widget.userId}');

    await provider.purchasePackage(context: context, packageId: packageId);

    // Show result message
    if (provider.errorMessage != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage!),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } else if (provider.paymentUrl != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Redirecting to payment..."),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _showUserPackages() async {
    final provider = Provider.of<AdvertisingPackageProvider>(
      context,
      listen: false,
    );

    await provider.getUserPackages(widget.userId); // fetch first

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      builder: (_) {
        // read from provider INSIDE builder
        final packages = Provider.of<AdvertisingPackageProvider>(
          context,
        ).userPackages;

        if (packages.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.card_giftcard, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  "No packages purchased yet",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Your Packages",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: packages.length,
                  itemBuilder: (_, index) {
                    final userPkg = packages[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(userPkg["name"] ?? "Unknown Package"),
                        subtitle: Text(
                          "Status: ${userPkg["status"] ?? "unknown"}",
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showUserPackages() async {
  //   final provider = await Provider.of<AdvertisingPackageProvider>(context);
  //   print('🔍 User packages: ${provider.userPackages}');
  //   if (provider.userPackages.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("You don't have any packages yet"),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     return;
  //   }
  //   if (!mounted) return;

  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (context) => Container(
  //       padding: const EdgeInsets.all(16),
  //       height: MediaQuery.of(context).size.height * 0.8,
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               const Text(
  //                 "Your Packages",
  //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  //               ),
  //               IconButton(
  //                 icon: const Icon(Icons.close),
  //                 onPressed: () => Navigator.pop(context),
  //               ),
  //             ],
  //           ),
  //           const SizedBox(height: 16),
  //           Expanded(
  //             child: provider.userPackages.isEmpty
  //                 ? const Center(
  //                     child: Column(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Icon(
  //                           Icons.card_giftcard,
  //                           size: 64,
  //                           color: Colors.grey,
  //                         ),
  //                         SizedBox(height: 16),
  //                         Text(
  //                           "No packages purchased yet",
  //                           style: TextStyle(fontSize: 16, color: Colors.grey),
  //                         ),
  //                       ],
  //                     ),
  //                   )
  //                 : ListView.builder(
  //                     itemCount: provider.userPackages.length,
  //                     itemBuilder: (context, index) {
  //                       final userPkg = provider.userPackages[index];
  //                       return Card(
  //                         margin: const EdgeInsets.only(bottom: 8),
  //                         child: ListTile(
  //                           contentPadding: const EdgeInsets.all(16),
  //                           leading: Container(
  //                             width: 50,
  //                             height: 50,
  //                             decoration: BoxDecoration(
  //                               color: _getStatusColor(
  //                                 userPkg["status"],
  //                               ).withOpacity(0.2),
  //                               borderRadius: BorderRadius.circular(25),
  //                             ),
  //                             child: Icon(
  //                               _getStatusIcon(userPkg["status"]),
  //                               color: _getStatusColor(userPkg["status"]),
  //                             ),
  //                           ),
  //                           title: Text(
  //                             userPkg["name"] ?? "Unknown Package",
  //                             style: const TextStyle(
  //                               fontWeight: FontWeight.bold,
  //                             ),
  //                           ),
  //                           subtitle: Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             children: [
  //                               const SizedBox(height: 4),
  //                               Text(
  //                                 "Price: ${userPkg["price"]?.toStringAsFixed(2) ?? "0"} ETB",
  //                               ),
  //                               const SizedBox(height: 4),
  //                               Text(
  //                                 "Status: ${userPkg["status"] ?? "unknown"}",
  //                               ),
  //                               if (userPkg["start_date"] != null)
  //                                 Text(
  //                                   "Start: ${_formatDate(userPkg["start_date"])}",
  //                                 ),
  //                               if (userPkg["end_date"] != null)
  //                                 Text(
  //                                   "End: ${_formatDate(userPkg["end_date"])}",
  //                                 ),
  //                             ],
  //                           ),
  //                           trailing: Container(
  //                             padding: const EdgeInsets.symmetric(
  //                               horizontal: 12,
  //                               vertical: 6,
  //                             ),
  //                             decoration: BoxDecoration(
  //                               color: _getStatusColor(userPkg["status"]),
  //                               borderRadius: BorderRadius.circular(12),
  //                             ),
  //                             child: Text(
  //                               userPkg["status"]?.toString().toUpperCase() ??
  //                                   "UNKNOWN",
  //                               style: const TextStyle(
  //                                 color: Colors.white,
  //                                 fontSize: 10,
  //                                 fontWeight: FontWeight.bold,
  //                               ),
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Color _getStatusColor(String? status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String? status) {
    switch (status) {
      case 'active':
        return Icons.check_circle;
      case 'pending':
        return Icons.pending;
      case 'expired':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return "${date.day}/${date.month}/${date.year}";
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildPackageCard(Map<String, dynamic> pkg) {
    List<String> features = [];

    // Handle both string and array features
    if (pkg['features_array'] != null) {
      features = List<String>.from(pkg['features_array']);
    } else if (pkg['features'] != null) {
      features = pkg['features'].toString().split('|');
    }

    // SAFELY EXTRACT VALUES - IDs are strings from API
    String packageName = pkg["name"] ?? "Unnamed Package";

    // Handle price conversion (it's a string from API)
    double price = 0.0;
    if (pkg["price"] is String) {
      price = double.tryParse(pkg["price"]) ?? 0.0;
    } else if (pkg["price"] is int) {
      price = (pkg["price"] as int).toDouble();
    } else if (pkg["price"] is double) {
      price = pkg["price"];
    }

    // Handle ID conversion (it's a string from API)
    int packageId = 0;
    if (pkg["id"] is String) {
      packageId = int.tryParse(pkg["id"]) ?? 0;
    } else if (pkg["id"] is int) {
      packageId = pkg["id"];
    }

    // Handle duration conversion (it's a string from API)
    int durationDays = 30;
    if (pkg["duration_days"] is String) {
      durationDays = int.tryParse(pkg["duration_days"]) ?? 30;
    } else if (pkg["duration_days"] is int) {
      durationDays = pkg["duration_days"];
    }

    return Card(
      margin: const EdgeInsets.all(12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Package Header
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(Icons.ads_click, color: Colors.blue),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        packageName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Price: ${price.toStringAsFixed(2)} ETB",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Duration
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  "Duration: $durationDays days",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Features
            const Text(
              "Features:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            if (features.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features
                    .map(
                      (feature) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 16,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature.trim(),
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              )
            else
              const Text(
                "No features listed",
                style: TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
              ),

            const SizedBox(height: 16),

            // Purchase Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showPurchaseDialog(packageName, packageId, price);
                },
                icon: const Icon(Icons.shopping_cart),
                label: const Text(
                  "Purchase Package",
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdvertisingPackageProvider>(context);

    // Debug information
    print(
      '🔄 Build called - Loading: ${provider.isLoading}, Error: ${provider.errorMessage}, Packages: ${provider.allPackages.length}',
    );

    // Debug: Print first package structure
    if (provider.allPackages.isNotEmpty) {
      print('🔍 First package structure: ${provider.allPackages[0]}');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Advertising Packages"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            onPressed: provider.isLoading ? null : _showUserPackages,
            tooltip: "View Your Packages",
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: provider.isLoading
                ? null
                : () {
                    print('🔄 Manual refresh triggered');
                    _loadData();
                  },
            tooltip: "Refresh",
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading advertising packages..."),
                ],
              ),
            )
          : provider.errorMessage != null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      provider.errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            )
          : provider.allPackages.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inventory_2, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    "No packages available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadData,
                    child: const Text("Refresh"),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // User info header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: Colors.blue[50],
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: Colors.blue),
                      const SizedBox(width: 8),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       "User ID: ${widget.userId}",
                      //       style: const TextStyle(fontWeight: FontWeight.bold),
                      //     ),
                      //     Text(
                      //       "${provider.allPackages.length} packages available",
                      //       style: TextStyle(color: Colors.grey[700]),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
                // Packages list
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.allPackages.length,
                    itemBuilder: (context, index) {
                      final pkg = provider.allPackages[index];
                      print('📦 Displaying package: ${pkg["name"]}');
                      return _buildPackageCard(pkg);
                    },
                  ),
                ),
              ],
            ),
      // Floating action button for quick access to user packages
      floatingActionButton: FloatingActionButton(
        onPressed: _showUserPackages,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        child: const Icon(Icons.card_giftcard),
        tooltip: "View Your Packages",
      ),
    );
  }
}
