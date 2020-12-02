void main() {
//  testList();
testParse(24);
}

void testParse(var num) {
  String rate = (num is double)? num.toStringAsFixed(1) : num.toString();
  print(rate);
}

void testList() {
  List<String> mylist = ['a', 'b', 'c',];
  Map<String,String> mymap = Map();

  mymap = Map.fromIterable(mylist,key: (element) => element, value: (element) => getMapValue(element));
  print(mymap);
}

int counter = 0;

getMapValue(String response) {
  counter++;
  return response+counter.toString();
}