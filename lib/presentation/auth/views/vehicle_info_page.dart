import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/presentation/auth/provider/auth_providers.dart';
import 'package:gauva_driver/presentation/auth/widgets/auth_app_bar.dart';
import 'package:gauva_driver/presentation/auth/widgets/auth_bottom_buttons.dart';

import '../../../core/utils/is_dark_mode.dart';
import '../../splash/provider/car_info_providers.dart';
import '../widgets/dropdown_date_selector.dart';
import '../widgets/dropdown_from_builder.dart';
import '../widgets/form_text_field.dart';
import '../widgets/image_picker_form_field.dart';

class DriverDocumentsPage extends ConsumerStatefulWidget {
  const DriverDocumentsPage({super.key});

  @override
  ConsumerState<DriverDocumentsPage> createState() => _DocumentUploadPageState();
}

class _DocumentUploadPageState extends ConsumerState<DriverDocumentsPage> {
  final formKey = GlobalKey<FormBuilderState>();

  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController productionYearController = TextEditingController();

  File? drivingLicenseImage;
  File? nidImage;
  File? vehiclePapers;
  int? vehicleType;
  int? vehicleColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchData();
    });
  }

  @override
  void dispose() {
    plateNumberController.dispose();
    productionYearController.dispose();
    super.dispose();
  }

  Future<void> _fetchData() async {
    final colorNotifier = ref.read(carColorNotifierProvider.notifier);
    final modelNotifier = ref.read(carModelNotifierProvider.notifier);

    await Future.wait([colorNotifier.getCarColors(), modelNotifier.getCarModels()]);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: context.surface,
    body: AuthAppBar(
      title: localize(context).driver_documents,
      child: FormBuilder(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localize(context).add_driver_documents,
              style: context.bodyMedium?.copyWith(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: isDarkMode() ? const Color(0xFF687387) : const Color(0xFF24262D),
              ),
            ),
            Gap(8.h),
            Text(
              localize(context).upload_driver_documents,
              style: context.bodyMedium?.copyWith(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF687387),
              ),
            ),
            Gap(24.h),

            textFieldFromBuilderWithTitle(
              context,
              title: localize(context).plate_number,
              name: 'car_plate',
              hintText: localize(context).vehicle_plate_number,
              controller: plateNumberController,
            ),

            DynamicYearDropdownFormField(
              startDate: DateTime(1990),
              endDate: DateTime.now(),
              controller: productionYearController,
              hintText: localize(context).vehicle_production_year,
              title: localize(context).production_year,
            ),

            /// --- Vehicle Model Dropdown ---
            Consumer(
              builder: (context, ref, _) {
                final carModelState = ref.watch(carModelNotifierProvider);
                return dropdownFromBuilderWithTitle<int>(
                  context,
                  title: localize(context).vehicle_type,
                  name: 'car_id',
                  hintText: localize(context).select_vehicle_type,
                  initialValue: vehicleType,
                  onChanged: (v) {
                    if (v != null) {
                      vehicleType = v;
                      setState(() {});
                    }
                  },
                  isLoading: carModelState.whenOrNull(loading: () => true) ?? false,
                  items: carModelState.maybeWhen(
                    success: (carModelResponse) => carModelResponse.data!
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name ?? '', style: context.labelLarge),
                          ),
                        )
                        .toList(),
                    orElse: () => [],
                  ),
                  validator: FormBuilderValidators.required(),
                );
              },
            ),

            /// --- Vehicle Color Dropdown ---
            Consumer(
              builder: (context, ref, _) {
                final carColorState = ref.watch(carColorNotifierProvider);

                return dropdownFromBuilderWithTitle<int>(
                  context,
                  title: localize(context).vehicle_color,
                  name: 'car_color_id',
                  hintText: localize(context).select_vehicle_color,
                  initialValue: vehicleColor,
                  onChanged: (v) {
                    if (v != null) {
                      vehicleColor = v;
                      setState(() {});
                    }
                  },
                  isLoading: carColorState.when(
                    initial: () => false,
                    loading: () => true,
                    success: (d) => false,
                    error: (e) => false,
                  ),
                  items: carColorState.maybeWhen(
                    success: (carColorResponse) => carColorResponse.data!
                        .map(
                          (e) => DropdownMenuItem(
                            value: e.id,
                            child: Text(e.name ?? '', style: context.labelLarge),
                          ),
                        )
                        .toList(),
                    orElse: () => [],
                  ),
                  validator: FormBuilderValidators.required(),
                );
              },
            ),

            Gap(20.h),

            /// --- Image Picker Fields ---
            imagePickerFormField(
              context: context,
              name: 'nid_image',
              title: localize(context).nid_photo,
              initialFile: nidImage,
              validator: (file) => file == null ? localize(context).nid_image_required : null,
              onChanged: (file) => setState(() => nidImage = file),
            ),
            Gap(16.h),
            imagePickerFormField(
              context: context,
              name: 'driving_license',
              title: localize(context).driving_license,
              initialFile: drivingLicenseImage,
              validator: (file) => file == null ? localize(context).driving_license_required : null,
              onChanged: (file) => setState(() => drivingLicenseImage = file),
            ),
            Gap(16.h),
            imagePickerFormField(
              context: context,
              name: 'vehicle_papers',
              title: localize(context).vehicle_papers,
              initialFile: vehiclePapers,
              validator: (file) => file == null ? localize(context).vehicle_papers_required : null,
              onChanged: (file) => setState(() => vehiclePapers = file),
            ),
            Gap(16.h),
          ],
        ),
      ),
    ),
    bottomNavigationBar: Consumer(
      builder: (context, ref, _) {
        final uploadDocumentsState = ref.watch(updateVehicleDetailsNotifierProvider);
        final uploadDocumentsNotifier = ref.read(updateVehicleDetailsNotifierProvider.notifier);

        return AuthBottomButtons(
          title: localize(context).submit,
          isLoading: uploadDocumentsState.whenOrNull(loading: () => true) ?? false,
          onTap: () async {
            final bool? isValid = formKey.currentState?.validate();
            if (isValid ?? false) {
              await uploadDocumentsNotifier.updateVehicleDetails(
                documents: [nidImage!, drivingLicenseImage!, vehiclePapers!],
                data: {
                  'vehicle_type': vehicleType,
                  'vehicle_color': vehicleColor,
                  'vehicle_plate': plateNumberController.text.trim(),
                  'vehicle_regi_year': productionYearController.text.trim(),
                },
              );
            }
            {}
          },
        );
      },
    ),
  );
}
