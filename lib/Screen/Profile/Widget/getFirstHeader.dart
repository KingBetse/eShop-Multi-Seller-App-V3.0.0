// import 'package:flutter/material.dart';
// import '../../../Helper/Constant.dart';
// import '../../../Widget/validation.dart';
// import '../Profile.dart';
// import 'commanDesingFields.dart';

// class GetFirstHeader extends StatelessWidget {
//   final Function setStateNow;
//   const GetFirstHeader({
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
//           borderRadius: BorderRadius.all(
//             Radius.circular(
//               circularBorderRadius10,
//             ),
//           ),
//         ),
//         child: Column(
//           children: <Widget>[
//             CommanDesingFields(
//               icon: Icons.person_outlined,
//               title:   "NAME_LBL")!,
//               variable: profileProvider!.name,
//               empty:   "NotAdded")!,
//               addField:   "ADD_NAME_LBL")!,
//               key: profileProvider!.sellernameKey,
//               keybordtype: TextInputType.text,
//               validation: (val) =>
//                   StringValidation.validateUserName(val, context),
//               index: 0,
//               update: setStateNow,
//               fromMap: false,
//             ),
//             getDivider(),
//             CommanDesingFields(
//               icon: Icons.phone_in_talk_outlined,
//               title:   "MOBILEHINT_LBL")!,
//               variable: profileProvider!.mobile,
//               empty:   "NotAdded")!,
//               addField:   "Add Mobile Number")!,
//               key: profileProvider!.mobilenumberKey,
//               keybordtype: TextInputType.number,
//               validation: (val) => StringValidation.validateMob(val, context),
//               index: 1,
//               update: setStateNow,
//               fromMap: false,
//             ),
//             getDivider(),
//             CommanDesingFields(
//               icon: Icons.email_outlined,
//               title:   "Email")!,
//               variable: profileProvider!.email,
//               empty:   "NotAdded")!,
//               addField:   "addEmail")!,
//               key: profileProvider!.emailKey,
//               keybordtype: TextInputType.text,
//               validation: (val) => StringValidation.validateField(val, context),
//               index: 2,
//               update: setStateNow,
//               fromMap: false,
//             ),
//             getDivider(),
//             CommanDesingFields(
//               icon: Icons.location_on_outlined,
//               title:   "Address")!,
//               variable: profileProvider!.address,
//               empty:   "NotAdded")!,
//               addField:   "AddAddress")!,
//               key: profileProvider!.addressKey,
//               keybordtype: TextInputType.text,
//               validation: (val) => StringValidation.validateField(val, context),
//               index: 3,
//               update: setStateNow,
//               fromMap: false,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
