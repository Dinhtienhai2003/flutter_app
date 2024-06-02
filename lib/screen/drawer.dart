import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/task.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lịch sử thao tác"),
        actions: [
          IconButton(
            color: Colors.red,
            iconSize: 30,
            icon: Icon(Icons.delete),
            onPressed: () {
              context.read<TaskProvider>().ClearLog();
            },
          ),
        ],
      ),
      body: Center(
        child: Consumer<TaskProvider>(builder: (context, taskprovider, child) {
          return Column(
            children: <Widget>[
              SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: taskprovider.GetLogs().length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(taskprovider.GetLogs()[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
