import 'package:boxy/flex.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tmdb_easy/easyTMDB.dart';




void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Filmler'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int counter = 0;
  String title = "boş";
  String resim =
      "http://image.tmdb.org/t/p/original/z8CExJekGrEThbpMXAmCFvvgoJR.jpg";
  String arama = "army-of-the-dead";
  TextEditingController _textEditingController = TextEditingController();
 //var voteAverage = 6;
  String date;
  List<MovieCreditsCrew> crew = [];
  int result =0;

  @override
  void initState() {

    getApi();
    super.initState();
  }

  void getBilgi() {
    setState(() {
      arama = _textEditingController.text;
      getApi();
    });
  }

  Future<void> getApi() async {
    EasyTMDB easyTMDB = EasyTMDB("3e686e74e5e0f398e44ca39de2c68c1d");

   await easyTMDB
        .search()
        .movie(
            "https://api.themoviedb.org/3/search/movie?api_key=3e686e74e5e0f398e44ca39de2c68c1d&query=$arama")
        .then((value) {
      setState(() {
        result = value.results.length;

        title = value.toJson()["results"][counter]["original_title"];
        resim = value.toJson()["results"][counter]["poster_path"];
       // voteAverage = value.toJson()["results"][counter]["vote_average"];
        date = value.toJson()["results"][counter]["release_date"];
      });
    });


  }

 void oncekiBilgi(){
    setState(()  {
     if(counter>0){
       counter--;
       getApi();
     }

    });
  }

  void sonrakiBilgi() {
    setState(()   {
    if(result>counter+1){
      counter++;
      getApi();
    }


    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: buildBoxyColumn(width, height),
        ),

      ),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: getBilgi,
        child: Icon(Icons.add),
      ),
    );
  }

  BoxyColumn buildBoxyColumn(double width, double height) {
    return BoxyColumn(
      children: [
        Dominant(
            child: Image.network(
          resim,
          width: width * .8,
          height: height * .6,
        )),
        Center(
          child: Text(
            "$title",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Center(
          child: Text(
            "Puanı",
            style: TextStyle(fontSize: 20),
          ),
        ),
        Center(
          child: Text(
            "$date",
            style: TextStyle(fontSize: 20),
          ),
        ),
        textField(textEditingController: _textEditingController),
        Row(mainAxisAlignment: MainAxisAlignment.center,children: [
          IconButton(iconSize: 60,icon: Icon(Icons.arrow_left),onPressed: oncekiBilgi,),
          Text("${counter + 1}"),
          IconButton(iconSize: 60,icon: Icon(Icons.arrow_right),onPressed: sonrakiBilgi,),

        ],),
        Text("$result"),
      ],
    );

  }


}

class textField extends StatelessWidget {
  const textField({
    Key key,
    @required TextEditingController textEditingController,
  })  : _textEditingController = textEditingController,
        super(key: key);

  final TextEditingController _textEditingController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(

      cursorColor: Colors.white,
      decoration: InputDecoration(

        hintText: "Film Adı Giriniz",
        border: OutlineInputBorder(

          borderSide: new BorderSide(
            width: 1.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
      ),
      controller: _textEditingController,
    );
  }
}
