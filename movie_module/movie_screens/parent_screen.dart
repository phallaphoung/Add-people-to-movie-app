import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'people_screen.dart';
import 'nowplaying_screen.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class ParentScreen extends StatefulWidget {
  const ParentScreen({super.key});

  @override
  State<ParentScreen> createState() => _ParentScreenState();
}

class _ParentScreenState extends State<ParentScreen> {
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: [
        PersistentTabConfig(
          screen: NowplayingScreen(),
          item: ItemConfig(
            icon: FaIcon(FontAwesomeIcons.film),
            title: "Now Playing",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: PeopleScreen(),
          item: ItemConfig(
            icon: FaIcon(FontAwesomeIcons.person),
            title: "People",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        /*PersistentTabConfig(
          screen: Container(color: Colors.pink),
          item: ItemConfig(
            icon: FaIcon(FontAwesomeIcons.arrowTrendUp),
            title: "Top Rated",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
        PersistentTabConfig(
          screen: Container(color: Colors.indigo),
          item: ItemConfig(
            icon: FaIcon(FontAwesomeIcons.calendarCheck),
            title: "Upcoming",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),*/
        PersistentTabConfig(
          screen: Container(color: Colors.lime),
          item: ItemConfig(
            icon: FaIcon(FontAwesomeIcons.gear),
            title: "Settings",
            activeForegroundColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
      navBarBuilder: (navBarConfig) => Style3BottomNavBar(
        navBarConfig: navBarConfig,
        navBarDecoration: NavBarDecoration(
          color: Theme.of(context).colorScheme.onInverseSurface,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
      ),
    );
  }
}
