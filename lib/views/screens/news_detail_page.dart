import 'package:flutter/material.dart';
import 'package:news_app/models/news_list_response.dart';
import 'package:news_app/views/widgets/common_widget.dart';

import '../widgets/colors.dart';
import '../widgets/styles.dart';

class NewDetailPage extends StatelessWidget{
  final int? index;
  final Articles? dataBean;
  const NewDetailPage({Key? key,this.index,this.dataBean}) : super(key: key);

 get dummyTxt=>'''What is Lorem Ipsum?
Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.

Why do we use it?
It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using 'Content here, content here', making it look like readable English. Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum' will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, sometimes on purpose (injected humour and the like).
''';
  static Route route(int i, Articles dataBean) {
    return MaterialPageRoute<void>(builder: (_) => NewDetailPage(index:i,dataBean: dataBean,));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorConstants.secondary,
        appBar: CommonWidget.appBar(context,title: '',backIcon: Icons.arrow_back_ios),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: "news_$index",
              child: Stack(children: [
                SizedBox(width:MediaQuery.of(context).size.width,child:dataBean?.urlToImage!=null && dataBean!.urlToImage!.isNotEmpty? Image.network(
                  dataBean?.urlToImage??"",
                  width: 120,
                  fit: BoxFit.fill,
                ):Container()),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        gradient: LinearGradient(
                            begin: FractionalOffset.topCenter,
                            end: FractionalOffset.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.0),
                              Colors.black.withOpacity(.5),
                            ],
                            stops: const  [
                              0.0,
                              1.0
                            ])),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                      height: 70,
                    padding: const EdgeInsets.all(10),
                    width:MediaQuery.of(context).size.width,
                      child:Align(
                        alignment: Alignment.centerLeft,
                        child: Text(dataBean?.title??"",
                            style: Styles.mediumTextStyle(
                                size: 12, color: ColorConstants.white)),
                      ),
                    ),
                  ),

              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,children: [
                Text(dataBean?.source?.name??"",
                    textAlign: TextAlign.start,
                    style: Styles.semiBoldTextStyle(
                        size: 14,
                        color: ColorConstants.black.withOpacity(0.8))),
                CommonWidget.rowHeight(height: 5),
                Text(dataBean?.publishedAt??"",
                    textAlign: TextAlign.start,//3 may 2022 at 10:04 am
                    style: Styles.mediumTextStyle(
                        size: 12))]),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0,right: 20),
              child: Text(
                  dataBean?.description??"",
                  textAlign: TextAlign.start,
                  maxLines: 20,
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mediumTextStyle(
                      size: 12,
                      color: ColorConstants.primaryDark)),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Text("See full story",
                      style: Styles.mediumTextStyle(
                          size: 14, color: ColorConstants.primary)),
                   Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                      color: ColorConstants.primary
                  ),
                ],
              ),
            )

          ],
        )
    );
  }




}