//This file is for viewing the list of the favorites of the user
import 'package:faytour/Widgets/UpBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class FAV extends StatefulWidget {
  const FAV({Key? key}) : super(key: key);
 
  @override 
  State<FAV> createState() => _FAVState();
} 

class _FAVState extends State<FAV> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('Favourite').where("Email",isEqualTo: user.email).snapshots(),
      builder: ((context, snapshot) {
        return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : (snapshot.data!.docs.isEmpty)
                ?Center(child: Text("Nothing Yet",style: GoogleFonts.pressStart2p(fontSize: 25,color: Theme.of(context).colorScheme.primary),),)
                :ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index){
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              if(snapshot.data?.docs[index]["type"] == "area")
                              {
                              Navigator.push(context,MaterialPageRoute(builder: ((context) => BAR(ro: snapshot.data?.docs[index]["Fav"],index: 0,img: snapshot.data?.docs[index]["image"]))));
                              }
                              else
                              {
                                Navigator.push(context,MaterialPageRoute(builder: ((context) => BAR(ro: snapshot.data?.docs[index]["Fav"],index: 1,img: snapshot.data?.docs[index]["image"]))));
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onTertiary,
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  spreadRadius: 1,
                                  blurRadius: 3, 
                                  //offset: Offset(4,4),
                                ),]
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  height: 100,
                                  width: 100,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(7),
                                  child: Image(image: NetworkImage(snapshot.data?.docs[index]["image"]),fit: BoxFit.fill,))
                                
                                ),
                                title: (snapshot.data?.docs[index]["type"] == "area") ? Text(snapshot.data?.docs[index]["Fav"],style: GoogleFonts.merriweather(color: Colors.black,),) : Text(snapshot.data?.docs[index]["Fav"]+" Hotel",style: GoogleFonts.merriweather(color: Colors.black,),),
                                trailing: IconButton(onPressed: () async {
                                  DocumentReference documentReference = FirebaseFirestore.instance.collection('Favourite').doc(snapshot.data?.docs[index].id);
                                  await documentReference.delete();                                  
                                },
                                icon: const Icon(Icons.cancel,color: Colors.black,),
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                      
                    },
        );
      }),
    );
  }
}
