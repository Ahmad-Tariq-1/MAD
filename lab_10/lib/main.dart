import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scrolling Lists Assignment',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Scrolling Lists'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Card'),
              Tab(text: 'ListView'),
              Tab(text: 'GridView'),
              Tab(text: 'Stack'),
              Tab(text: 'CustomScrollView'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CardTab(),
            ListViewTab(),
            GridViewTab(),
            StackTab(),
            CustomScrollViewTab(),
          ],
        ),
      ),
    );
  }
}

// 1. Card Tab
class CardTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16),
      children: [
        Card(
          elevation: 4,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Simple Card', style: TextStyle(fontSize: 18)),
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 8,
          color: Colors.blue[50],
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Colored Card', style: TextStyle(fontSize: 18)),
          ),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Text('Rounded Card', style: TextStyle(fontSize: 18)),
          ),
        ),
      ],
    );
  }
}

// 2. ListView Tab
class ListViewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.star, color: Colors.amber),
          title: Text('Item ${index + 1}'),
          subtitle: Text('This is item ${index + 1}'),
          trailing: Icon(Icons.arrow_forward),
        );
      },
    );
  }
}

// 3. GridView Tab
class GridViewTab extends StatelessWidget {
  final List<IconData> icons = [
    Icons.home,
    Icons.work,
    Icons.school,
    Icons.favorite,
    Icons.star,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: icons.length,
      itemBuilder: (context, index) {
        return Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icons[index], size: 40, color: Colors.blue),
              SizedBox(height: 8),
              Text('Item ${index + 1}'),
            ],
          ),
        );
      },
    );
  }
}

// 4. Stack Tab
class StackTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          color: Colors.blue[100],
        ),
        // Center content
        Center(
          child: Container(
            width: 200,
            height: 100,
            color: Colors.white,
            child: Center(child: Text('Center Box')),
          ),
        ),
        // Top left
        Positioned(
          top: 20,
          left: 20,
          child: Icon(Icons.star, size: 40, color: Colors.amber),
        ),
        // Bottom right
        Positioned(
          bottom: 20,
          right: 20,
          child: Icon(Icons.favorite, size: 40, color: Colors.red),
        ),
      ],
    );
  }
}

// 5. CustomScrollView Tab
class CustomScrollViewTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 150,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Custom Scroll View'),
            background: Container(color: Colors.blue),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                ),
                title: Text('List Item ${index + 1}'),
                subtitle: Text('Sliver list example'),
              );
            },
            childCount: 5,
          ),
        ),
      ],
    );
  }
}