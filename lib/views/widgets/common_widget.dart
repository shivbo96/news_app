import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app/views/widgets/colors.dart';
import 'package:news_app/views/widgets/styles.dart';

class CommonWidget {
  static AppBar appBar(BuildContext context,
      {String? title = "",
      Widget? titleChild,
      IconData? backIcon,
      bool? centerTitle,
      double? toolbarHeight,
      Color? color,
      Color? backgroundColor,
      List<Widget>? actions,
      void Function()? callback}) {
    return AppBar(
      toolbarHeight: toolbarHeight,
      leading: backIcon == null
          ? Container()
          : IconButton(
              icon: Icon(
                backIcon,
                color: color ?? Colors.white,
                size: 22,
              ),
              onPressed: () {
                if (callback != null) {
                  callback();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
      centerTitle: centerTitle ?? true,
      title: title != null
          ? Text(
              title.toString(),
              style:
                  Styles.mediumTextStyle(size: 18, color: ColorConstants.white),
            )
          : titleChild ?? Container(),
      actions: actions ?? [],
      backgroundColor: backgroundColor ?? ColorConstants.primary,
      elevation: 0.0,
    );
  }

  static SizedBox rowHeight({double height = 30}) {
    return SizedBox(height: height);
  }

  static SizedBox rowWidth({double width = 30}) {
    return SizedBox(width: width);
  }

  static void toast(String msg) async {
    await Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}

class CustomCheckBox extends StatefulWidget {
  bool isApplied;
  Function(bool) isClicked;

  CustomCheckBox({Key? key, required this.isApplied, required this.isClicked})
      : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: widget.isApplied,
        onChanged: (value) {
          setState(() {
            widget.isApplied = !widget.isApplied;
          });
          widget.isClicked(widget.isApplied);
        });
  }
}

class CustomDropDown extends StatefulWidget {
  Function(String) selectedItem;

  CustomDropDown({Key? key, required this.selectedItem}) : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  var dropDownItems = [
    'relevancy',
    'publishedAt',
    'popularity',
  ];

  String dropdownvalue = 'relevancy';

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DropdownButtonHideUnderline(
            child: DropdownButton(
              value: dropdownvalue,
              icon: const Icon(Icons.arrow_drop_down, size: 15),
              items: dropDownItems.map((String items) {
                return DropdownMenuItem(
                  value: items,
                  child: Text(items,
                      style: Styles.regularTextStyle(
                          size: 14, color: ColorConstants.black)),
                );
              }).toList(),
              // After selecting the desired option,it will
              // change button value to selected value
              onChanged: (String? newValue) {
                setState(() {
                  dropdownvalue = newValue!;
                });
                widget.selectedItem(dropdownvalue);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CustomRadioButton extends StatefulWidget {
  int index;
  int selectedItem;
  Function(int) isClicked;

  CustomRadioButton(
      {Key? key,
      required this.selectedItem,
      required this.index,
      required this.isClicked})
      : super(key: key);

  @override
  State<CustomRadioButton> createState() => _CustomRadioButtonState();
}

class _CustomRadioButtonState extends State<CustomRadioButton> {
  int selectedPosition = -1;

  @override
  Widget build(BuildContext context) {
    return Radio(
        onChanged: (value) {
          setState(() {
            selectedPosition = widget.index;
            widget.isClicked(selectedPosition);
          });
        },
        groupValue: widget.selectedItem,
        value: widget.index);
  }
}
