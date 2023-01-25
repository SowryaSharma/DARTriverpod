import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:riverpodtut/model.dart';
import 'dart:convert';
final helloWorldProvider = Provider((ref) => ref.watch(GreetProvider));
final provider3 = Provider<String>((ref) {
  return "provider3";
});
void main() {
  runApp(
    ProviderScope(child: MyApp())
  );
  // runApp(const MyApp());
}
class newApp extends ConsumerWidget {
  const newApp({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final string = ref.watch(helloWorldProvider);
    return Container(
      child: Text("string"),
    );
  }
}
// Extend ConsumerWidget instead of StatelessWidget, which is exposed by Riverpod
//changeMainWidgethere bookmark:change
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String value = ref.watch(helloWorldProvider);

    return MaterialApp(
      home: widget1(),
      // home: Scaffold(
      //   appBar: AppBar(title: const Text('Example')),
      //   body: Center(
      //     child: api(),
      //   ),
      // ),
    );
  }
}
final GreetProvider = Provider<String>((ref) {
  return "new string";
});

class consumerStateful extends ConsumerStatefulWidget {
  const consumerStateful({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _consumerStatefulState();
}
class counterwidget extends ConsumerWidget {
  const counterwidget({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var value = ref.watch(counterprovider);
    void returnnewvalue(){
      ref.read(counterprovider.notifier).state++;
    }
  final periodicTimer = Timer.periodic(
  const Duration(seconds: 3),
  (timer) {
    returnnewvalue();
  },
);
    return Container(
      child: ElevatedButton(child: Text('$value'),onPressed: () => {
        print(ref.watch(counterprovider)),
        periodicTimer,
      },),
    );
  }
}
class _consumerStatefulState extends ConsumerState<consumerStateful> {

  @override
  Widget build(BuildContext context) {
    var i = ref.watch(provider3);
    return Container(
      child: counterwidget(),
    );
  }
}
final counterprovider = StateProvider<int>((ref) {
  return 0;
});




//...3timer classes



//timer code testf

class counterTimer extends StatefulWidget {
  const counterTimer({super.key});

  @override
  State<counterTimer> createState() => _counterTimerState();
}

class _counterTimerState extends State<counterTimer> {
  Timer? _timer;
  int _start = 20;
  void startTimer(){
    _timer = Timer.periodic(Duration(seconds: 1),(Timer timer) {
      if(_start == 0){
        setState(() {
          _timer?.cancel();
          _start = 20;
        });
      }

    setState(() {
      _start--;
      print(_start);
    });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  void dispose() {
  _timer?.cancel();
  super.dispose();
}

  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("$_start")
      ],
    );
  }
}


//...4countertimerwithriverpod

 final _starttiming = StateProvider<int>((ref) {
  return 20;
});

class countertimerriverpod extends ConsumerStatefulWidget {
  const countertimerriverpod({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _countertimerriverpodState();
}

class _countertimerriverpodState extends ConsumerState<countertimerriverpod> {
  Timer? timer;
void startTimer(){
  timer = Timer.periodic(Duration(seconds: ref.watch(_starttiming)),(Timer timer) {
    ref.read(_starttiming.notifier).state--;
  });
}
  @override
  void initState() {
    super.initState();
    // startTimer();
  }
  Widget build(BuildContext context) {
    final time = ref.watch(_starttiming);
    return Column(
      children: [
        GestureDetector(
          child: Text("Start timer"),
          onTap: () => {
            startTimer()
          },
        ),
        Text("$time")
      ],
    );
  }
}

//...5Futureprovider

final configProvider = FutureProvider<String>((ref) async {
  final content = await rootBundle.loadString('assets/vertopal.com_person.json');
  print(content);
  return content;
});

class configfutureproviderwidget extends ConsumerStatefulWidget {
  const configfutureproviderwidget({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _configfutureproviderwidgetState();
}

class _configfutureproviderwidgetState extends ConsumerState<configfutureproviderwidget> {
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(configProvider);
    return Column(
      children: [
        Text("$data")
      ],
    );
  }
}


//...6statenotifierprovider
final stnotiProvider = StateNotifierProvider((ref) {
  return stateNotifier();
});

 class stateNotifier extends StateNotifier<List<String>> {
  stateNotifier(): super(["initial","array"]);
  void addString(String stringtoadd){
    state = [...state,stringtoadd];
  }
}

class Statenotifierproviderwid extends ConsumerStatefulWidget {
  const Statenotifierproviderwid({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _StatenotifierproviderwidState();
}

class _StatenotifierproviderwidState extends ConsumerState<Statenotifierproviderwid> {
  @override
  void initState() {
    super.initState();
  }
  Widget build(BuildContext context) {
    final listOfString = ref.watch(stnotiProvider) as List;
    return Column(
      children: [
        ...listOfString.map((e) => Text(e)),
        GestureDetector(
          child: Text("Add random string"),
          onTap: ()=>{
            ref
            .read(stnotiProvider.notifier)
            .addString("stringtoadd")
          },

        )
      ],
    );
  }
}

//...2reading riverpod providers
/* 
ref.read()    ->   read value of provider at that instant
ref.listen()  ->   listen to the provider change used to show alert when something changes like that
ref.watch()   ->   returns value everytime value changes
*/


// ...1multiple providers
final apidataProvider = FutureProvider<String>((ref) {
  final obj = ref.watch(ApiProvider);
  var title = obj;
  print(title);
  return "";
});



final ApiProvider = FutureProvider<List<String>>((ref) async {
    var url = "https://jsonplaceholder.typicode.com/todos/1";
    var response = await http.get(Uri.parse(url));
    print(" response.body = ${response.body}");
    var obj = dataModel.fromJson(jsonDecode(response.body));
  return [obj.title,obj.Id.toString()];
});

class api extends ConsumerStatefulWidget {
  const api({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _apiState();
}

class _apiState extends ConsumerState<api> {

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(ApiProvider);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("$data")
      ],
    );
  }
}

//passing data between widgets and pushnamed


class widget1 extends StatefulWidget {
  const widget1({super.key});

  @override
  State<widget1> createState() => _widget1State();
}

class _widget1State extends State<widget1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Widget1"),
        leading: GestureDetector(
          child: Icon(
          Icons.menu
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return widge2();
          }));
        },
        ),
      ),
    );
  }
}

class widge2 extends StatefulWidget {
  const widge2({super.key});

  @override
  State<widge2> createState() => _widge2State();
}

class _widge2State extends State<widge2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: (){
          Navigator.pop(context);
        }),
      ),
      body: Container(),
    );
  }
}