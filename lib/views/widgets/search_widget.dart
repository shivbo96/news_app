

import 'package:flutter/material.dart';
import 'package:news_app/views/widgets/colors.dart';

import '../screens/search_screen.dart';

class SearchWidget extends StatefulWidget {
  var wantToMove=false;
  Function(String)? callback;
  VoidCallback? changePage;
  SearchWidget({Key? key,this.wantToMove=false,this.callback,this.changePage}) : super(key: key);

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin:const EdgeInsets.only(left: 10,right: 10,top: 10),
      decoration: BoxDecoration(color: ColorConstants.secondaryDark, borderRadius:const BorderRadius.all(Radius.circular(5))),
      child:  Padding(
          padding:const EdgeInsets.all(10),
          child: TextField(
            onTap: widget.wantToMove?widget.changePage:null,
            minLines: 1,
            autofocus: !widget.wantToMove,
            readOnly: widget.wantToMove,
            textAlignVertical: TextAlignVertical.center,
            onChanged: (value)=>widget.callback!(value),
            maxLines: 1,
            decoration:const InputDecoration(
              border: InputBorder.none,
              hintText: "Search for news, topics...",
              suffixIcon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              isCollapsed: true,
            ),
          )),
    );
  }
}
