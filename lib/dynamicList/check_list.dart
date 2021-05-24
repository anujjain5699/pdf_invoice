import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:pdf_invoice/dynamicList/item_info.dart';
import 'package:pdf_invoice/dynamicList/items_list.dart';
import 'package:pdf_invoice/dynamicList/shop.dart';
import 'package:pdf_invoice/model/invoice.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';

class CheckList extends StatefulWidget {
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  List<InvoiceItem> _selectedBooks = [];
  double total = 0;

  ListedItem listedItem = ListedItem();

  void _onCategorySelected(bool selected, InvoiceItem item) {
    if (selected == true) {
      setState(
        () {
          _selectedBooks.add(item);
          total += (item.quantity * item.unitPrice);
          if(_selectedBooks.length==0 || total<=0)total=0;
          print("On add ${item.description}");
          print("total : $total");
        },
      );
    } else {
      setState(
        () {
          _selectedBooks.remove(item);
          total -= (item.quantity * item.unitPrice * 1.18);
          if(_selectedBooks.length==0 || total<=0)total=0;
          print("On removed ${item.description}");
          print("total : $total");
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.blueGrey[100],
        shadowColor: Colors.brown[300],
        elevation: 30,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(24),
          ),
        ),
        title: new Text("CheckList", style: TextStyle(fontSize: 24)),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: listedItem.bookslist.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  value: _selectedBooks.contains(listedItem.bookslist[index]),
                  onChanged: (bool selected) {
                    _onCategorySelected(
                      selected,
                      listedItem.bookslist[index],
                    );
                  },
                  controlAffinity: ListTileControlAffinity.trailing,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  activeColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("price : ${listedItem.bookslist[index].unitPrice}",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16)),
                      Text(
                        "qty : ${listedItem.bookslist[index].quantity}",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ],
                  ),
                  title: Row(
                    children: [
                      Text(
                        "${index + 1})  ",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: AutoSizeText(
                          //overflowReplacement:
                          listedItem.bookslist[index].description,
                          maxLines: 2,
                          maxFontSize: 16,
                          minFontSize: 12,
                          softWrap: true,
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          //showBooks(context),
          SwipeButton.expand(
            thumb: Icon(
              Icons.double_arrow_rounded,
              color: Colors.white,
            ),
            child: Text(
              "Swipe to ...",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20
              ),
            ),
            activeThumbColor: Colors.black87,
            activeTrackColor: Colors.purple[200],
            onSwipe: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Shop(_selectedBooks, total),
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget showBooks(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Shop(_selectedBooks, total),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          border: Border.all(color: Colors.red[300], width: 4),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(Icons.keyboard_arrow_right_sharp,
                color: Colors.white, size: 40),
            Icon(Icons.ac_unit, color: Colors.white, size: 40),
            Icon(Icons.keyboard_arrow_left_sharp,
                color: Colors.white, size: 40),
          ],
        ),
      ),
    );
  }
}
