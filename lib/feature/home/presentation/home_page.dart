import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:novastrid/common/ui/widgets/app_icon_button.dart';
import 'package:novastrid/common/ui/widgets/app_image_button.dart';
import 'package:novastrid/common/ui/widgets/app_swich.dart';
import 'package:novastrid/common/ui/widgets/app_text_button.dart';
import 'package:novastrid/common/ui/widgets/app_text_field.dart';
import 'package:novastrid/feature/home/bloc/home_bloc.dart';
import 'package:novastrid/utils/app_colors.dart';
import 'package:novastrid/utils/assets.dart';
import 'package:novastrid/utils/file_saver.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _descriptionTextController =
      TextEditingController();
  late HomeBloc _homeBloc;
  @override
  void initState() {
    super.initState();
    _homeBloc = BlocProvider.of<HomeBloc>(context);
  }

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
            BlocConsumer<HomeBloc, HomeState>(
              listener: (context, state) {
                _handleUserNotification(state, context);
              },
              builder: (context, state) {
                return InkWell(
                  onTap: () async {
                    _homeBloc.add(PickFileEvent());
                  },
                  child: DropTarget(
                    onDragDone: (details) {
                      _homeBloc
                          .add(UploadDropFileEvent(droppedDetails: details));
                    },
                    onDragEntered: (details) {
                      debugPrint("onDragEntered $details}");
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
                              if (state is DocUploadInProgressState ||
                                  state is DownloadInProgressState)
                                const CircularProgressIndicator()
                              else if (state is DocUploadSuccessfulState) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        "File : ${state.fileName}",
                                        maxLines: 1,
                                      ),
                                    ),
                                    AppIconButton(
                                      onPresed: () {
                                        _homeBloc.add(ResetHomeBlocEvent());
                                      },
                                      icon: Icons.delete,
                                    )
                                  ],
                                )
                              ] else ...[
                                const Icon(
                                  Icons.upload_file_outlined,
                                  color: Colors.red,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                const Text(
                                  "Drop your document here, or click to browse",
                                  style: TextStyle(
                                    fontSize: 12,
                                  ),
                                )
                              ]
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            const Row(
              children: [
                Text(
                  "Allow user to download content",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                ),
                AppSwitch(initialSwitchValue: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleUserNotification(HomeState state, BuildContext context) {
    if (state is DocUploadSuccessfulState) {
      _showUploadDialogue(context);
    } else if (state is DocUploadFailedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(state.error),
        ),
      );
    } else if (state is DownloadCompletedState) {
      ScaffoldMessenger.of(context).showMaterialBanner(MaterialBanner(
          backgroundColor: Colors.green,
          content: Text(state.message),
          actions: [
            AppTextButton(
              onPresed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              text: "Dismiss",
              textStyle: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            )
          ]));
    } else if (state is DownloadFailedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(state.error),
        ),
      );
    }
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

  Future<void> _showUploadDialogue(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'File Upload Successful',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
            ),
          ),
          content: const Text(
            'Want to download file?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            AppTextButton(
                onPresed: () {
                  _homeBloc.add(DownloadPickedFile(droppedFile: File("")));
                  Navigator.pop(context);
                },
                text: "Yes")
          ],
        );
      },
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
