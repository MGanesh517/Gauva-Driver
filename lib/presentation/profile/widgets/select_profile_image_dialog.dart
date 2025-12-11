import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ionicons/ionicons.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/core/widgets/buttons/app_primary_button.dart';

import '../../../../core/theme/animation_duration.dart';
import '../../../../core/widgets/responsive_dialog/app_responsive_dialog.dart';
import '../../../core/widgets/upload_image_field.dart';
import '../provider/profile_providers.dart';
import 'preset_avatar_item.dart';

class SelectProfileImageDialog extends StatefulWidget {
  const SelectProfileImageDialog({super.key});

  @override
  State<SelectProfileImageDialog> createState() => _SelectProfileImageDialogState();
}

class _SelectProfileImageDialogState extends State<SelectProfileImageDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isSaving = false;

  @override
  Widget build(BuildContext context) => AppResponsiveDialog(
    type: context.responsive(DialogType.bottomSheet, xl: DialogType.dialog),
    header: (Ionicons.person_circle, localize(context).select_profile_image, null),
    primaryButton: Consumer(
      builder: (context, ref, _) {
        final selectedAvatar = ref.watch(selectedAvatarProvider);
        final profilePhotoUploadState = ref.watch(profilePhotoUploadNotifierProvider);
        final profilePhotoNotifier = ref.read(profilePhotoUploadNotifierProvider.notifier);
        final bool isLoading = profilePhotoUploadState.whenOrNull(loading: () => true) ?? false;
        return AnimatedSwitcher(
          duration: AnimationDuration.pageStateTransitionMobile,
          child: AppPrimaryButton(
            isLoading: isLoading,
            isDisabled: isLoading,
            onPressed: () async {
              if (selectedAvatar.value2 != null) {
                String imagePath = selectedAvatar.value2!;
                if (selectedAvatar.value1 != null) {
                  imagePath = await profilePhotoNotifier.getImagePathFromLocalAsset(imagePath: selectedAvatar.value2!);
                } else {
                  imagePath = selectedAvatar.value2!;
                }
                profilePhotoNotifier.updateProfilePhoto(imagePath: imagePath);
              }
            },
            child: Text(localize(context).save),
          ),
        );
      },
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Consumer(
          builder: (context, ref, _) {
            ref.watch(selectedAvatarProvider);
            final notifier = ref.read(selectedAvatarProvider.notifier);
            return UploadImageField(
              onImageSelected: (File media) {
                notifier
                  ..reset()
                  ..selectRemoteAvatar(path: media.path);
              },
              title: localize(context).upload_image,
            );
          },
        ),
        const SizedBox(height: 16),
        Text(localize(context).or_select_avatar, style: context.titleSmall),
        const SizedBox(height: 16),
        SizedBox(
          height: 160,
          child: Consumer(
            builder: (context, ref, _) {
              final selectedAvatar = ref.watch(selectedAvatarProvider);
              final notifier = ref.read(selectedAvatarProvider.notifier);
              return SingleChildScrollView(
                child: Wrap(
                  children: [
                    for (var i = 1; i <= 30; i++)
                      PresetAvatarItem(
                        index: i,
                        onPressed: (value) => notifier.selectLocalAvater(index: value.value1, path: value.value2),
                        selectedIndex: selectedAvatar.value1,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}
