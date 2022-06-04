import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/api/api_service.dart';
import 'package:news_app/models/news_list_response.dart';
import 'package:news_app/models/user.dart';
import 'package:news_app/views/screens/search_screen.dart';

import '../../api/network.dart';
import '../../blocs/home/bloc/home_bloc.dart';
import '../../models/filter_model.dart';
import '../widgets/colors.dart';
import '../widgets/common_widget.dart';
import '../widgets/search_widget.dart';
import '../widgets/styles.dart';
import 'news_detail_page.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key, User? user}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => HomeScreen());
  }

  late List<FilterModel> filterList = [];
  List<FilterModel> locationList = [
    FilterModel(name: 'USA', id: 'us'),
    FilterModel(name: 'India', id: 'in'),
    FilterModel(name: 'Nepal', id: 'np'),
    FilterModel(name: 'United Arab Emirates', id: 'ae'),
    FilterModel(name: 'Argentina', id: 'ar'),
    FilterModel(name: 'Austria', id: 'at'),
    FilterModel(name: 'Australia', id: 'au'),
    FilterModel(name: 'Belgium', id: 'be'),
    FilterModel(name: 'Bulgaria', id: 'br'),
    FilterModel(name: 'Canada', id: 'ca'),
    FilterModel(name: 'Switzerland', id: 'ch'),
    FilterModel(name: 'China', id: 'cn'),
    FilterModel(name: 'Colombia', id: 'co'),
    FilterModel(name: 'Cuba', id: 'cu'),
  ];

  late List<String> selectedFilterList = [];
  late FilterModel selectedLocation;

  @override
  Widget build(BuildContext context) {
    selectedLocation = locationList.first;
    Utility.checkNetwork().then((isConnected) {
      if (isConnected) {
        context.read<HomeBloc>().add(GetNewsByLocation(selectedLocation.id));
        context.read<HomeBloc>().add(GetChangeLocation(selectedLocation.name));
      } else {
        showSnackBar(message: "No internet connection.", context: context,callback: (){
          Utility.checkNetwork().then((isConnected) {
            context.read<HomeBloc>().add(GetNewsByLocation(selectedLocation.id));
            context.read<HomeBloc>().add(GetChangeLocation(selectedLocation.name));
            // if (isConnected) {
            //
            // } else {
            //   showSnackBar(message: "No connection.", context: context);
            // }
          });
        });
      }
    });
    return BlocListener<HomeBloc, HomeState>(
      listenWhen: (previous, current) =>
          previous.apiStatus != current.apiStatus,
      listener: (context, state) {
        if (state.apiStatus == ApiStatus.ERROR) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(
              content: Text(state.error.toString()),
            ));
        }
      },
      child: BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) => previous.apiStatus != current.apiStatus,
          builder: (context, state) {
            return Scaffold(
                backgroundColor: ColorConstants.secondary,
                appBar: AppBar(
                  toolbarHeight: 80,
                  backgroundColor: ColorConstants.primary,
                  title: Text("News App",
                      style: Styles.mediumTextStyle(
                          size: 18, color: ColorConstants.white)),
                  centerTitle: false,
                  actions: [
                    GestureDetector(
                      onTap: () {

                        Utility.checkNetwork().then((isConnected) {
                          if (isConnected) {
                            if (locationList.isNotEmpty) {
                              showLocationOption(context);
                            } else {
                              showSnackBar(
                                  message: "No location found", context: context);
                            }
                          } else {
                            showSnackBar(message: "No internet connection.", context: context,callback: (){
                              context.read<HomeBloc>().add(GetNewsByLocation(selectedLocation.id));
                              context.read<HomeBloc>().add(GetChangeLocation(selectedLocation.name));
                            });
                          }
                        });


                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Location",
                                style: Styles.mediumTextStyle(
                                    size: 12, color: ColorConstants.white)),
                            CommonWidget.rowHeight(height: 2),
                            Row(
                              children: [
                                const Icon(Icons.location_on, size: 15),
                                CommonWidget.rowWidth(width: 10),
                                _LocationText()
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                body: state.apiStatus == ApiStatus.SUCCESS &&
                        (state.response is NewsListResponse)
                    ? _mainView(state.response, context)
                    : state.apiStatus == ApiStatus.LOADING
                        ? const Center(child: CircularProgressIndicator())
                        : Container(),
                floatingActionButton: FloatingActionButton(
                    onPressed: () {

                      Utility.checkNetwork().then((isConnected) {
                        if (isConnected) {
                          if (filterList.isNotEmpty) {
                            showFilterOption(context);
                          } else {
                            showSnackBar(
                                message: "No List found", context: context);
                          }
                        } else {
                          showSnackBar(message: "No internet connection.", context: context,callback: (){
                            context.read<HomeBloc>().add(GetNewsByLocation(selectedLocation.id));
                            context.read<HomeBloc>().add(GetChangeLocation(selectedLocation.name));
                          });
                        }
                      });

                    },
                    child: const Icon(Icons.filter_alt_outlined),
                    backgroundColor: ColorConstants.primary),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.endFloat);
          }),
    );
  }

  _mainView(NewsListResponse data, BuildContext context) {
    filterList=[];
    data.articles?.forEach((element) {
      if (filterList.isEmpty) {
        filterList.add(FilterModel(
            name: element.source?.name ?? "", id: element.source?.id ?? ""));
      } else {
        var elementIndex = filterList.indexWhere((element1) =>
            element1.name.toString().toLowerCase() ==
            element.source?.name.toString().toLowerCase());

        if (elementIndex == -1) {
          if (element.source?.id != null) {
            filterList.add(FilterModel(
                name: element.source?.name ?? "",
                id: element.source?.id ?? ""));
          }
        }
      }
    });
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          SearchWidget(
              wantToMove: true,
              changePage: () =>
                  Navigator.push(context, SearchScreen.route(data))),
          Expanded(
              child: ListView.builder(
            shrinkWrap: true,
            itemCount: data.articles?.length ?? 0,
            itemBuilder: (context, index) {
              var item = data.articles?[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Hero(
                  tag: "news_$index",
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                        context, NewDetailPage.route(index, item!)),
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
                                  Text(item?.description ?? "",
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      style: Styles.mediumTextStyle(
                                          size: 12,
                                          color: ColorConstants.primaryDark)),
                                  CommonWidget.rowHeight(height: 10),
                                  Text(item?.publishedAt ?? "",
                                      style: Styles.mediumTextStyle(
                                          size: 12,
                                          color: ColorConstants.black
                                              .withOpacity(0.5))),
                                ],
                              ),
                            ),
                          ),
                          item?.urlToImage != null &&
                                  item!.urlToImage!.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    item.urlToImage ?? "",
                                    width: 120,
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ))
        ],
      ),
    );
  }

  showFilterOption(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: filterList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var item = filterList[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 19.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name,
                                  style: Styles.regularTextStyle(
                                      size: 15, color: ColorConstants.black)),
                              CustomCheckBox(
                                isApplied: item.isApplied ?? false,
                                isClicked: (isChecked) {
                                  if (isChecked) {
                                    selectedFilterList.add(item.id);
                                  } else {
                                    selectedFilterList.remove(item.id);
                                  }
                                  item.isApplied = !item.isApplied!;
                                },
                              )
                            ],
                          ));
                    })),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (selectedFilterList
                      .toString()
                      .replaceAll("[", '')
                      .replaceAll("]", '')
                      .isNotEmpty) {
                    context.read<HomeBloc>().add(GetNewsBySourceFilter(
                        selectedFilterList
                            .toString()
                            .replaceAll("[", '')
                            .replaceAll("]", '')));
                  } else {
                    context
                        .read<HomeBloc>()
                        .add(GetNewsByLocation(selectedLocation.id));
                  }
                },
                child: Text("Apply Filter",
                    style: Styles.regularTextStyle(
                        size: 15, color: ColorConstants.white)),
              ),
            )
          ],
        );
      },
    );
  }

  showLocationOption(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Column(
          children: [
            Expanded(
                child: ListView.builder(
                    itemCount: locationList.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      var item = locationList[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 19.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item.name,
                                  style: Styles.regularTextStyle(
                                      size: 15, color: ColorConstants.black)),
                              CustomRadioButton(
                                index: index,
                                selectedItem: item.selectedItem!,
                                isClicked: (pos) {
                                  Navigator.pop(context);
                                  for (var element in locationList) {
                                    element.selectedItem = -1;
                                  }
                                  item.selectedItem = pos;
                                  context.read<HomeBloc>().add(GetChangeLocation(item.name));

                                  context.read<HomeBloc>().add(GetNewsByLocation(item.id,isCountryChange: true));
                                },
                              )
                            ],
                          ));
                    })),
          ],
        );
      },
    );
  }
}

class _LocationText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous.textChange != current.textChange,
      builder: (context, state) {
        return Text(state.textChange.toString(),
            style: Styles.mediumTextStyle(
                size: 12, color: ColorConstants.white));
      },
    );
  }
}

// Center(
//   child: Column(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Builder(
//         builder: (context) {
//           final user = context.select((AuthenticationBloc bloc) => bloc.state.user);
//           return Text('User is : ${user.name}');
//         },
//       ),
//       ElevatedButton(
//         child: const Text('Logout'),
//         onPressed: () {
//           context
//               .read<AuthenticationBloc>()
//               .add(AuthenticationLogoutRequested());
//         },
//       )
//     ],
//   ),
// ),
