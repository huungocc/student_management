import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../managers/manager.dart';

class CustomDialogUtil {
  static Future<T?> showDialogNotification<T>(BuildContext context,
      {Function? onSubmit,
        String? title,
        bool barrierDismissible = true,
        String? image,
        String? content,
        String? titleSubmit}) {
    return showDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        content: content,
        onSubmit: onSubmit,
        titleSubmit: titleSubmit ?? AppLocalizations.of(context)!.ok,
      ),
    );
  }

  static Future<T?> showDialogConfirm<T>(BuildContext context,
      {Function? onCancel,
        Function? onSubmit,
        String? title,
        bool barrierDismissible = true,
        bool autoPopWhenPressSubmit = true,
        String? content,
        String? subContent,
        String? titleCancel,
        bool hideCancel = false,
        String? titleSubmit}) {
    return showDialog<T>(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        content: content,
        autoPopWhenPressSubmit: autoPopWhenPressSubmit,
        titleSubmit: titleSubmit ?? AppLocalizations.of(context)!.ok,
        onSubmit: onSubmit,
        onCancel: onCancel,
        titleCancel: hideCancel ? null : (titleCancel ?? AppLocalizations.of(context)!.cancel),
      ),
    );
  }
}

class OptionItem extends StatelessWidget {
  final double? width, height;
  final double? imageSize;
  final String? imageKey;
  final String? textKey;
  final Function? onTap;

  const OptionItem({
    Key? key,
    this.width,
    this.height,
    this.imageSize,
    this.imageKey,
    this.textKey,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        width: width ?? 300.0,
        height: height ?? 60.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Row(
          children: [
            imageKey == null
                ? Container()
                : Container(
              width: height ?? 60.0,
              height: height ?? 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Image.asset(
                imageKey!,
                width: imageSize ?? 24,
                height: imageSize ?? 24,
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 18),
                height: 21,
                child: textKey == null
                    ? Container()
                    : Text(
                  textKey!,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 12, right: 12),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomDialog extends StatelessWidget {
  final Function? onSubmit;
  final Function? onCancel;
  final String? titleSubmit;
  final Widget? contentWidget;
  final String? content;
  final String? titleCancel;
  final String? title;
  final bool autoPopWhenPressSubmit;
  final BoxDecoration? submitDecoration;
  final BoxDecoration? cancelDecoration;
  final Color? colorSubmitTitle;
  final Color? colorCancelTitle;

  const CustomDialog({
    Key? key,
    this.onSubmit,
    this.titleSubmit,
    this.content,
    this.titleCancel,
    this.title,
    this.contentWidget,
    this.onCancel,
    this.autoPopWhenPressSubmit = true,
    this.cancelDecoration,
    this.submitDecoration,
    this.colorSubmitTitle,
    this.colorCancelTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      insetPadding: const EdgeInsets.only(left: 25, right: 25),
      child: Wrap(
        children: [
          Column(
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: contentWidget ??
                          Column(
                            children: [
                              Text(
                                content ?? '',
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87, fontFamily: Fonts.display_font
                                ),
                              ),
                            ],
                          ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (titleCancel != null && titleCancel!.isNotEmpty)
                          Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(color: Colors.black87),
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                                if (onCancel != null) {
                                  onCancel!();
                                }
                              },
                              child: Text(
                                titleCancel!,
                                style: TextStyle(
                                  color: colorCancelTitle ?? Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        if (titleSubmit != null && titleSubmit!.isNotEmpty)
                          Flexible(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                if (autoPopWhenPressSubmit) {
                                  Navigator.of(context).pop();
                                }
                                if (onSubmit != null) {
                                  onSubmit!();
                                }
                              },
                              child: Text(
                                titleSubmit!,
                                style: TextStyle(
                                  color: colorSubmitTitle ?? Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
