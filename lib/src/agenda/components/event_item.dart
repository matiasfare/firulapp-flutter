import 'package:firulapp/provider/pets.dart';
import 'package:flutter/material.dart';

class EventItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final ValueSetter<PetItem> onTap;
  final PetItem pet;

  EventItem({
    this.title,
    this.icon,
    this.onTap,
    this.pet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(pet),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 8,
        child: Container(
          width: 150,
          height: 100,
          margin: EdgeInsets.all(5.0),
          child: Column(
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: false,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15.0,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: icon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
