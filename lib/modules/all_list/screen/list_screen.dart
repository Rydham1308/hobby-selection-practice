import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practical/constants/app_colors.dart';
import 'package:practical/constants/status.dart';
import 'package:practical/modules/all_list/bloc/all_hobbies_bloc.dart';
import 'package:practical/modules/all_list/model/hobbies_model.dart';
import 'package:practical/modules/all_list/repository/all_hobbies_repository.dart';
import 'package:practical/modules/selected_list/screen/selected_hobby_screen.dart';

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
  int hobbyItemIndex = 0;
  int hobbyCount = 0;

  List<HobbyList> selectedList = [];
  List<List<bool>> isSelected = [];

  void toggleSelection(int listIndex, int containerIndex) {
    setState(() {
      isSelected[listIndex][containerIndex] = !isSelected[listIndex][containerIndex];
    });
  }

  bool validateSelection(int listIndex) {
    int count = isSelected[listIndex].where((element) => element).length;
    return count >= 2 && count <= 5;
  }

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
            listener: (context, state) {
              if (state is HobbiesListState && state.status == Status.isSuccess){
                isSelected = List.generate(
                    state.listAllHobbies?.length ?? 0,
                        (index) =>
                        List.generate(20, (index) => false));
              }
            },
            builder: (context, state) {
              if (state is HobbiesListState && state.status == Status.isSuccess) {
                hobbyCount = state.listAllHobbies?.length ?? 0;
                return ListView(
                  padding: EdgeInsets.zero,
                  clipBehavior: Clip.none,
                  children: [
                    ListView.builder(
                      key: Key(hobbyIndex.toString()),
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      clipBehavior: Clip.none,
                      itemCount: state.listAllHobbies?.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: AppColors.cardBack,
                          ),
                          child: ExpansionTile(
                            trailing: Container(
                              height: 24,
                              width: 24,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(1),
                                    spreadRadius: -1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                CupertinoIcons.chevron_down,
                                size: 14,
                              ),
                            ),
                            key: Key(index.toString()),
                            initiallyExpanded: index == hobbyIndex,
                            shape: const StadiumBorder(),
                            title: Padding(
                              padding:
                                  const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                              child: Text(
                                state.listAllHobbies?[index].hobbyName ?? '',
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                              ),
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
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
                                color: Colors.white,
                                child: GridView.builder(
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
                                        int count = isSelected[hobbyIndex]
                                            .where((element) => element)
                                            .length;
                                        hobbyItemIndex = index;
                                        if (count <= 4) {
                                          toggleSelection(hobbyIndex, hobbyItemIndex);
                                        } else {
                                          if (isSelected[hobbyIndex][index]) {
                                            toggleSelection(hobbyIndex, hobbyItemIndex);
                                          } else {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(
                                                backgroundColor: Color(0xd52d2d2d),
                                                content: Text(
                                                  'Max Length Reached!!',
                                                  style: TextStyle(color: Colors.white),
                                                ),
                                                duration: Duration(milliseconds: 1000),
                                              ),
                                            );
                                          }
                                        }
                                      },
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 57,
                                            width: 57,
                                            decoration: !isSelected[hobbyIndex][index]
                                                ? BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: Colors.white,
                                                    border: Border.all(color: Colors.grey))
                                                : BoxDecoration(
                                                    borderRadius: BorderRadius.circular(6),
                                                    color: Colors.grey.shade200,
                                                    border: Border.all(color: Colors.black)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(10.0),
                                              child: SvgPicture.asset(state
                                                      .listAllHobbies?[hobbyIndex]
                                                      .hobbyList[index]
                                                      .url ??
                                                  ''),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(top: 3.0),
                                            child: Text(
                                              state.listAllHobbies?[hobbyIndex].hobbyList[index]
                                                      .hobby ??
                                                  '',
                                              style: const TextStyle(fontSize: 12),
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 41.0, right: 41, bottom: 10),
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton(
                          onPressed: () {
                            // Validate on button press
                            bool isValid = true;
                            for (int i = 0; i < isSelected.length; i++) {
                              if (!validateSelection(i)) {
                                isValid = false;
                                break;
                              }
                            }
                            if (isValid) {
                              for (int i = 0; i < (state.listAllHobbies?.length ?? 0); i++) {
                                for (int j = 0;
                                    j < (state.listAllHobbies?[i].hobbyList.length ?? 0);
                                    j++) {
                                  if (isSelected[i][j]) {
                                    selectedList.add(state.listAllHobbies?[i].hobbyList[j] ??
                                        HobbyList(hobby: '', url: ''));
                                  }
                                }
                              }
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SelectedHobbyScreen(),
                                    settings: RouteSettings(arguments: selectedList),
                                  )).then((value) => selectedList.clear());
                            } else {
                              // Show validation error
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Validation Error'),
                                    content: const Text(
                                        'Each expandable list item should have between 2 and 5 containers selected.'),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.blue,
                            elevation: 0,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            "Next",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: Colors.white,
                            ),
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
