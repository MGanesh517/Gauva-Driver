import 'package:flutter/cupertino.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/build_network_image.dart';

import '../../data/models/country_code.dart';
import 'buttons/app_radio_button.dart';

class AppCountryCodeListItem extends StatelessWidget {
  final CountryCode countryCode;
  final Function(CountryCode countryCode) onPressed;
  final bool isSelected;
  final bool selectCountryCode;

  const AppCountryCodeListItem({
    super.key,
    required this.countryCode,
    required this.onPressed,
    required this.isSelected,
    required this.selectCountryCode,
  });

  @override
  Widget build(BuildContext context) => CupertinoButton(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: buildNetworkImage(
            imageUrl: countryCode.flag,
            width: 24,
            height: 24,
            errorIconSize: 24,
            fit: BoxFit.contain,
            // filterQuality: FilterQuality.high,
            // isAntiAlias: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(countryCode.name ?? '', style: context.labelLarge)),
        selectCountryCode ? Text(countryCode.phoneCode ?? '', style: context.labelSmall) : const SizedBox.shrink(),
        const SizedBox(width: 12),
        AppRadioButton(groupValue: isSelected, value: true, onChanged: (value) => onPressed(countryCode)),
      ],
    ),
    onPressed: () => onPressed(countryCode),
  );
}
