/*
 * Copyright (C) 2022 Canonical Ltd
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 3 as
 * published by the Free Software Foundation.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:software/l10n/l10n.dart';
import 'package:software/app/common/app_format.dart';
import 'package:yaru_widgets/yaru_widgets.dart';

import 'constants.dart';

class AppFormatPopup extends StatelessWidget {
  const AppFormatPopup({
    super.key,
    required this.onSelected,
    required this.appFormat,
    required this.enabledAppFormats,
    this.badgedAppFormats,
  });

  final void Function(AppFormat appFormat) onSelected;
  final AppFormat appFormat;
  final Set<AppFormat> enabledAppFormats;
  final Map<AppFormat, int>? badgedAppFormats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    var isButtonBadged = false;
    if (badgedAppFormats != null) {
      for (var entry in badgedAppFormats!.entries) {
        if (entry.key != appFormat && entry.value > 0) {
          isButtonBadged = true;
          break;
        }
      }
    }

    Widget maybeBuildItemBadge({
      required AppFormat appFormat,
      required Widget child,
    }) {
      final value = badgedAppFormats?[appFormat];

      if (value == null || value <= 0) {
        return child;
      }

      return badges.Badge(
        animationDuration: Duration.zero,
        badgeContent: Text(
          value.toString(),
          style: badgeTextStyle,
        ),
        position: badges.BadgePosition.topEnd(top: -2, end: -30),
        badgeColor: theme.primaryColor,
        alignment: AlignmentDirectional.centerEnd,
        child: child,
      );
    }

    return badges.Badge(
      position: badges.BadgePosition.topEnd(top: -3, end: -3),
      badgeColor: theme.primaryColor,
      showBadge: isButtonBadged,
      child: YaruPopupMenuButton(
        initialValue: appFormat,
        tooltip: context.l10n.appFormat,
        itemBuilder: (v) => [
          for (var appFormat in enabledAppFormats)
            PopupMenuItem(
              value: appFormat,
              onTap: () => onSelected(appFormat),
              child: maybeBuildItemBadge(
                appFormat: appFormat,
                child: Text(
                  appFormat.localize(context.l10n),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            )
        ],
        onSelected: onSelected,
        child: Text(appFormat.localize(context.l10n)),
      ),
    );
  }
}

class MultiAppFormatPopup extends StatelessWidget {
  const MultiAppFormatPopup({
    super.key,
    required this.selectedAppFormats,
    required this.enabledAppFormats,
    required this.onTap,
  });

  final Set<AppFormat> selectedAppFormats;
  final Set<AppFormat> enabledAppFormats;
  final Function(AppFormat appFormat) onTap;

  @override
  Widget build(BuildContext context) {
    return YaruPopupMenuButton<AppFormat>(
      tooltip: context.l10n.appFormat,
      onSelected: (v) => onTap(v),
      itemBuilder: (context) {
        return [
          for (final appFormat in enabledAppFormats)
            YaruCheckedPopupMenuItem<AppFormat>(
              padding: EdgeInsets.zero,
              value: appFormat,
              checked: selectedAppFormats.contains(appFormat),
              child: Text(
                appFormat.localize(context.l10n),
              ),
            ),
        ];
      },
      child: Text(
        selectedAppFormats.length == AppFormat.values.length
            ? context.l10n.allPackageTypes
            : selectedAppFormats.first.localize(context.l10n),
      ),
    );
  }
}
