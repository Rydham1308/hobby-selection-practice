import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:practical/modules/all_list/model/hobbies_model.dart';

import '../../../constants/app_colors.dart';

class SelectedHobbyScreen extends StatefulWidget {
  const SelectedHobbyScreen({super.key});

  @override
  State<SelectedHobbyScreen> createState() => _SelectedHobbyScreenState();
}

class _SelectedHobbyScreenState extends State<SelectedHobbyScreen> {
  List<HobbyList> selectedList = [];
  List<HobbyList> finalSelectedList = [];
  bool isAvail = false;

  @override
  void didChangeDependencies() {
    final getList = ModalRoute.of(context)?.settings.arguments;
    if (getList is List<HobbyList>) {
      selectedList = getList;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBlue,
      appBar: AppBar(
        clipBehavior: Clip.none,
        iconTheme: const IconThemeData(color: Colors.white),
        systemOverlayStyle: const SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.transparent,
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        title: const Text(
          'Selected Category',
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
      body: Stack(
        // clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(0),
              bottomLeft: Radius.circular(0),
            ),
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: EdgeInsets.zero,
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 2 / 3,
                        crossAxisCount: 4, // number of items in each row
                        mainAxisSpacing: 25.0, // spacing between rows
                        crossAxisSpacing: 8.0, // spacing between columns
                      ),
                      itemCount: selectedList.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            for (int i = 0; i < finalSelectedList.length; i++) {
                              if (finalSelectedList[i] == selectedList[index]) {
                                isAvail = true;
                                break;
                              }
                            }

                            if (finalSelectedList.length < 5 && !isAvail) {
                              setState(() {
                                finalSelectedList.add(selectedList[index]);
                              });
                            } else {
                              if (isAvail) {
                                finalSelectedList.removeWhere(
                                  (element) => element == selectedList[index],
                                );
                                isAvail = false;
                                setState(() {});
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
                                decoration: !finalSelectedList.contains(selectedList[index])
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
                                  child: SvgPicture.asset(selectedList[index].url),
                                ),
                              ),
                              Text(
                                selectedList[index].hobby,
                                softWrap: true,
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(0),
                bottomLeft: Radius.circular(0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(1),
                  spreadRadius: 5,
                  blurRadius: 30,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.maxFinite,
                  height: 60,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: finalSelectedList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 5.0, right: 10),
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 57,
                              width: 57,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: Colors.grey.shade200,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: SvgPicture.asset(
                                  finalSelectedList[index].url,
                                ),
                              ),
                            ),
                            Positioned(
                              top: -20,
                              right: -20,
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    finalSelectedList.removeAt(index);
                                    isAvail = false;
                                  });
                                },
                                icon: const Icon(
                                  Icons.cancel_rounded,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 41.0, right: 41, bottom: 10, top: 31),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.blue,
                        elevation: 0,
                        shape: const StadiumBorder(),
                        minimumSize: const Size(250, 50)),
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
              ],
            ),
          ),
        ],
      ),
      // bottomNavigationBar:
    );
  }
}
