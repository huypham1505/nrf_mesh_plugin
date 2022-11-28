import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/palettes.dart';
import '../../config/text_style.dart';

class NoFoundScreen extends StatelessWidget {
  final bool isScanScreen;
  const NoFoundScreen({Key? key, required this.isScanScreen}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return isScanScreen == false
        ? Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 100,
              ),
              const Icon(
                CupertinoIcons.antenna_radiowaves_left_right,
                size: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Không có thiết bị nào được thêm",
                style: TextStyles.defaultStyle.bold.blueTextColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Thêm một thiết bị bằng cách quét và cấp phép thiết bị",
                style: TextStyles.defaultStyle.italic.light,
              ),
            ],
          )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.bluetooth_rounded,
                color: Palettes.p8,
                size: 50,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Không thể xem thiết bị của bạn?",
                style: TextStyles.defaultStyle.bold.blueTextColor,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "1. Đảm bảo nguồn được bật hoặc phải được kết nối với nguồn điện",
                style: TextStyles.defaultStyle.italic.light,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "2. Phải đảm bảo bạn đang đứng gần thiết bị có liên quan và không được quá xa",
                style: TextStyles.defaultStyle.italic.light,
              ),
            ],
          );
  }
}
