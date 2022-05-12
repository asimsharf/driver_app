import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 230,
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6,
                  spreadRadius: 0.5,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 25,
                top: 50,
                right: 25,
                bottom: 10,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: const Icon(Icons.arrow_back),
                      ),
                      const Center(
                        child: Text(
                          "عنوان الوصول",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/pickicon.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: TextField(
                              controller: controller.txtPick,
                              decoration: InputDecoration(
                                hintText: "عنوان الأقلاع",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                  left: 11,
                                  top: 8,
                                  bottom: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/desticon.png",
                        height: 16,
                        width: 16,
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: TextField(
                              controller: controller.txtDrop,
                              onChanged: (val) {
                                controller.findPlace(val);
                              },
                              decoration: InputDecoration(
                                hintText: "الى أين؟",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: const EdgeInsets.only(
                                  left: 11,
                                  top: 8,
                                  bottom: 8,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Obx(
            () {
              if (controller.placePredictionsList.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: ListView.separated(
                    itemBuilder: (ctx, i) {
                      return InkWell(
                        onTap: () {
                          controller.findPlaceDetails(
                            controller.placePredictionsList[i].placeId!,
                          );
                        },
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                const Icon(Icons.add_location),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.placePredictionsList[i]
                                            .structuredFormatting!.mainText!,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        controller.placePredictionsList[i]
                                            .structuredFormatting!.secondaryText
                                            .toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (ctx, i) => const Divider(),
                    itemCount: controller.placePredictionsList.length,
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ],
      ),
    );
  }
}
