import 'package:flutter/material.dart';

import 'color_card.dart';

/// Draw a number of boxes showing the colors of key sub theme color properties
/// in the ColorScheme of the inherited ThemeData and its color properties.
///
/// This widget is just used so we can visually see the active scheme colors
/// in the examples and their used FlexColorScheme based themes.
///
/// It also show some warning labels when using surface branding that is too
/// strong and makes the surface require reverse contrasted text in relation to
/// text normally associated with the active theme mode.
///
/// These are all Flutter "Universal" Widgets that only depends on the SDK and
/// all the Widgets in this file be dropped into any application. They are
/// however not so generally reusable.
class ShowSubThemeColors extends StatelessWidget {
  const ShowSubThemeColors({Key? key, this.onBackgroundColor})
      : super(key: key);

  /// The color of the background the color widget are being drawn on.
  ///
  /// Some of the theme colors may have semi transparent fill color. To compute
  /// a legible text color for the sum when it shown on a background color, we
  /// need to alpha merge it with background and we need the exact background
  /// color it is drawn on for that. If not passed in from parent, it is
  /// assumed to be drawn on card color, which usually is close enough.
  final Color? onBackgroundColor;

  // Return true if the color is light, meaning it needs dark text for contrast.
  static bool _isLight(final Color color) =>
      ThemeData.estimateBrightnessForColor(color) == Brightness.light;

  // On color used when a theme color property does not have a theme onColor.
  static Color _onColor(final Color color, final Color bg) =>
      _isLight(Color.alphaBlend(color, bg)) ? Colors.black : Colors.white;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = colorScheme.brightness == Brightness.dark;

    // Get effective background color.
    final Color background =
        onBackgroundColor ?? theme.cardTheme.color ?? theme.cardColor;
    // Grab the card border from the theme card shape
    ShapeBorder? border = theme.cardTheme.shape;
    // If we had one, copy in a border side to it.
    if (border is RoundedRectangleBorder) {
      border = border.copyWith(
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      );
      // If
    } else {
      // If border was null, make one matching Card default, but with border
      // side, if it was not null, we leave it as it was.
      border ??= RoundedRectangleBorder(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        side: BorderSide(
          color: theme.dividerColor,
          width: 1,
        ),
      );
    }

    // Get the colors of all shown component theme colors.

    final Color elevatedButtonColor = theme
            .elevatedButtonTheme.style?.backgroundColor
            ?.resolve(<MaterialState>{}) ??
        colorScheme.primary;
    final Color outlinedButtonColor = theme
            .outlinedButtonTheme.style?.foregroundColor
            ?.resolve(<MaterialState>{}) ??
        colorScheme.primary;
    final Color textButtonColor = theme.textButtonTheme.style?.foregroundColor
            ?.resolve(<MaterialState>{}) ??
        colorScheme.primary;
    final Color toggleButtonsColor =
        theme.toggleButtonsTheme.color ?? colorScheme.primary;
    final Color floatingActionButtonColor =
        theme.floatingActionButtonTheme.backgroundColor ??
            colorScheme.secondary;
    final Color switchColor = theme.switchTheme.thumbColor
            ?.resolve(<MaterialState>{MaterialState.selected}) ??
        theme.toggleableActiveColor;
    final Color checkboxColor = theme.checkboxTheme.fillColor
            ?.resolve(<MaterialState>{MaterialState.selected}) ??
        theme.toggleableActiveColor;
    final Color radioColor = theme.radioTheme.fillColor
            ?.resolve(<MaterialState>{MaterialState.selected}) ??
        theme.toggleableActiveColor;
    final Color chipColor =
        theme.chipTheme.backgroundColor ?? colorScheme.primary;

    final Color inputDecoratorColor =
        theme.inputDecorationTheme.focusColor?.withAlpha(0xFF) ??
            colorScheme.primary;

    final Decoration? tooltipDecoration = theme.tooltipTheme.decoration;
    final Color tooltipColor = tooltipDecoration is BoxDecoration
        ? tooltipDecoration.color ?? colorScheme.surface
        : colorScheme.surface;

    final Color appBarColor = theme.appBarTheme.backgroundColor ??
        (isDark ? colorScheme.surface : colorScheme.primary);
    final Color tabBarColor = theme.tabBarTheme.labelColor ??
        (isDark ? colorScheme.onSurface : colorScheme.onPrimary);
    final Color dialogColor =
        theme.dialogTheme.backgroundColor ?? theme.dialogBackgroundColor;

    final Color bottomNavBarColor =
        theme.bottomNavigationBarTheme.backgroundColor ??
            colorScheme.background;
    final Color bottomNavBarItemColor =
        theme.bottomNavigationBarTheme.selectedItemColor ?? colorScheme.primary;
    final Color navigationBarColor =
        theme.navigationBarTheme.backgroundColor ?? colorScheme.background;
    final Color navigationBarItemColor = theme.navigationBarTheme.iconTheme
            ?.resolve(<MaterialState>{MaterialState.selected})?.color ??
        colorScheme.primary;
    final Color navigationBarIndicatorColor =
        theme.navigationBarTheme.indicatorColor ?? colorScheme.primary;
    final Color navigationRailColor =
        theme.navigationRailTheme.backgroundColor ?? colorScheme.background;
    final Color navigationRailItemColor =
        theme.navigationRailTheme.selectedIconTheme?.color ??
            colorScheme.primary;
    final Color navigationRailIndicatorColor =
        theme.navigationRailTheme.indicatorColor ?? colorScheme.primary;

    // Wrap this widget branch in a custom theme where card has a border outline
    // if it did not have one, but retains in ambient themed border radius.
    return Theme(
      data: Theme.of(context).copyWith(
        cardTheme: CardTheme.of(context).copyWith(
          elevation: 0,
          shape: border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Component sub-themes color overview'),
            subtitle: Text("Color settings are controlled in each component's "
                'settings panel. This shows default or selected ColorScheme '
                'based used themed color for each component.'),
          ),
          // A Wrap widget is just the right handy widget for this type of
          // widget to make it responsive.
          Wrap(
            spacing: 6,
            runSpacing: 6,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: <Widget>[
              ColorCard(
                label: 'Elevated\nButton',
                color: elevatedButtonColor,
                textColor: _onColor(elevatedButtonColor, background),
              ),
              ColorCard(
                label: 'Outlined\nButton',
                color: outlinedButtonColor,
                textColor: _onColor(elevatedButtonColor, background),
              ),
              ColorCard(
                label: 'Text\nButton',
                color: textButtonColor,
                textColor: _onColor(textButtonColor, background),
              ),
              ColorCard(
                label: 'Toggle\nButtons',
                color: toggleButtonsColor,
                textColor: _onColor(toggleButtonsColor, background),
              ),
              ColorCard(
                label: 'Switch',
                color: switchColor,
                textColor: _onColor(switchColor, background),
              ),
              ColorCard(
                label: 'Checkbox',
                color: checkboxColor,
                textColor: _onColor(checkboxColor, background),
              ),
              ColorCard(
                label: 'Radio',
                color: radioColor,
                textColor: _onColor(radioColor, background),
              ),
              ColorCard(
                label: 'Floating\nAction\nButton',
                color: floatingActionButtonColor,
                textColor: _onColor(floatingActionButtonColor, background),
              ),
              ColorCard(
                label: 'Chips',
                color: chipColor,
                textColor: _onColor(chipColor, background),
              ),
              ColorCard(
                label: 'Input\nDecorator',
                color: inputDecoratorColor,
                textColor: _onColor(inputDecoratorColor, background),
              ),
              ColorCard(
                label: 'Tooltip',
                color: tooltipColor,
                textColor: _onColor(tooltipColor, background),
              ),
              ColorCard(
                label: 'AppBar',
                color: appBarColor,
                textColor: _onColor(appBarColor, background),
              ),
              ColorCard(
                label: 'TabBar\nitem',
                color: tabBarColor,
                textColor: _onColor(tabBarColor, background),
              ),
              ColorCard(
                label: 'TabBar\nIndicator',
                color: theme.indicatorColor,
                textColor: _onColor(theme.indicatorColor, background),
              ),
              ColorCard(
                label: 'Dialog\nBackground',
                color: dialogColor,
                textColor: _onColor(dialogColor, background),
              ),
              ColorCard(
                label: 'Bottom\nNavigationBar\nbackground',
                color: bottomNavBarColor,
                textColor: _onColor(bottomNavBarColor, background),
              ),
              ColorCard(
                label: 'Bottom\nNavigationBar\nselected',
                color: bottomNavBarItemColor,
                textColor: _onColor(bottomNavBarItemColor, background),
              ),
              ColorCard(
                label: 'Navigation\nBar\nbackground',
                color: navigationBarColor,
                textColor: _onColor(navigationBarColor, background),
              ),
              ColorCard(
                label: 'Navigation\nBar\nselected',
                color: navigationBarItemColor,
                textColor: _onColor(navigationBarItemColor, background),
              ),
              ColorCard(
                label: 'Navigation\nBar\nindicator',
                color: navigationBarIndicatorColor,
                textColor: _onColor(navigationBarIndicatorColor, background),
              ),
              ColorCard(
                label: 'Navigation\nRail\nbackground',
                color: navigationRailColor,
                textColor: _onColor(navigationRailColor, background),
              ),
              ColorCard(
                label: 'Navigation\nRail\nselected',
                color: navigationRailItemColor,
                textColor: _onColor(navigationRailItemColor, background),
              ),
              ColorCard(
                label: 'Navigation\nRail\nindicator',
                color: navigationRailIndicatorColor,
                textColor: _onColor(navigationRailIndicatorColor, background),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
