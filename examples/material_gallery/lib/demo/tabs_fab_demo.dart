// Copyright 2015 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class _Page {
  _Page({ this.label, this.colors, this.icon });

  final String label;
  final Map<int, Color> colors;
  final IconData icon;

  TabLabel get tabLabel => new TabLabel(text: label.toUpperCase());
  Color get labelColor => colors != null ? colors[300] : Colors.grey[300];
  bool get fabDefined => colors != null && icon != null;
  Color get fabColor => colors[400];
  Icon get fabIcon => new Icon(icon: icon);
  Key get fabKey => new ValueKey<Color>(fabColor);
}

const String _explanatoryText =
  "When the Scaffold's floating action button changes, the new button fades and "
  "turns into view. In this demo, changing tabs can cause the app to be rebuilt "
  "with a FloatingActionButton that the Scaffold distinguishes from the others "
  "by its key.";

class TabsFabDemo extends StatefulComponent {
  _TabsFabDemoState createState() => new _TabsFabDemoState();
}

class _TabsFabDemoState extends State<TabsFabDemo> {
  final GlobalKey scaffoldKey = new GlobalKey();
  final List<_Page> pages = <_Page>[
    new _Page(label: 'Blue', colors: Colors.indigo, icon: Icons.add),
    new _Page(label: 'Too', colors: Colors.indigo, icon: Icons.add),
    new _Page(label: 'Eco', colors: Colors.green, icon: Icons.create),
    new _Page(label: 'No'),
    new _Page(label: 'Teal', colors: Colors.teal, icon: Icons.add),
    new _Page(label: 'Red', colors: Colors.red, icon: Icons.create),
  ];
  _Page selectedPage;

  void initState() {
    super.initState();
    selectedPage = pages[0];
  }

  void _handleTabSelection(_Page page) {
    setState(() {
      selectedPage = page;
    });
  }

  void _showExplanatoryText() {
    scaffoldKey.currentState.showBottomSheet((BuildContext context) {
      return new Container(
        decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: Theme.of(context).dividerColor))
        ),
        child: new Padding(
          padding: const EdgeDims.all(32.0),
          child: new Text(_explanatoryText, style: Theme.of(context).text.subhead)
        )
      );
    });
  }

  Widget buildTabView(_Page page) {
    return new Builder(
      builder: (BuildContext context) {
        final TextStyle textStyle = new TextStyle(
          color: page.labelColor,
          fontSize: 32.0,
          textAlign: TextAlign.center
        );

        return new Container(
          key: new ValueKey<String>(page.label),
          padding: const EdgeDims.TRBL(48.0, 48.0, 96.0, 48.0),
          child: new Card(
            child: new Center(
              child: new Text(page.label, style: textStyle)
            )
          )
        );
      }
    );
  }

  Widget build(BuildContext context) {
    return new TabBarSelection<_Page>(
      values: pages,
      onChanged: _handleTabSelection,
      child: new Scaffold(
        key: scaffoldKey,
        toolBar: new ToolBar(
          center: new Text("FAB per Tab"),
          tabBar: new TabBar<_Page>(
            labels: new Map.fromIterable(pages, value: (_Page page) => page.tabLabel)
          )
        ),
        floatingActionButton: !selectedPage.fabDefined ? null : new FloatingActionButton(
          key: selectedPage.fabKey,
          tooltip: 'Show explanation',
          backgroundColor: selectedPage.fabColor,
          child: selectedPage.fabIcon,
          onPressed: _showExplanatoryText
        ),
        body: new TabBarView(children: pages.map(buildTabView).toList())
      )
    );
  }
}
