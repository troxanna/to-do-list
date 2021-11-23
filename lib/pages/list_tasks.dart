ListView.builder(
itemCount: todoList.length,
itemBuilder: (BuildContext context, int index) {
return Dismissible(
key: Key(todoList[index]),
child: Card(
child: ListTile(
title: Text(todoList[index]),
trailing: IconButton(
icon: Icon(
Icons.delete_outline,
color: Colors.deepOrangeAccent,
),
onPressed: () {
setState(() {
todoList.removeAt(index);
});
},
),
),
),
onDismissed: (direction) {
//if (direction == DismissDirection.endToStart)
setState(() {
todoList.removeAt(index);
});
},
);
}
)