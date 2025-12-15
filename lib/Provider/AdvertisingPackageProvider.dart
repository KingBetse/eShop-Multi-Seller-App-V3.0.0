import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:sellermultivendor/Screen/ChappaScreen/ChapaPaymentScreen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Repository/advertingRepository.dart';
import '../Widget/api.dart';

class AdvertisingPackageProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  String? paymentUrl;

  List<dynamic> allPackages = [];
  List<dynamic> userPackages = [];
  Map<String, dynamic>? packageStatus;

  /// 🔹 Fetch all available advertising packages
  // Future<void> getAdvertisingPackages() async {
  //   try {
  //     isLoading = true;
  //     errorMessage = null;
  //     notifyListeners();

  //     print('🌐 Fetching packages from: $getAdvertisingPackagesApi');

  //     final response = await http.get(getAdvertisingPackagesApi);

  //     print('📡 Response status: ${response.statusCode}');
  //     print('📦 Response body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       // Handle both response formats from your PHP functions
  //       if (data['success'] == true) {
  //         // New format from get_advertising_packages()
  //         allPackages = data["packages"] ?? [];
  //         print('✅ Loaded ${allPackages.length} packages (new format)');
  //       } else if (data['error'] == false) {
  //         // Old format from get_ad_packages()
  //         allPackages = data["data"] ?? [];
  //         print('✅ Loaded ${allPackages.length} packages (old format)');
  //       } else {
  //         errorMessage =
  //             data['error'] ?? data['message'] ?? "Failed to load packages.";
  //       }
  //     } else {
  //       errorMessage = "Server error: ${response.statusCode}";
  //     }
  //   } catch (e) {
  //     errorMessage = "Error fetching packages: $e";
  //     print('❌ Error: $e');
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
  Future<void> getAdvertisingPackages() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      print('🌐 Fetching packages from: $getAdvertisingPackagesApi');

      final response = await http.get(getAdvertisingPackagesApi);

      print('📡 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Check if response is HTML error
        if (response.body.contains('error_404') ||
            response.body.contains('OPEN IN APP')) {
          errorMessage = "API endpoint not found. Please check server routes.";
          print('❌ Got HTML error page');
          return;
        }

        try {
          final data = jsonDecode(response.body);

          if (data['success'] == true) {
            allPackages = data["packages"] ?? [];
            print('✅ Successfully loaded ${allPackages.length} packages');

            // Debug: Print package names
            for (var pkg in allPackages) {
              print('📦 Package: ${pkg['name']} - ${pkg['price']} ETB');
            }
          } else {
            errorMessage = data['error'] ?? "Failed to load packages.";
          }
        } catch (e) {
          errorMessage = "Invalid JSON response: $e";
          print('❌ JSON decode error: $e');
        }
      } else {
        errorMessage = "Server error: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Network error: $e";
      print('❌ Network error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Buy an advertising package - UPDATED for your PHP function
  // Future<void> purchasePackage({required int packageId}) async {
  //   try {
  //     isLoading = true;
  //     errorMessage = null;
  //     paymentUrl = null;
  //     notifyListeners();

  //     print('🛒 Purchasing package: package=$packageId');

  //     // Try the new API format first
  //     final response = await http.post(
  //       buyAdvertisingPackageApi,
  //       headers: {"Content-Type": "application/json"},
  //       body: jsonEncode({"package_id": packageId}),
  //     );

  //     print('📡 Purchase response: ${response.statusCode}');
  //     print('📦 Purchase body: ${response.body}');

  //     final data = jsonDecode(response.body);

  //     if (response.statusCode == 200) {
  //       // Handle both response formats
  //       if (data['success'] == true) {
  //         // New format - get transaction reference
  //         String txRef = data['tx_ref'];
  //         print('✅ Purchase initiated. TxRef: $txRef');

  //         // You might want to save txRef for status checking
  //         // For now, we'll show success message
  //         errorMessage = "Purchase initiated successfully. Reference: $txRef";
  //       } else if (data['error'] == false && data['payment_url'] != null) {
  //         // Old format - has payment URL
  //         paymentUrl = data["payment_url"];
  //         print('✅ Payment URL: $paymentUrl');

  //         // Open payment URL in browser
  //         final uri = Uri.parse(paymentUrl!);
  //         if (await canLaunchUrl(uri)) {
  //           await launchUrl(uri, mode: LaunchMode.externalApplication);
  //         } else {
  //           errorMessage = "Could not open payment page.";
  //         }
  //       } else {
  //         errorMessage =
  //             data["message"] ??
  //             data['error'] ??
  //             "Payment initialization failed.";
  //       }
  //     } else {
  //       errorMessage =
  //           data["message"] ??
  //           "Payment initialization failed. Status: ${response.statusCode}";
  //     }
  //   } catch (e) {
  //     errorMessage = "Error purchasing package: $e";
  //     print('❌ Purchase error: $e');
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> purchasePackage({required int packageId}) async {
  //   try {
  //     isLoading = true;
  //     errorMessage = null;
  //     paymentUrl = null;
  //     notifyListeners();

  //     print('🛒 Purchasing package: $packageId');

  //     // Create the parameter map that the repository expects
  //     final Map<String, dynamic> parameter = {
  //       'package_id': packageId,
  //       // Remove user_id - backend gets it from session/token
  //     };

  //     print('📤 Sending parameters: $parameter');

  //     // Call repository with the parameter map
  //     final Map<String, dynamic> response =
  //         await AdvertingPackageRepository.buyAdvertPackage(
  //           parameter: {"package_id": packageId.toString()},
  //         );

  //     print(
  //       '💰 Purchase response status: ${response['status']}',
  //     ); // Adjust based on actual response structure
  //     print('📦 Purchase response: $response');

  //     //       if (response['success'] == true) {
  //     //         final txRef =
  //     //             response['tx_ref'] ??
  //     //             (response['data'] != null ? response['data']['tx_ref'] : null);

  //     //         if (txRef is String) {
  //     // paymentUrl = response['payment_url'];
  //     //           print('✅ Purchase initiated successfully with tx_ref: $paymentUrl');
  //     //         } else {
  //     //           errorMessage = "Invalid tx_ref format in response.";
  //     //           print('⚠️ Invalid tx_ref format: $txRef');
  //     //         }
  //     //       }
  //     if (response['success'] == true) {
  //       paymentUrl = response['payment_url'];
  //     final returnUrl = "https://your-backend.com/payment/success";

  //       print('✅ Purchase initiated successfully, redirecting to: $paymentUrl');

  //       if (paymentUrl != null && paymentUrl!.isNotEmpty) {
  //         await _launchPaymentUrl(paymentUrl!);
  //       } else {
  //         errorMessage = "Payment URL not found in response.";
  //         print('⚠️ Missing payment URL.');
  //       }
  //     } else {
  //       errorMessage = response['error'] ?? "Failed to purchase package.";
  //       print('❌ Purchase failed: $errorMessage');
  //     }
  //   } catch (e) {
  //     errorMessage = "Error purchasing package: $e";
  //     print('❌ Purchase error: $e');
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // Future<void> _launchPaymentUrl(String url) async {
  //   final Uri uri = Uri.parse(url);
  //   if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
  //     throw Exception('Could not launch $url');
  //   }
  // }
  Future<void> purchasePackage({
    required BuildContext context,
    required int packageId,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      paymentUrl = null;
      notifyListeners();

      print('🛒 Purchasing package: $packageId');

      final Map<String, dynamic> response =
          await AdvertingPackageRepository.buyAdvertPackage(
            parameter: {"package_id": packageId.toString()},
          );

      print('📦 Purchase response: $response');

      if (response['success'] == true) {
        paymentUrl = response['payment_url'];
        final returnUrl = "https://your-backend.com/payment/success";

        print('✅ Purchase initiated successfully, redirecting to: $paymentUrl');

        if (paymentUrl != null && paymentUrl!.isNotEmpty) {
          // 👉 Open in WebView instead of external browser
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ChapaPaymentScreen(
                paymentUrl: paymentUrl!,
                returnUrl: returnUrl,
              ),
            ),
          );

          // If WebView detected successful return
          if (result == true) {
            // TODO: optionally call backend verify(tx_ref)
            print('✅ Payment completed inside app!');
          } else {
            print('⚠️ Payment was cancelled or failed.');
          }
        } else {
          errorMessage = "Payment URL not found in response.";
          print('⚠️ Missing payment URL.');
        }
      } else {
        errorMessage = response['error'] ?? "Failed to purchase package.";
        print('❌ Purchase failed: $errorMessage');
      }
    } catch (e) {
      errorMessage = "Error purchasing package: $e";
      print('❌ Purchase error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Get all packages purchased by a specific user - UPDATED
  // Future<void> getUserPackages(int userId) async {
  //   try {
  //     isLoading = true;
  //     errorMessage = null;
  //     notifyListeners();

  //     print('👤 Getting packages for user: $userId');

  //     // Use GET with query parameter instead of POST
  //     final Uri uri = Uri.parse('$getUserPackagesApi?user_id=$userId');
  //     final response = await http.get(uri);

  //     print('📡 User packages response: ${response.statusCode}');
  //     print('📦 User packages body: ${response.body}');

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);

  //       if (data['success'] == true) {
  //         userPackages = data["packages"] ?? [];
  //         print('✅ Loaded ${userPackages.length} user packages');
  //       } else {
  //         errorMessage = data['error'] ?? "Failed to load user packages.";
  //       }
  //     } else {
  //       errorMessage =
  //           "Failed to load user packages. Status: ${response.statusCode}";
  //     }
  //   } catch (e) {
  //     errorMessage = "Error fetching user packages: $e";
  //     print('❌ User packages error: $e');
  //   } finally {
  //     isLoading = false;
  //     notifyListeners();
  //   }
  // }
  Future<void> getUserPackages(int userId) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      print('👤 Getting packages for authenticated user');

      final Map<String, dynamic> response =
          await AdvertingPackageRepository.getUserPackage();

      print('📦 User packages data: $response');

      if (response['success'] == true) {
        userPackages = response["packages"] ?? [];
        print('✅ Loaded ${userPackages.length} user packages');
      } else {
        errorMessage = response['error'] ?? "Failed to load user packages.";
      }
    } catch (e) {
      errorMessage = "Unexpected error: $e";
      print('❌ User packages unexpected error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Check package status by transaction reference - UPDATED
  Future<void> checkPackageStatus(String txRef) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      print('🔍 Checking package status for: $txRef');

      // Use GET with query parameter
      final Uri uri = Uri.parse('$checkPackageStatusApi?tx_ref=$txRef');
      final response = await http.get(uri);

      print('📡 Status response: ${response.statusCode}');
      print('📦 Status body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['success'] == true) {
          packageStatus = data['package'];
          print('✅ Package status: ${packageStatus?['status']}');
        } else {
          errorMessage = data['error'] ?? "Failed to check package status.";
        }
      } else {
        errorMessage =
            "Failed to check package status. Status: ${response.statusCode}";
      }
    } catch (e) {
      errorMessage = "Error checking package status: $e";
      print('❌ Status check error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 New method: Verify payment after returning from Chapa
  Future<void> verifyPayment(String txRef) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      print('🔐 Verifying payment for: $txRef');

      final response = await http.post(
        verifyChapaPaymentApi, // You'll need to add this to api.dart
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"tx_ref": txRef}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        print('✅ Payment verified successfully');
        // Refresh user packages after successful payment
        // You might want to get userId from somewhere
        // await getUserPackages(userId);
      } else {
        errorMessage = data['error'] ?? "Payment verification failed";
      }
    } catch (e) {
      errorMessage = "Error verifying payment: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
