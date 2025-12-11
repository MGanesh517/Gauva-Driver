import 'package:flutter/material.dart';

import 'color_scheme.dark.dart';
import 'theme.typography.dart';

TextTheme textThemeDark(String fontPrimary, String fontSecondary) =>
    textTheme(fontPrimary, fontSecondary).copyWith(
      titleLarge: textTheme(fontPrimary, fontSecondary).titleLarge?.copyWith(
            color: darkColorScheme.onSurface,
          ),
      headlineSmall:
          textTheme(fontPrimary, fontSecondary).headlineSmall?.copyWith(
                color: darkColorScheme.onSurface,
              ),
    );
