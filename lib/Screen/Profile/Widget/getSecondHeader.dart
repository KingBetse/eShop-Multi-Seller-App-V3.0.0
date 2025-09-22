// import 'package:flutter/material.dart';
// import '../../../Helper/Constant.dart';
// import '../../../Widget/validation.dart';
// import '../Profile.dart';
// import 'commanDesingFields.dart';

// class GetSecondHeader extends StatelessWidget {
//   final Function setStateNow;
//   const GetSecondHeader({
//     Key? key,
//     required this.setStateNow,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20, bottom: 5.0),
//       child: Card(
//         elevation: 0,
//         shape: const RoundedRectangleBorder(
//             borderRadius:
//                 BorderRadius.all(Radius.circular(circularBorderRadius10))),
//         child: Column(
//           children: <Widget>[
//             CommanDesingFields(
//               icon: Icons.store_outlined,
//               title:   "StoreName")!,
//               variable: profileProvider!.storename,
//               empty:   "NotAdded")!,
//               addField:   "addStoreName")!,
//               key: profileProvider!.storenameKey,
//               keybordtype: TextInputType.text,
//               validation: (val) => StringValidation.validateField(val, context),
//               index: 4,
//               update: setStateNow,
//               fromMap: false,
//             ),
//             getDivider(),
//             CommanDesingFields(
//               icon: Icons.link_outlined,
//               title:   "StoreURL")!,
//               variable: profileProvider!.storeurl,
//               empty:   "NoURL")!,
//               addField:   "addURL")!,
//               key: profileProvider!.storeurlKey,
//               keybordtype: TextInputType.text,
//               validation: (val) => StringValidation.validateField(val, context),
//               index: 5,
//               update: setStateNow,
//               fromMap: false,
//             ),
//             getDivider(),
//             CommanDesingFields(
//               icon: Icons.description_outlined,
//               title:   "Description")!,
//               variable: profileProvider!.storeDesc,
//               empty:   "NotAdded")!,
//               addField:   "addDescription")!,
//               key: profileProvider!.storeDescKey,
//               keybordtype: TextInputType.text,
//               validation: (val) => StringValidation.validateField(val, context),
//               index: 6,
//               update: setStateNow,
//               fromMap: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
