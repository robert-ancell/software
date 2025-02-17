import 'package:flutter/material.dart';
import 'package:software/app/common/app_data.dart';
import 'package:software/app/common/app_page/app_infos/install_date_info_fragment.dart';
import 'package:software/app/common/app_page/app_infos/license_info_fragment.dart';
import 'package:software/app/common/app_page/app_infos/links_info_fragment.dart';
import 'package:software/app/common/app_page/app_infos/publisher_info_fragment.dart';
import 'package:software/app/common/app_page/app_infos/released_at_info_fragment.dart';
import 'package:software/l10n/l10n.dart';
import 'package:yaru_widgets/yaru_widgets.dart';
import '../../expandable_title.dart';

const headerStyle = TextStyle(fontWeight: FontWeight.w500, fontSize: 14);

class AdditionalInformation extends StatelessWidget {
  const AdditionalInformation({
    super.key,
    required this.appData,
  });

  final AppData appData;

  @override
  Widget build(BuildContext context) {
    return YaruExpandable(
      isExpanded: true,
      header: ExpandableContainerTitle(
        context.l10n.additionalInformation,
      ),
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            mainAxisExtent: 100,
          ),
          children: [
            PublisherInfoFragment(
              publisherName: appData.publisherName,
              website: appData.website,
              verified: appData.verified,
              starDev: appData.starredDeveloper,
            ),
            ReleasedAtInfoFragment(releasedAt: appData.releasedAt),
            LicenseInfoFragment(
              headerStyle: headerStyle,
              license: appData.license,
            ),
            // TODO: the category is currently not provided
            // by snapd, and thus not by snapd.dart
            // when a snap is found by name
            // See: https://bugs.launchpad.net/snapd/+bug/1838786/comments/5

            // AppInfoFragment(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   header: 'Category',
            //   tooltipMessage: '',
            //   child: Text(context.l10n.unknown),
            // ),
            InstallDateInfoFragment(
              installDateIsoNorm: appData.installDateIsoNorm,
              installDate: appData.installDate,
            ),
            LinksInfoFragment(appData: appData),
          ],
        ),
      ),
    );
  }
}
