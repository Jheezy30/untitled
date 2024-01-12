


import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Model> models = [];
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final dio = Dio();
    final url = 'https://jsonplaceholder.typicode.com/posts';

      try {
        final response = await dio.get(url);
        List<dynamic> items = response.data;
        print(items);

        final newModels = items.map((item) => Model.fromJson(item)).toList();
        setState(() {
          models.addAll(
              newModels); // Set isLoading to false after data is fetched
        });
      }catch(error){
        print('error $error');
    }
  }

  void addModels(int count) async {
    for (int i = 0; i < count; i++) {
      await fetchData();
    }
  }

  Future<void> confirmDelete(int id) async {
    final confirmed = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue[100],
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.of(context).pop(false); // Return false when "No" button is pressed
              },
            ),
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop(true); // Return true when "Yes" button is pressed
              },
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      deleteData(id);
    }
  }


  void deleteData(int id) async{
    setState(() {
      isLoading = true;
    });

    final dio = Dio();
    final url = 'https://jsonplaceholder.typicode.com/posts/$id';
    try{
      final response = await dio.delete(url);


      if (response.statusCode == 200){


        setState(() {
          models.removeWhere((model) {
            return model.id == id;
          });
        });
      }
    }catch(error){
      print('error $error');
    }
     isLoading = false;
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Text('My App'),
        backgroundColor: Colors.blue[400],
        centerTitle: true,
        elevation: 0.0,

      ),
      body: Stack(
        children: [
          models.isEmpty
              ? Center(child: Text('No data available'))
              : ListView.builder(
            itemCount: models.length,
            itemBuilder: (BuildContext context, int index) {
              final model = models[index];
              return ListTile(
                title: Text(model.title ?? ''),
                subtitle: Text('ID: ${model.id}'),
              leading:
                   IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => confirmDelete(model.id),
              ),  // Add more widgets to display other properties of the model
              );
            },
          ),
          if (isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),

          GestureDetector(
            onTap: (){
              print("object");
            },
            child: Material(
              borderRadius: BorderRadius.circular(20),
              elevation: 10,
              shadowColor: Colors.amber.shade900,
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue, Colors.blue.shade700,],
                    begin: Alignment.topCenter
                      ,end:  Alignment.bottomCenter
                  )
                ),
                child: Center(child: Text("TEXT")),
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => addModels(1), // Fetch new data once
        child: Icon(Icons.update),
      ),
    );
  }
}
