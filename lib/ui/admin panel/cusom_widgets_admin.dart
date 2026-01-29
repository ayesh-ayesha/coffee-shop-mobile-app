import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../view_model/cart_item_VM.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String labelText,
  String? hintText,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: labelText,
      hintText: hintText,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      filled: true,
      fillColor: Colors.grey[50],
    ),
    keyboardType: keyboardType,
    maxLines: maxLines,
    validator: validator,
  );
}

Widget buildDropdownField({
  required String labelText,
  required String? value, // Make value nullable to match Rxn<String>
  required List<String> items,
  required void Function(String?) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Using _sectionLabelStyle here for the label text
      Text(labelText, style: sectionLabelStyle()),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
          color: Colors.grey[50],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: value, // This must match one of the items or be null
            onChanged: onChanged,
            items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
          ),
        ),
      ),
    ],
  );
}

TextStyle sectionLabelStyle() {
  return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[700]);
}







