import '../Helper/ApiBaseHelper.dart';
import '../Widget/api.dart';

class AdvertingPackageRepository {
  // static Future<Map<String, dynamic>> setStockStatus({var parameter}) async {
  //   try {
  //     var response = await ApiBaseHelper().postAPICall(
  //       manageStockApi,
  //       parameter,
  //     );

  //     return response;
  //   } on Exception catch (e) {
  //     throw ApiException('Something went wrong, ${e.toString()}');
  //   }
  // }

  // static Future<Map<String, dynamic>> getProduct({var parameter}) async {
  //   try {
  //     var taxDetail = await ApiBaseHelper().postAPICall(
  //       getProductsApi,
  //       parameter,
  //     );

  //     return taxDetail;
  //   } on Exception catch (e) {
  //     throw ApiException('Something went wrong, ${e.toString()}');
  //   }
  // }

  static Future<Map<String, dynamic>> getUserPackage() async {
    try {
      var taxDetail = await ApiBaseHelper().postAPICall(getUserPackagesApi, {});

      return taxDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> buyAdvertPackage({var parameter}) async {
    try {
      var taxDetail = await ApiBaseHelper().postAPICall(
        buyAdvertisingPackageApi,
        parameter,
      );

      return taxDetail;
    } on Exception catch (e) {
      throw ApiException('Something went wrong, ${e.toString()}');
    }
  }

  // static Future<Map<String, dynamic>> updateProductStatus({
  //   var parameter,
  // }) async {
  //   try {
  //     var taxDetail = await ApiBaseHelper().postAPICall(
  //       updateProductStatusAPI,
  //       parameter,
  //     );

  //     return taxDetail;
  //   } on Exception catch (e) {
  //     throw ApiException('Something went wrong, ${e.toString()}');
  //   }
  // }

  // static Future<Map<String, dynamic>> deleteProductApi({var parameter}) async {
  //   try {
  //     var taxDetail = await ApiBaseHelper().postAPICall(
  //       getDeleteProductApi,
  //       parameter,
  //     );

  //     return taxDetail;
  //   } on Exception catch (e) {
  //     throw ApiException('Something went wrong, ${e.toString()}');
  //   }
  // }
}
