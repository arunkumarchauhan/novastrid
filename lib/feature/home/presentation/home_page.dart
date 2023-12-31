import 'dart:io';

import 'package:desktop_drop/desktop_drop.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:novastrid/common/ui/widgets/app_icon_button.dart';
import 'package:novastrid/common/ui/widgets/app_image_button.dart';
import 'package:novastrid/common/ui/widgets/app_swich.dart';
import 'package:novastrid/common/ui/widgets/app_text_button.dart';
import 'package:novastrid/common/ui/widgets/app_text_field.dart';
import 'package:novastrid/feature/home/bloc/home_bloc/home_bloc.dart';
import 'package:novastrid/feature/home/bloc/text_description_bloc/bloc/text_description_bloc.dart';
import 'package:novastrid/utils/app_colors.dart';
import 'package:novastrid/utils/assets.dart';
import 'package:novastrid/utils/extensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _descriptionTextController =
      TextEditingController();
  late HomeBloc _homeBloc;
  late TextDescriptionBloc _textDescriptionBloc;
  Text? currentText;
  @override
  void initState() {
    super.initState();
    _textDescriptionBloc = BlocProvider.of<TextDescriptionBloc>(context);
    _homeBloc = BlocProvider.of<HomeBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const SizedBox.shrink(),
        title: const Text("Upload Document"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
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
                    BlocBuilder<TextDescriptionBloc, TextDescriptionState>(
                      builder: (context, state) {
                        if (state is ChangeTextDescriptionStyleState) {
                          currentText = state.text;
                        }

                        return AppTextField(
                          controller: _descriptionTextController,
                          maxLines: 6,
                          textStyle: currentText?.style,
                          textAlign: currentText?.textAlign,
                        );
                      },
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
                      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
                      _homeBloc.add(PickFileEvent());
                    },
                    child: DropTarget(
                      onDragDone: (details) {
                        ScaffoldMessenger.of(context)
                            .hideCurrentMaterialBanner();
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
      ),
    );
  }

  void _showColorPickerDialogue(
      TextDescriptionState state,
      BuildContext context,
      Function(Color color) onColorChanged,
      Color defaultColor,
      Color? selectedColor) {
    showDialog(
      context: context,
      builder: (context) {
        return AboutDialog(
          children: [
            ColorPicker(
              pickerColor: selectedColor ?? defaultColor,
              onColorChanged: (value) {
                onColorChanged(value);
              },
            ),
          ],
        );
      },
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

  Widget _buildTextFormatterSection() {
    return BlocBuilder<TextDescriptionBloc, TextDescriptionState>(
      builder: (context, state) {
        if (state is ChangeTextDescriptionStyleState) {
          currentText = state.text;
        }
        return Wrap(
          runAlignment: WrapAlignment.start,
          runSpacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // AppTextButton(onPresed: () {}, text: "B"),
            AppImageButton(
              imagePath: Assets.bold,
              backgroundColor:
                  (currentText?.style?.fontWeight == FontWeight.bold).color,
              onPresed: () {
                _textDescriptionBloc.add(
                  ChangeTextStyleEvent(
                    text: currentText?.copyWith(
                        textStyle: currentText?.style?.copyWith(
                      fontWeight:
                          currentText?.style?.fontWeight == FontWeight.bold
                              ? FontWeight.normal
                              : FontWeight.bold,
                    )),
                  ),
                );
              },
            ),
            AppImageButton(
              backgroundColor:
                  (currentText?.style?.fontStyle == FontStyle.italic).color,
              imagePath: Assets.italic,
              onPresed: () {
                _textDescriptionBloc.add(
                  ChangeTextStyleEvent(
                    text: currentText?.copyWith(
                        textStyle: currentText?.style?.copyWith(
                      fontStyle:
                          currentText?.style?.fontStyle == FontStyle.italic
                              ? FontStyle.normal
                              : FontStyle.italic,
                    )),
                  ),
                );
              },
            ),
            AppImageButton(
              backgroundColor:
                  (currentText?.style?.decoration == TextDecoration.underline)
                      .color,
              imagePath: Assets.underline,
              onPresed: () {
                _textDescriptionBloc.add(
                  ChangeTextStyleEvent(
                    text: currentText?.copyWith(
                        textStyle: currentText?.style?.copyWith(
                      decoration: (currentText?.style?.decoration ==
                              TextDecoration.underline)
                          ? TextDecoration.none
                          : TextDecoration.underline,
                    )),
                  ),
                );
              },
            ),
            AppImageButton(
              backgroundColor:
                  (currentText?.style?.decoration == TextDecoration.lineThrough)
                      .color,
              imagePath: Assets.strikeThrough,
              onPresed: () {
                _textDescriptionBloc.add(
                  ChangeTextStyleEvent(
                    text: currentText?.copyWith(
                        textStyle: currentText?.style?.copyWith(
                      decoration: (currentText?.style?.decoration ==
                              TextDecoration.lineThrough)
                          ? TextDecoration.none
                          : TextDecoration.lineThrough,
                    )),
                  ),
                );
              },
            ),
            AppImageButton(
              backgroundColor:
                  (currentText?.textAlign?.index == TextAlign.left.index).color,
              imagePath: Assets.alignLeft,
              onPresed: () {
                _textDescriptionBloc.add(
                  ChangeTextStyleEvent(
                    text: currentText?.copyWith(
                        tTextAlign: (currentText?.textAlign?.index ==
                                TextAlign.left.index)
                            ? TextAlign.center
                            : TextAlign.left),
                  ),
                );
              },
            ),
            AppImageButton(
              backgroundColor:
                  (currentText?.textAlign == TextAlign.center).color,
              imagePath: Assets.alighCenter,
              onPresed: () {
                _textDescriptionBloc.add(
                  ChangeTextStyleEvent(
                    text: currentText?.copyWith(
                        tTextAlign: (currentText?.textAlign == TextAlign.center)
                            ? TextAlign.left
                            : TextAlign.center),
                  ),
                );
              },
            ),
            AppImageButton(
              backgroundColor:
                  (currentText?.textAlign == TextAlign.right).color,
              imagePath: Assets.alignRight,
              onPresed: () {
                _textDescriptionBloc.add(
                  ChangeTextStyleEvent(
                    text: currentText?.copyWith(
                        tTextAlign: (currentText?.textAlign == TextAlign.right)
                            ? TextAlign.left
                            : TextAlign.right),
                  ),
                );
              },
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: Colors.black,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppIconButton(
                      height: 30,
                      onPresed: () {
                        double fontSize =
                            ((currentText?.style?.fontSize ?? 14) + 1);
                        _textDescriptionBloc.add(
                          ChangeTextStyleEvent(
                            text: currentText?.copyWith(
                              textStyle: currentText?.style?.copyWith(
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icons.keyboard_arrow_up_outlined),
                  Text(
                    "${currentText?.style?.fontSize ?? 14}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  AppIconButton(
                      height: 30,
                      onPresed: () {
                        double fontSize =
                            (currentText?.style?.fontSize ?? 14) - 1;
                        if (fontSize <= 0) {
                          fontSize = 1;
                        }

                        _textDescriptionBloc.add(
                          ChangeTextStyleEvent(
                            text: currentText?.copyWith(
                              textStyle: currentText?.style?.copyWith(
                                fontSize: fontSize,
                              ),
                            ),
                          ),
                        );
                      },
                      icon: Icons.keyboard_arrow_down_outlined),
                ],
              ),
            ),

            AppImageButton(
              onPresed: () {},
              imagePath: Assets.numberedList,
            ),

            AppImageButton(
              onPresed: () {},
              imagePath: Assets.bulletedList,
            ),

            AppIconButton(
              iconColor: currentText?.style?.color,
              onPresed: () {
                _showColorPickerDialogue(state, context, (value) {
                  _textDescriptionBloc.add(
                    ChangeTextStyleEvent(
                      text: currentText?.copyWith(
                          textStyle:
                              currentText?.style?.copyWith(color: value)),
                    ),
                  );
                }, Colors.black, currentText?.style?.color);
              },
              icon: Icons.format_color_text_outlined,
            ),

            AppIconButton(
              iconColor: currentText?.style?.color,
              backgroundColor: currentText?.style?.backgroundColor,
              icon: Icons.format_color_fill_outlined,
              onPresed: () {
                _showColorPickerDialogue(state, context, (value) {
                  _textDescriptionBloc.add(
                    ChangeTextStyleEvent(
                      text: currentText?.copyWith(
                          textStyle: currentText?.style
                              ?.copyWith(backgroundColor: value)),
                    ),
                  );
                }, Colors.black, currentText?.style?.color);
              },
            ),
          ],
        );
      },
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
