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

import 'package:flutter/material.dart';
import 'package:software/app/common/constants.dart';
import 'package:software/l10n/l10n.dart';
import 'package:yaru_icons/yaru_icons.dart';

class PublisherName extends StatelessWidget {
  const PublisherName({
    super.key,
    this.verified = false,
    required this.publisherName,
    this.starDev = false,
    required this.website,
    this.limitChildWidth = true,
    this.height = 14,
    this.enhanceChildText = false,
    required this.onPublisherSearch,
  });

  final bool verified;
  final bool starDev;
  final String publisherName;
  final String website;
  final bool limitChildWidth;
  final double height;
  final bool enhanceChildText;
  final void Function()? onPublisherSearch;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final light = theme.brightness == Brightness.light;
    var child = Text(
      publisherName,
      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontSize: height,
            fontStyle: enhanceChildText ? FontStyle.italic : FontStyle.normal,
            color: enhanceChildText
                ? theme.colorScheme.onSurface.withOpacity(0.7)
                : null,
          ),
      overflow: TextOverflow.ellipsis,
    );
    return InkWell(
      onTap: onPublisherSearch,
      child: SizedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (limitChildWidth)
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 80),
                child: child,
              )
            else
              child,
            if (verified)
              Padding(
                padding: EdgeInsets.only(left: height * 0.2),
                child: Tooltip(
                  message: context.l10n.verified,
                  child: Icon(
                    Icons.verified,
                    color: light ? kGreenLight : kGreenDark,
                    size: height * 0.85,
                  ),
                ),
              )
            else if (starDev)
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: _StarDeveloper(
                  height: height * 0.85,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StarDeveloper extends StatelessWidget {
  const _StarDeveloper({
    required this.height,
  });

  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: kStarDevColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Tooltip(
          message: context.l10n.starDeveloper,
          child: Icon(
            YaruIcons.star_filled,
            color: Colors.white,
            size: height,
          ),
        ),
      ),
    );
  }
}
