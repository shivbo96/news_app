import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/models/news_list_response.dart';

import '../../api/api_service.dart';
import '../../api/network.dart';
import '../../blocs/home/bloc/home_bloc.dart';
import '../widgets/colors.dart';
import '../widgets/common_widget.dart';
import '../widgets/search_widget.dart';
import '../widgets/styles.dart';
import 'news_detail_page.dart';

class SearchScreen extends StatelessWidget{
   final NewsListResponse dataList;

  String searchedQuery='';
  SearchScreen({Key? key,required this.dataList}) : super(key: key);


  static Route route(NewsListResponse dataList) {
    return MaterialPageRoute<void>(builder: (_) =>SearchScreen(dataList: dataList,));
  }

   @override
   Widget build(BuildContext context) {

     return BlocListener<HomeBloc, HomeState>(
         listenWhen: (previous, current) => previous.apiStatus != current.apiStatus,
         listener: (context, state) {
           if (state.apiStatus == ApiStatus.ERROR) {
             ScaffoldMessenger.of(context)
               ..hideCurrentSnackBar()
               ..showSnackBar(SnackBar(
                 content: Text(state.error.toString()),
               ));
           }
         },
         child:  BlocBuilder<HomeBloc, HomeState>(
             buildWhen: (previous, current) => previous.apiStatus != current.apiStatus,
             builder: (context, state) {
               // if(state.apiStatus == ApiStatus.SUCCESS &&
               //     (state.response is NewsListResponse)){
               //   dataList=state.response?.articles??[];
               // }
               return Scaffold(
                 backgroundColor: ColorConstants.secondary,
                 appBar: CommonWidget.appBar(context,title: '',backIcon: Icons.arrow_back_ios),
                 body: Padding(
                   padding: const EdgeInsets.all(15.0),
                   child: Column(
                     children: [
                       SearchWidget(callback: (value)=>searchNews(value,context)),
                       Padding(
                         padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 10),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Text("Top Headlines",
                                 style: Styles.semiBoldTextStyle(
                                     size: 16, color: ColorConstants.black)),
                             Row(
                               children: [
                                 Text("Sort: ",
                                     style: Styles.regularTextStyle(
                                         size: 13, color: ColorConstants.darkGray)),

                                 CustomDropDown(selectedItem: (sortBy){

                                   Utility.checkNetwork().then((isConnected) {
                                     if (isConnected) {
                                       context.read<HomeBloc>().add(GetSearchNewsList(searchedQuery,sortBy: sortBy));
                                     } else {
                                       showSnackBar(message: "No internet connection.", context: context);
                                     }
                                   });

                                 },)
                               ],
                             )
                           ],
                         ),
                       ),
                       _searchItemListView(state.apiStatus == ApiStatus.SUCCESS &&
                   (state.response is NewsListResponse)?state.response:dataList)
                     ],
                   ),
                 ),
               );
             }
         )
     );
   }

   searchNews(String query,BuildContext context){

     if(query.length>3){
       searchedQuery=query;
       Utility.checkNetwork().then((isConnected) {
         if (isConnected) {
           context.read<HomeBloc>().add(GetSearchNewsList(query));
         } else {
           showSnackBar(message: "No internet connection.", context: context);
         }
       });
     }

   }

   _searchItemListView(NewsListResponse dataList){
     return  Expanded(
         child: ListView.builder(
           shrinkWrap: true,
           itemCount: dataList.articles?.length??0,
           itemBuilder: (context, index) {
             var item = dataList.articles?[index];
             return Padding(
               padding: const EdgeInsets.all(8.0),
               child: Hero(
                 tag: "news_$index",
                 child: GestureDetector(
                   onTap: () =>
                       Navigator.push(context, NewDetailPage.route(index,item!)),
                   child: Card(
                     elevation: 3,
                     shape: RoundedRectangleBorder(
                       borderRadius: BorderRadius.circular(5.0),
                     ),
                     child: Row(
                       children: [
                         Expanded(
                           child: Padding(
                             padding: const EdgeInsets.only(
                                 left: 10.0, top: 8, bottom: 8),
                             child: Column(
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(item?.source?.name ?? "",
                                     style: Styles.mediumTextStyle(
                                         size: 12,
                                         color: ColorConstants.black
                                             .withOpacity(0.8))),
                                 CommonWidget.rowHeight(height: 10),
                                 Text(
                                     item?.description ?? "",
                                     overflow: TextOverflow.ellipsis,
                                     maxLines: 5,
                                     style: Styles.mediumTextStyle(
                                         size: 12,
                                         color: ColorConstants.primaryDark)),
                                 CommonWidget.rowHeight(height: 10),
                                 Text(item?.publishedAt??"",
                                     style: Styles.mediumTextStyle(
                                         size: 12,
                                         color: ColorConstants.black
                                             .withOpacity(0.5))),
                               ],
                             ),
                           ),
                         ),
                         item?.urlToImage!=null && item!.urlToImage!.isNotEmpty? Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Image.network(
                             item.urlToImage??"",
                             width: 120,
                             fit: BoxFit.fill,
                           ),
                         ):Container()
                       ],
                     ),
                   ),
                 ),
               ),
             );
           },
         ));
   }


}