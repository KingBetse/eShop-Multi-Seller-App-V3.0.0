import 'package:flutter/material.dart';
import 'package:sellermultivendor/Helper/extensions/extensions.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';
import '../../../../../../Helper/Color.dart';
import '../../../../../../Helper/Constant.dart';
import '../../../../../../Model/Attribute Models/AttributeModel/AttributesModel.dart';
import '../../../../../../Model/Attribute Models/AttributeSetModel/AttributeSetModel.dart';
import '../../../../../../Model/Attribute Models/AttributeValueModel/AttributeValue.dart';
import '../../../../../../Model/CategoryModel/categoryModel.dart';
import '../../../../../../Model/ProductModel/Variants.dart';
import '../../../../../../Provider/settingProvider.dart';
import '../../../../../../Widget/FilterChips.dart';
import '../../../../../../Widget/desing.dart';
import '../../../../../../Widget/routes.dart';
import '../../../../../../Widget/snackbar.dart';
import '../../../../Add_Product.dart';
import '../../../getCommanWidget.dart';

selectionPossitionOne(BuildContext context, Function setState) {
  addProvider!.productType == 'simple_product';
  return
  // addProvider!.curSelPos == 0 &&
  //         (addProvider!.digitalProductSaveSettings ||
  //             addProvider!.simpleProductSaveSettings ||
  //             addProvider!.variantProductVariableLevelSaveSettings ||
  //             addProvider!.variantProductProductLevelSaveSettings)
  //     ?
  Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      getCommanSizedBox(),
      getCommanSizedBox(),
      getPrimaryCommanText("Attributes".translate(context: context), false),
      getCommanSizedBox(),
      Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: white,
              side: const BorderSide(color: black),
              minimumSize: Size(width * 0.43, height * 0.06),
            ),
            onPressed: () {
              if (addProvider!.attributeIndiacator ==
                  addProvider!.attrController.length) {
                addProvider!.attrController.add(TextEditingController());
                addProvider!.attrValController.add(TextEditingController());
                addProvider!.variationBoolList.add(false);
                setState();
              } else {
                setSnackbar(
                  "fill the box then add another".translate(context: context),
                  context,
                );
              }
            },
            child: Text(
              "Add Attribute".translate(context: context),
              style: const TextStyle(color: black, fontWeight: FontWeight.bold),
            ),
          ),
          getCommanSizedBoxWidth(),
          OutlinedButton(
            style: TextButton.styleFrom(
              backgroundColor: black,
              minimumSize: Size(width * 0.43, height * 0.06),
            ),
            onPressed: () {
              addProvider!.tempAttList.clear();
              List<String> attributeIds = [];
              for (var i = 0; i < addProvider!.variationBoolList.length; i++) {
                if (addProvider!.variationBoolList[i]) {
                  final attributes = addProvider!.attributesList
                      .where(
                        (element) =>
                            element.name == addProvider!.attrController[i].text,
                      )
                      .toList();
                  if (attributes.isNotEmpty) {
                    attributeIds.add(attributes.first.id!);
                  }
                }
              }
              addProvider!.resultAttr = [];
              addProvider!.resultID = [];
              addProvider!.variationList = [];
              addProvider!.finalAttList = [];
              for (var key in attributeIds) {
                addProvider!.tempAttList.add(
                  addProvider!.selectedAttributeValues[key]!,
                );
              }
              for (int i = 0; i < addProvider!.tempAttList.length; i++) {
                addProvider!.finalAttList.add(addProvider!.tempAttList[i]);
              }
              if (addProvider!.finalAttList.isNotEmpty) {
                max = addProvider!.finalAttList.length - 1;

                getCombination([], [], 0);
                addProvider!.row = 1;
                col = max + 1;
                for (int i = 0; i < col; i++) {
                  int singleRow = addProvider!.finalAttList[i].length;
                  addProvider!.row = addProvider!.row * singleRow;
                }
              }
              setSnackbar(
                "Attributes saved successfully".translate(context: context),
                context,
              );
              setState();
            },
            child: Text(
              "Save Attribute".translate(context: context),
              style: const TextStyle(fontWeight: FontWeight.bold, color: white),
            ),
          ),
        ],
      ),
      getCommanSizedBox(),
      addProvider!.productType == 'variable_product'
          ? Text(
              "Note : select checkbox if the attribute is to be used for variation"
                  .translate(context: context),
            )
          : Container(),
      getCommanSizedBox(),
      for (int i = 0; i < addProvider!.attrController.length; i++)
        addAttribute(i, context, setState),
    ],
  );
  // : Container();
}

getCombination(List<String> att, List<String> attId, int i) {
  for (int j = 0, l = addProvider!.finalAttList[i].length; j < l; j++) {
    List<String> a = [];
    List<String> aId = [];
    if (att.isNotEmpty) {
      a.addAll(att);
      aId.addAll(attId);
    }
    a.add(addProvider!.finalAttList[i][j].value!);
    aId.add(addProvider!.finalAttList[i][j].id!);
    if (i == max) {
      addProvider!.resultAttr.addAll(a);
      addProvider!.resultID.addAll(aId);
      Product_Varient model = Product_Varient(
        attr_name: a.join(","),
        id: aId.join(","),
      );
      addProvider!.variationList.add(model);
    } else {
      getCombination(a, aId, i + 1);
    }
  }
}

addAttribute(int pos, BuildContext context, Function setState) {
  final result = addProvider!.attributesList
      .where((element) => element.name == addProvider!.attrController[pos].text)
      .toList();

  final attributeId = result.isEmpty ? "" : result.first.id;

  // Check if current attribute matches selected category
  final bool matchesCategory = addProvider!.attrController[pos].text.isNotEmpty
      ? doesAttributeMatchSelectedCategory(
          addProvider!.attrController[pos].text,
        )
      : false;

  final String? selectedCategoryName = getSelectedCategoryName();

  return Card(
    color: lightWhite,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(circularBorderRadius10),
    ),
    child: Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10,
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    getPrimaryCommanText(
                      "Select Attribute".translate(context: context),
                      true,
                    ),
                    if (selectedCategoryName != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Text(
                          "Category: $selectedCategoryName",
                          style: TextStyle(
                            fontSize: 10,
                            color: primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    if (matchesCategory &&
                        addProvider!.attrController[pos].text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Row(
                          children: [
                            Icon(Icons.verified, color: Colors.green, size: 12),
                            SizedBox(width: 4),
                            Text(
                              "Matches category",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.green,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: addProvider!.variationBoolList[pos],
                    onChanged: (bool? value) {
                      addProvider!.variationBoolList[pos] = value ?? false;
                      setState();
                    },
                  ),
                  IconButton(
                    onPressed: () {
                      //removing from everywhere (try-catches are for safety when attributes are saved, their details will be in these list otherwise non try-catch lists)
                      try {
                        addProvider!.finalAttList.removeAt(pos);
                      } catch (_) {}
                      try {
                        addProvider!.attrId.removeAt(pos);
                      } catch (_) {}
                      try {
                        addProvider!.tempAttList.removeAt(pos);
                      } catch (_) {}
                      addProvider!.attrController[pos].dispose();
                      addProvider!.variationBoolList.removeAt(pos);
                      addProvider!.attrController.removeAt(pos);
                      addProvider!.selectedAttributeValues[attributeId!] = [];
                      addProvider!.attributeIndiacator =
                          addProvider!.attrController.length;
                      setState();
                    },
                    icon: const Icon(
                      Icons.delete_outline_sharp,
                      color: primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          getCommanSizedBox(),
          TextFormField(
            textAlign: TextAlign.center,
            readOnly: true,
            onTap: () {
              attributeDialog(pos, context, setState);
            },
            controller: addProvider!.attrController[pos],
            keyboardType: TextInputType.text,
            style: const TextStyle(color: black, fontWeight: FontWeight.normal),
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              filled: true,
              fillColor: white,
              hintText: selectedCategoryName != null
                  ? "Find attribute for $selectedCategoryName"
                  : "Select Attributes".translate(context: context),
              hintStyle: const TextStyle(
                color: grey,
                fontWeight: FontWeight.normal,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 40,
                maxHeight: 20,
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.transparent),
                borderRadius: BorderRadius.circular(circularBorderRadius7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: lightWhite),
                borderRadius: BorderRadius.circular(circularBorderRadius8),
              ),
            ),
          ),
          getCommanSizedBox(),
          getCommanSizedBox(),
          GestureDetector(
            onTap: () {
              if (attributeId == null || attributeId.isEmpty) {
                setSnackbar(
                  "Please select an attribute first".translate(
                    context: context,
                  ),
                  context,
                );
                return;
              }

              final attributeValues = addProvider!.attributesValueList
                  .where((element) => element.attributeId == attributeId)
                  .toList();
              addValAttribute(
                addProvider!.selectedAttributeValues[attributeId]!,
                attributeValues,
                attributeId,
                context,
                setState,
              );
            },
            child: Container(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(circularBorderRadius7),
                color: matchesCategory ? Colors.green : white,
              ),
              constraints: const BoxConstraints(minHeight: 50),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    "Add attribute value".translate(context: context),
                    style: TextStyle(
                      color: matchesCategory ? white : grey,
                      fontSize: textFontSize16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ),
            ),
          ),
          getCommanSizedBox(),
          result.isNotEmpty
              ? Wrap(
                  alignment: WrapAlignment.center,
                  direction: Axis.horizontal,
                  children: addProvider!.selectedAttributeValues[attributeId]!
                      .map(
                        (value) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                circularBorderRadius10,
                              ),
                              color: matchesCategory ? Colors.green : primary,
                              border: Border.all(
                                color: Colors.transparent,
                                width: 0.5,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                value.value!,
                                style: const TextStyle(color: white),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                )
              : Container(),
        ],
      ),
    ),
  );
}

//------------------------------------------------------------------------------
//============================ attributeDialog ===================================
// Helper method to get selected category name
String? getSelectedCategoryName() {
  final String? selectedCategoryId = addProvider!.selectedCatID;
  if (selectedCategoryId == null) return null;

  CategoryModel? findCategory(List<CategoryModel> categories, String id) {
    for (var category in categories) {
      if (category.id == id) return category;
      if (category.children != null && category.children!.isNotEmpty) {
        final found = findCategory(category.children!, id);
        if (found != null) return found;
      }
    }
    return null;
  }

  final category = findCategory(addProvider!.catagorylist, selectedCategoryId);
  return category?.name;
}

// Get attributes that match the selected category name
List<AttributeModel> getMatchingAttributesForSelectedCategory() {
  final String? selectedCategoryName = getSelectedCategoryName();
  if (selectedCategoryName == null) return [];

  return addProvider!.attributesList.where((attribute) {
    print(addProvider!.attributesList);
    return attribute.attributeSetName?.toLowerCase() ==
        selectedCategoryName.toLowerCase();
  }).toList();
}

// Check if current attribute matches selected category
bool doesAttributeMatchSelectedCategory(String attributeName) {
  final String? selectedCategoryName = getSelectedCategoryName();
  if (selectedCategoryName == null) return false;

  return attributeName.toLowerCase() == selectedCategoryName.toLowerCase();
}

attributeDialog(int pos, BuildContext context, Function setState) async {
  final String? selectedCategoryName = getSelectedCategoryName();
  final List<AttributeModel> matchingAttributes =
      getMatchingAttributesForSelectedCategory();

  await showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    backgroundColor: Colors.transparent,
    builder: (BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(circularBorderRadius25),
            topRight: Radius.circular(circularBorderRadius25),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setStater) {
              addProvider!.taxesState = setStater;

              return SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Select Attribute".translate(
                                      context: context,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium!
                                        .copyWith(color: fontColor),
                                  ),
                                  if (selectedCategoryName != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        "Category: $selectedCategoryName",
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(color: lightBlack),

                      if (selectedCategoryName == null)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.category,
                                size: 50,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "No Category Selected",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "Please select a category first to see matching attributes",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        )
                      else if (matchingAttributes.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.warning_amber,
                                size: 50,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 10),
                              Text(
                                "No Matching Attributes Found",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text(
                                "No attributes found for category:",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                selectedCategoryName,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        // You can add navigation to category selection here
                                        setSnackbar(
                                          "Please select a different category"
                                              .translate(context: context),
                                          context,
                                        );
                                      },
                                      child: Text("Change Category"),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // Show all attributes as fallback
                                        showAllAttributesDialog(
                                          pos,
                                          context,
                                          setState,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Text("Show All Attributes"),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      else
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.verified,
                                    color: Colors.green,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      "Matching attribute found for your category",
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: matchingAttributes.length,
                              itemBuilder: (context, index) {
                                final attribute = matchingAttributes[index];

                                return Card(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.verified_user,
                                      color: Colors.green,
                                    ),
                                    title: Text(attribute.name ?? ''),
                                    subtitle: Text(
                                      "Perfect match for $selectedCategoryName",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    onTap: () {
                                      addProvider!.attrController[pos].text =
                                          attribute.name!;
                                      addProvider!.attributeIndiacator =
                                          pos + 1;

                                      if (!addProvider!.attrId.contains(
                                        int.parse(attribute.id!),
                                      )) {
                                        addProvider!.attrId.add(
                                          int.parse(attribute.id!),
                                        );
                                        Routes.pop(context);
                                      } else {
                                        setSnackbar(
                                          "Already inserted..".translate(
                                            context: context,
                                          ),
                                          context,
                                        );
                                      }
                                      setState();
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}

// Fallback method to show all attributes
void showAllAttributesDialog(int pos, BuildContext context, Function setState) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(circularBorderRadius25),
        topRight: Radius.circular(circularBorderRadius25),
      ),
    ),
    builder: (context) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.warning, color: Colors.orange),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    "All Attributes (No category match)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: addProvider!.attributesList.length,
              itemBuilder: (context, index) {
                final attribute = addProvider!.attributesList[index];
                return ListTile(
                  title: Text(attribute.name ?? ''),
                  onTap: () {
                    addProvider!.attrController[pos].text = attribute.name!;
                    addProvider!.attributeIndiacator = pos + 1;

                    if (!addProvider!.attrId.contains(
                      int.parse(attribute.id!),
                    )) {
                      addProvider!.attrId.add(int.parse(attribute.id!));
                      Routes.pop(context);
                    } else {
                      setSnackbar(
                        "Already inserted..".translate(context: context),
                        context,
                      );
                    }
                    setState();
                  },
                );
              },
            ),
          ),
        ],
      );
    },
  );
}

addValAttribute(
  List<AttributeValueModel> selected,
  List<AttributeValueModel> searchRange,
  String attributeId,
  BuildContext context,
  Function update,
) {
  showModalBottomSheet<List<AttributeValueModel>>(
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(circularBorderRadius10),
        topRight: Radius.circular(circularBorderRadius10),
      ),
    ),
    enableDrag: true,
    context: context,
    builder: (context) {
      return SizedBox(
        height: 200 + MediaQuery.of(context).viewPadding.bottom,
        width: MediaQuery.of(context).size.width,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Select Attribute Value".translate(context: context),
                        style: const TextStyle(
                          fontSize: textFontSize16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
                const Divider(color: Colors.grey),
              ]),
            ),
            SliverGrid(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                maxCrossAxisExtent: width / 3,
                childAspectRatio: 2,
              ),
              delegate: SliverChildBuilderDelegate((context, index) {
                return filterChipWidget(
                  chipName: searchRange[index],
                  selectedList: selected,
                  update: update,
                  fromAdd: true,
                );
              }, childCount: searchRange.length),
            ),
          ],
        ),
      );
    },
  );
}
