import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:gauva_driver/common/shimmer_loader.dart';
import 'package:gauva_driver/core/extensions/extensions.dart';
import 'package:gauva_driver/core/theme/color_palette.dart';
import 'package:gauva_driver/core/utils/app_colors.dart';
import 'package:gauva_driver/core/utils/build_network_image.dart';
import 'package:gauva_driver/core/utils/delete_account_dialogue.dart';
import 'package:gauva_driver/core/utils/is_dark_mode.dart';
import 'package:gauva_driver/core/utils/localize.dart';
import 'package:gauva_driver/data/services/local_storage_service.dart';
import 'package:gauva_driver/data/services/navigation_service.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:gauva_driver/presentation/profile/provider/profile_providers.dart';

import '../../../core/routes/app_routes.dart';

import '../../../core/utils/exit_app_dialogue.dart';
import '../../../core/utils/get_version.dart';
import '../../../core/widgets/country_code_bottom_sheet.dart';
import '../../../data/models/user_model/user_model.dart';
import '../../../gen/assets.gen.dart';
import '../provider/select_country_provider.dart';
import '../provider/theme_provider.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  String version = '';

  @override
  void initState() {
    super.initState();
    loadVersion();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(driverDetailsNotifierProvider.notifier).getDriverDetails();
    });
  }

  Future<void> loadVersion() async {
    version = await getVersion();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => SafeArea(
    child: Scaffold(
      backgroundColor: isDarkMode() ? Colors.black : Colors.white,
      body: Column(
        children: [
          Container(height: 8.h, width: double.infinity, color: isDarkMode() ? Colors.black12 : const Color(0xFFF6F7F9)),
          userDetails(context),
          Gap(8.h),
          accountDetails(context, ref: ref, version: version),
        ],
      ),
    ),
  );
}

Future<void> _launchURL(String url) async {
  print('Launching URL: $url');
  final Uri uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    // Handle error silently or show toast if needed, but simple launch is usually reliable
    debugPrint('Could not launch $url');
  }
}

Widget userDetails(BuildContext context) => Padding(
  padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
  child: Column(
    children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          image: DecorationImage(image: Assets.images.walletBackground.provider(), fit: BoxFit.fill),
        ),
        child: Consumer(
          builder: (context, ref, _) {
            final driverDetails = ref
                .watch(driverDetailsNotifierProvider)
                .mapOrNull(success: (data) => data.data.data?.user, error: (error) => null);
            final bool isLoading = ref.watch(driverDetailsNotifierProvider).whenOrNull(loading: () => true) ?? false;

            return isLoading
                ? buildShimmer(
                    height: 160,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(16.r),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(radius: 33.r, backgroundColor: Colors.white),
                        Gap(8.h),
                        const SizedBox(width: double.infinity),
                        const Text('Name', style: TextStyle(color: Colors.white)),
                        const Text('Phone', style: TextStyle(color: Colors.white)),
                        Gap(8.h),
                        Row(
                          children: List.generate(
                            3,
                            (index) => Expanded(
                              child: Container(
                                height: 48.h,
                                margin: index != 2 ? EdgeInsets.only(right: 16.w) : null,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      CircleAvatar(
                        radius: 33.r,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: (driverDetails?.profilePicture != null && driverDetails!.profilePicture!.isNotEmpty)
                              ? CachedNetworkImage(
                                  imageUrl: driverDetails.profilePicture!,
                                  height: 60.h,
                                  width: 60.w,
                                  fit: BoxFit.fill,
                                  errorWidget: (context, url, error) => Container(
                                    height: 60.h,
                                    width: 60.w,
                                    color: ColorPalette.primary50,
                                    alignment: Alignment.center,
                                    child: Text(
                                      (driverDetails.name != null && driverDetails.name!.isNotEmpty)
                                          ? driverDetails.name![0].toUpperCase()
                                          : 'D',
                                      style: TextStyle(
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 60.h,
                                  width: 60.w,
                                  color: ColorPalette.primary50,
                                  alignment: Alignment.center,
                                  child: Text(
                                    (driverDetails?.name != null && driverDetails!.name!.isNotEmpty)
                                        ? driverDetails.name![0].toUpperCase()
                                        : 'D',
                                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                        ),
                      ),
                      Gap(8.h),
                      Text(
                        driverDetails?.name ?? 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMedium?.copyWith(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Gap(4.h),
                      Text(
                        driverDetails?.mobile ?? 'N/A',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: context.bodyMedium?.copyWith(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white60,
                        ),
                      ),
                      Gap(16.h),
                      driverRideStory(context, driverDetails),
                    ],
                  );
          },
        ),
      ),
    ],
  ),
);

Widget driverRideStory(BuildContext context, User? driverDetail) => Row(
  children: [
    rideStory(
      context,
      logo: Assets.images.taxiCab,
      title: localize(context).total_rides,
      amount: (driverDetail?.totalRide ?? 0).toString(),
    ),
    Gap(8.w),
    rideStory(
      context,
      logo: Assets.images.distanceLogo,
      title: localize(context).total_distance,
      amount: '${driverDetail?.totalDistance ?? 0} KM',
    ),
    Gap(8.w),
    rideStory(
      context,
      logo: Assets.images.star,
      title: localize(context).average_rating,
      amountWidget: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          text: (driverDetail?.rating ?? 0).toString(),
          style: context.bodyMedium?.copyWith(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: isDarkMode() ? Colors.white54 : const Color(0xFF24262D),
          ),
          children: [
            TextSpan(
              text: '(${driverDetail?.reviewCount ?? 0})',
              style: context.bodyMedium?.copyWith(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF687387),
              ),
            ),
          ],
        ),
      ),
    ),
  ],
);

Widget rideStory(
  BuildContext context, {
  String? amount,
  Widget? amountWidget,
  required AssetGenImage logo,
  required String title,
}) => Expanded(
  child: Container(
    padding: EdgeInsets.all(8.r),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      color: isDarkMode() ? Colors.black : Colors.white,
      border: isDarkMode() ? Border.all(color: Colors.white) : null,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child:
                  amountWidget ??
                  Text(
                    amount ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: isDarkMode() ? Colors.white54 : const Color(0xFF24262D),
                    ),
                  ),
            ),
            Gap(4.w),
            logo.image(height: 20.h, width: 20.w, fit: BoxFit.fill),
          ],
        ),
        Gap(4.h),
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.bodyMedium?.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.w400,
            color: isDarkMode() ? Colors.white54 : const Color(0xFF24262D),
          ),
        ),
      ],
    ),
  ),
);

Widget accountDetails(BuildContext context, {required WidgetRef ref, String? version}) => Expanded(
  child: SingleChildScrollView(
    child: Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
      child: Column(
        children: [
          accountButton(
            context,
            leading: Assets.images.myProfile.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
            title: localize(context).my_profile,
            onTap: () {
              NavigationService.pushNamed(AppRoutes.profileInfoPage);
            },
          ),
          Gap(8.h),
          // accountButton(
          //   context,
          //   leading: Assets.images.payout.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
          //   title: localize(context).payout_method,
          //   onTap: () {
          //     NavigationService.pushNamed(AppRoutes.payoutMethod);
          //   },
          // ),
          // Gap(8.h),
          // accountButton(
          //   context,
          //   leading: Assets.images.language.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
          //   title: localize(context).language,
          //   trailing: countrySelector(loadAddress: true),
          // ),
          // Gap(8.h),
          accountButton(
            context,
            leading: Assets.images.language.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
            title: localize(context).language,
            trailing: ValueListenableBuilder<String>(
              valueListenable: LocalStorageService().languageNotifier,
              builder: (context, currentLang, child) => DropdownButton<String>(
                value: currentLang,
                underline: const SizedBox(),
                icon: const Icon(Icons.arrow_drop_down),
                items: [
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(
                      'English',
                      style: context.bodyMedium?.copyWith(fontSize: 14.sp, color: AppColors.primary),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'te',
                    child: Text(
                      'Telugu',
                      style: context.bodyMedium?.copyWith(fontSize: 14.sp, color: AppColors.primary),
                    ),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    LocalStorageService().selectLanguage(newValue);
                  }
                },
              ),
            ),
          ),
          // Gap(8.h),
          // accountButton(
          //   context,
          //   leading: Assets.images.theme.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
          //   title: localize(context).theme,
          //   trailing: const ThemeSwitchTile(),
          // ),
          Gap(8.h),
          accountButton(
            context,
            leading: Assets.images.changePassword.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
            title: localize(context).change_password,
            onTap: () => NavigationService.pushNamed(AppRoutes.changePassword),
          ),
          Gap(8.h),
          accountButton(
            context,
            leading: Assets.images.terms.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
            title: localize(context).terms_conditions,
            onTap: () => _launchURL('https://www.gauvaservices.in/terms'),
          ),
          Gap(8.h),
          accountButton(
            context,
            leading: Assets.images.privacy.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
            title: localize(context).privacy_policy,
            onTap: () => _launchURL('https://www.gauvaservices.in/privacy-policy'),
          ),
          Gap(8.h),
          Consumer(
            builder: (context, ref, _) => accountButton(
              context,
              leading: Assets.images.logOut.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
              title: localize(context).log_out,
              onTap: () {
                showExitLogoutDialogue(ref: ref, isLogout: true);
              },
            ),
          ),
          Gap(8.h),
          accountButton(
            context,
            leading: Assets.images.trash.image(height: 24.h, width: 24.w, fit: BoxFit.fill),
            title: localize(context).delete_account,
            onTap: () {
              showDeleteAccountDialog();
            },
          ),
          // Gap(16.h),
          // Text(
          //   version ?? '',
          //   textAlign: TextAlign.center,
          //   style: context.bodyMedium?.copyWith(fontSize: 14.sp, color: AppColors.primary),
          // ),
        ],
      ),
    ),
  ),
);

Widget accountButton(
  BuildContext context, {
  Function()? onTap,
  Widget? leading,
  required String title,
  Widget? trailing,
}) => InkWell(
  onTap: onTap,
  child: Container(
    constraints: BoxConstraints(minHeight: 48.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.r),
      color: isDarkMode() ? Colors.black : const Color(0xFFF6F7F9),
      border: isDarkMode() ? Border.all(color: Colors.white) : null,
    ),
    padding: EdgeInsets.symmetric(horizontal: 12.w),
    // margin: EdgeInsets.only(bottom: 8.h),
    child: Row(
      children: [
        Padding(
          padding: EdgeInsets.only(right: 16.0.w),
          child: leading ?? const SizedBox.shrink(),
        ),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.bodyMedium?.copyWith(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: isDarkMode() ? Colors.white : const Color(0xFF363A44),
            ),
          ),
        ),
        trailing ?? const SizedBox.shrink(),
      ],
    ),
  ),
);

class ThemeSwitchTile extends ConsumerStatefulWidget {
  const ThemeSwitchTile({super.key});

  @override
  ConsumerState<ThemeSwitchTile> createState() => _ThemeSwitchTileState();
}

class _ThemeSwitchTileState extends ConsumerState<ThemeSwitchTile> {
  late bool isDark;

  @override
  void initState() {
    super.initState();
    isDark = isDarkMode();
  }

  void _toggleTheme() {
    setState(() {
      isDark = !isDark;
    });

    ref.read(themeModeProvider.notifier).setTheme(isDark ? ThemeMode.dark : ThemeMode.light);
  }

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: isDark ? Colors.black12 : const Color(0xFFF6F7F9),
      borderRadius: BorderRadius.circular(12.r),
    ),
    child: GestureDetector(
      onTap: _toggleTheme,
      child: Container(
        width: 54.w,
        height: 24.h,
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: isDark ? Colors.black12 : const Color(0xFFEDEEF0),
          border: isDark ? Border.all(color: Colors.white) : null,
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: isDark ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 22.r,
            height: 22.r,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
            ),
            child: Center(
              child: Icon(
                isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
                size: 16.sp,
                color: ColorPalette.primary50,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

Widget countrySelector({bool showDecoration = false, bool loadAddress = false}) => Consumer(
  builder: (BuildContext context, WidgetRef ref, Widget? child) => InkWell(
    onTap: () {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) => CountryCodeBottomSheet(selectCountryCode: false, loadAddress: loadAddress),
      );
    },
    child: Container(
      padding: showDecoration ? EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w) : null,
      decoration: showDecoration
          ? BoxDecoration(
              border: Border.all(color: Colors.white, width: 1.w),
              borderRadius: BorderRadius.circular(8.r),
            )
          : null,
      child: Consumer(
        builder: (context, ref, _) {
          final state = ref.watch(selectedCountry);

          if (state.selectedLang == null) {
            return const SizedBox.shrink();
          }
          return IntrinsicWidth(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildNetworkImage(
                  imageUrl: state.selectedLang?.flag,
                  width: 20.w,
                  height: 20.h,
                  fit: BoxFit.contain,
                  errorIconSize: 20,
                  // filterQuality: FilterQuality.high,
                  // isAntiAlias: true,
                ),
                Gap(8.w),
                Expanded(
                  child: Text(
                    state.selectedLang?.code ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.bodyMedium?.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: showDecoration ? Colors.white : null,
                    ),
                  ),
                ),

                Icon(Icons.keyboard_arrow_down, color: showDecoration ? Colors.white : Colors.black, size: 18.h),
              ],
            ),
          );
        },
      ),
    ),
  ),
);
