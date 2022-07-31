import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class _Portal {
  late String title;
  late String link;

  _Portal(this.title, this.link);
}

class PortalView extends StatefulWidget {
  const PortalView({Key? key}) : super(key: key);

  @override
  _PortalState createState() => _PortalState();
}

class _PortalState extends State<PortalView> {
  bool refreshExceptionStuatus = false;
  bool refreshStatus = false;

  @override
  void initState() {
    super.initState();
  }

  void clear() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<_Portal> list = [
      _Portal("白白胖胖", "https://www.zhihu.com/people/long-fang-57"),
      _Portal("磊哥", "无，上微信号吧"),
      _Portal("洪颢", "https://twitter.com/HAOHONG_CFA"),
      _Portal("youtrack", "https://nillouise.youtrack.cloud/dashboard"),
    ];

    return ScaffoldPage.scrollable(
        header: const PageHeader(title: Text('Portal')),
        children: [
          Column(children: [
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(list.length, (index) {
                return TappableListTile(
                  title: Text('${list[index].title}'),
                  onTap: () {
                    if (list[index].link.startsWith("http")) {
                      launchUrl(Uri.parse(list[index].link));
                    }
                  },
                );
              }),
            )
          ])
        ]);
  }
}
