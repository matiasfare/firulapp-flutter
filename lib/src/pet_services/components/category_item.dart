import 'package:firulapp/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../size_config.dart';

class CategoryItem extends StatelessWidget {
  final String id;
  final String title;
  final String icon;

  CategoryItem(this.id, this.title, this.icon);

  void _categorySelected() {
    print("Seleccionó $title");
  }

  @override
  Widget build(BuildContext context) {
    final SizeConfig sizeConfig = SizeConfig();
    return Column(
      children: [
        RawMaterialButton(
          onPressed: () => _categorySelected(),
          fillColor: Constants.kPrimaryLightColor,
          child: SvgPicture.asset(
            icon,
            color: Constants.kPrimaryColor,
            width: 50,
            fit: BoxFit.cover,
          ),
          elevation: 0.5,
          padding: EdgeInsets.all(sizeConfig.dp(3)),
          shape: CircleBorder(),
        ),
        Text(
          title,
          style: TextStyle(
            fontSize: sizeConfig.dp(1.7),
          ),
        )
      ],
    );
  }
}
