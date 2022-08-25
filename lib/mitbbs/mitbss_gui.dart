import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:magan/mitbbs/fetch_data.dart';
import 'package:magan/mitbbs/mitbbs_backend.dart';
import 'package:url_launcher/url_launcher.dart';

class MitbbsView extends StatefulWidget {
  const MitbbsView({Key? key}) : super(key: key);

  @override
  _MitbbsState createState() => _MitbbsState();
}

class _MitbbsState extends State<MitbbsView> {
  bool refreshExceptionStuatus = false;
  bool refreshStatus = false;

  @override
  void initState() {
    super.initState();
    _controller =
        TextEditingController(text: MitbbsBackend().mitbbsConfig?.proxyHost);
  }

  void clear() async {
    setState(() {
      MitbbsBackend().clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refresh() async {
    try {
      setState(() {
        refreshStatus = true;
      });
      List<Tiezi> cur = await MitbbsBackend().refreshNewData();
      setState(() {
        refreshStatus = false;
        refreshExceptionStuatus = false;
      });
    } catch (x) {
      setState(() {
        refreshStatus = false;
        refreshExceptionStuatus = true;
      });
    }
  }

  final _clearController = TextEditingController();
  TextEditingController? _controller;

  @override
  Widget build(BuildContext context) {
    // tiezis = [Tiezi()..author = "test"..link="l"..title="ok",Tiezi()..author = "test"..link="l"..title="ok"  ];
    return MaterialApp(
      title: 'Mitbbs',
      home: Row(
        children: [
          TextButton(
              child: const Text('Refresh'),
              onPressed: () async {
                refresh();
              }),
          const SizedBox(width: 10.0),
          TextButton(
              child: const Text('Clear'),
              onPressed: () async {
                clear();
              }),
          const SizedBox(width: 10.0),
          Text(MitbbsBackend().refreshTime == null
              ? "have no refresh"
              : DateFormat('MM-dd – kk:mm')
              .format(MitbbsBackend().refreshTime!)),
          const SizedBox(width: 10.0),
          if (refreshStatus) const Icon(Icons.downloading),
          if (refreshExceptionStuatus) const Icon(Icons.warning),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(MitbbsBackend().tiezis.length, (index) {
              return ListTile(
                title: Text(
                    '${MitbbsBackend().tiezis[index].author}:${MitbbsBackend()
                        .tiezis[index].title}'),
                onTap: () {
                  launchUrl(Uri.parse(MitbbsBackend().tiezis[index].link));
                },
              );
            }),
          )
        ],
      ),
    );
  }
}
