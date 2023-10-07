import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:drop_zone/drop_zone.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:novastrid/common/ui/widgets/app_icon_button.dart';
import 'package:novastrid/common/ui/widgets/app_image_button.dart';
import 'package:novastrid/common/ui/widgets/app_text_field.dart';
import 'package:novastrid/utils/app_colors.dart';
import 'package:novastrid/utils/assets.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _descriptionTextController =
      TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Document"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 10,
            ),
            _getTitle("Description"),
            const SizedBox(
              height: 10,
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 1,
                          ),
                        ),
                      ),
                      child: _buildTextFormatterSection(),
                    ),
                  ),
                  AppTextField(
                    controller: _descriptionTextController,
                    maxLines: 6,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _getTitle("Content Upload*"),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: () {
                debugPrint("Tapped");
              },
              child: DropZone(
                onDragEnter: () {
                  debugPrint("on Drag Enter");
                },
                onDrop: (p0) {
                  debugPrint("onDrop ${p0?.first.name}");
                },
                child: DottedBorder(
                  strokeWidth: 1.5,
                  color: Colors.grey,
                  radius: const Radius.circular(10),
                  borderType: BorderType.RRect,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.color5f8fe,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.upload_file_outlined,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            getPlatformBasedUploadDocText(),
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getPlatformBasedUploadDocText() {
    if (kIsWeb) {
      return "Drop your document here, or click to browse";
    }
    return "Click to Browse";
  }

  Wrap _buildTextFormatterSection() {
    return Wrap(
      runAlignment: WrapAlignment.start,
      runSpacing: 10,
      children: [
        // AppTextButton(onPresed: () {}, text: "B"),
        AppImageButton(
          imagePath: Assets.bold,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.italic,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.underline,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.strikeThrough,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.alignLeft,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.alighCenter,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.alignRight,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.numberedList,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.bulletedList,
          onPresed: () {},
        ),
        AppImageButton(
          imagePath: Assets.textColor,
          onPresed: () {},
        ),
        AppIconButton(
          icon: Icons.format_color_fill_outlined,
          onPresed: () {},
        ),
      ],
    );
  }

  Text _getTitle(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
    );
  }
}
