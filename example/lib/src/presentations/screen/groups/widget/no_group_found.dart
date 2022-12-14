import 'package:flutter/cupertino.dart';

import '../../../../config/text_style.dart';

class NoGroupFound extends StatelessWidget {
  const NoGroupFound({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                CupertinoIcons.nosign,
                size: 30,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "Không có nhóm nào được thêm",
                style: TextStyles.defaultStyle.bold.blueTextColor,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
