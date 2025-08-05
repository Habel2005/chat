import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';


class Chatbubble extends StatelessWidget {
  final String message;
  final bool color;
  final Alignment align;
  const Chatbubble({super.key,required this.message,required this.color, required this.align});

  @override
  Widget build(BuildContext context) {

   return ChatBubble(
      clipper: ChatBubbleClipper5(type: (color == true)?BubbleType.sendBubble:BubbleType.receiverBubble),
      margin: const EdgeInsets.all(6.5),
      alignment: align,
      backGroundColor: (color == true)? const Color.fromARGB(255, 12, 100, 172) : const Color.fromARGB(255, 204, 204, 204),
      child:Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: (color == true)?Colors.white:Colors.black,
          ),
        ),
    );
  }

  
}