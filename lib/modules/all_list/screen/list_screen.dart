import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practical/constants/app_colors.dart';
import 'package:practical/constants/lists.dart';
import 'package:practical/constants/status.dart';
import 'package:practical/modules/all_list/bloc/all_hobbies_bloc.dart';
import 'package:practical/modules/all_list/model/hobbies_model.dart';
import 'package:practical/modules/all_list/repository/all_hobbies_repository.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  static Widget create() {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) {
            return GetHobbies();
          },
        ),
        BlocProvider(
          create: (BuildContext context) => AllHobbiesBloc(
            allHobbiesRepo: context.read<GetHobbies>(),
          )..add(GetAllHobbiesEvent()),
        ),
      ],
      child: const ListScreen(),
    );
  }

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  int hobbyIndex = 0;
  ValueNotifier<List<AllHobbiesModel>> selectedList = ValueNotifier([]);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        title: const Text(
          'Select Category',
          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[
                AppColors.darkBlue,
                AppColors.lightBlue,
              ],
            ),
          ),
        ),
      ),
      body: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
        child: Container(
          color: Colors.white,
          child: BlocConsumer<AllHobbiesBloc, AllHobbiesState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is HobbiesListState && state.status == Status.isSuccess) {
                return ListView(
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.none,
                  children: [
                    ValueListenableBuilder(
                      key: Key(hobbyIndex.toString()),
                      valueListenable: selectedList,
                      builder: (context, value, child) {
                        return ListView.builder(
                          physics: const ScrollPhysics(),
                          shrinkWrap: true,
                          clipBehavior: Clip.none,
                          itemCount: state.listAllHobbies?.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(top: 26, bottom: 26, left: 20, right: 20),
                              margin: const EdgeInsets.only(bottom: 10),
                              decoration: BoxDecoration(
                                color: AppColors.cardBack,
                              ),
                              child: ExpansionTile(
                                key: Key(index.toString()),
                                initiallyExpanded: index == hobbyIndex,
                                shape: const StadiumBorder(),
                                title: Text(
                                  state.listAllHobbies?[index].hobbyName ?? '',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                ),
                                onExpansionChanged: ((newState) {
                                  if (newState) {
                                    setState(() {
                                      hobbyIndex = index;
                                    });
                                  } else {
                                    setState(() {
                                      hobbyIndex = -1;
                                    });
                                  }
                                }),
                                children: <Widget>[
                                  GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: 2 / 4,
                                      crossAxisCount: 5, // number of items in each row
                                      mainAxisSpacing: 25.0, // spacing between rows
                                      crossAxisSpacing: 8.0, // spacing between columns
                                    ),
                                    itemCount: state.listAllHobbies?[index].hobbyList.length,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {

                                        },
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            Container(
                                              height: 57,
                                              width: 57,
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(6),
                                                  color: Colors.white,
                                                  border: Border.all(color: Colors.grey)
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(10.0),
                                                child: SvgPicture.asset(
                                                    'assets/icons/Arts Crafts/PaintingDrawing.svg'),
                                              ),
                                            ),
                                            Text(
                                              state.listAllHobbies?[hobbyIndex].hobbyList[index].hobby ?? '',
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 41.0,right: 41,bottom: 10),
                      child: ElevatedButton(
                        onPressed: (){},
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.blue,
                          elevation: 0,
                          shape: const StadiumBorder(),
                        ),
                        child: const Text(
                          "Next",
                          style: TextStyle(
                            fontFamily: "Raleway",
                            fontWeight: FontWeight.w900,
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
