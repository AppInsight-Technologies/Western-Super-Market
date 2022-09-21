

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:velocity_x/velocity_x.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../generated/l10n.dart';
import '../models/VxModels/VxStore.dart';
import '../models/newmodle/subscription_data.dart';
import '../models/newmodle/user.dart';
import '../rought_genrator.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/SliderShimmer.dart';
import '../widgets/bottom_navigation.dart';
import '../widgets/header.dart';

class SubscribeDescription extends StatefulWidget{
  String index ="";
  SubscribeDescription(Map<String, String> params){
    this.index = params["index"]??"";
  }
  @override
  _SubscribeDescriptionState createState() => _SubscribeDescriptionState();

}

class _SubscribeDescriptionState extends State<SubscribeDescription> with Navigations {
  bool _isWeb =false;
  bool iphonex = false;
  bool loading =true;
  String address = "";
  String itemImage = "";
  String boxDescreiption = "";
  String subscriptiontype = "";
  String boxName = "";
  String itemid = "";
  late UserData addressdata;
  String Customername = "";
  bool checkaddress = false;
  late Future<List<Subscription>> _subscription = Future.value([]);
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      //  productBoxSub = Hive.box<Subscription>(productBoxNameSub);
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery
                .of(context)
                .size
                .height >= 812.0;
          });
        } else {
          setState(() {
            _isWeb = false;
          });
        }
      } catch (e) {
        setState(() {
          _isWeb = true;
        });
      }
      subscriptionApibox.getSubsctiptionBox(ParamBodyDatabox(type: "all",
          branch: PrefUtils.prefs!.getString("branch"),
          languageid: IConstants.languageId,
          user: !(PrefUtils.prefs!.containsKey("apikey")) ? PrefUtils.prefs!
              .getString("tokenid") ! : PrefUtils.prefs!.getString('apikey')!,subscription_type: "Flexible"),
      )
          .then((value) {
        setState(() {
          _subscription = Future.value(value);
        });
        _subscription.then((value) {
          itemImage = value[int.parse(widget.index)].featuredImage!;
          boxDescreiption =
          value[int.parse(widget.index)].subscriptionboxDescription!;
          subscriptiontype =  value[int.parse(widget.index)].subscriptionType!;
          boxName = value[int.parse(widget.index)].boxName!;
          itemid = value[int.parse(widget.index)].id!;
          addressdata = (VxState.store as GroceStore).userData;
          if (addressdata.billingAddress!.length <= 0) {
            setState(() {
              checkaddress = true;
              print("jwehdgb" + checkaddress.toString());
              loading = false;
            });
          } else {
            setState(() {
              address = addressdata.billingAddress![0].address.toString();
              Customername = addressdata.billingAddress![0].fullName.toString();
              debugPrint("address..." + address + " " + Customername);
              loading = false;
            });
          }
        });
      });
      super.initState();
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    bottomNavigationbar() {
      String channel = "";
      try {
        if (Platform.isIOS) {
          channel = "IOS";
        } else {
          channel = "Android";
        }
      } catch (e) {
        channel = "Web";
      }
      return  loading /*&& loader*/?
      BottomNaviagation(
        itemCount: "0",
        title: S .current.subscribe,
        total: "0",
        onPressed: (){
          setState(() {

          });
        },
      ):
      BottomNaviagation(
        itemCount: "0",
        title: S .current.subscribe,
        total: "0",
        onPressed: (){
          setState(() {

            if(address == ""){
              Fluttertoast.showToast(msg: S .current.please_add_delivery_address);
            }else{
              Navigation(context,
                  name: Routename.SubscribeScreen,
                  navigatore: NavigatoreTyp.Push,
                  qparms: {
                    "itemid": itemid,
                    "index": widget.index,
                    //"items": promoData[i].boxProducts,
                    "fromScreen": "home",
                    "addressid": "",
                    "useraddtype": "",
                    "startDate": "",
                    "endDate": "",
                    "itemCount": "",
                    "deliveries": "",
                    "total": "",
                    "schedule": "",
                    "itemimg": "",
                    "itemname": "",
                    "varprice": "",
                    "varname": "",
                    "address": "",
                    "paymentMode": "",
                    "cronTime": "",
                    "name": "",
                    "varid": "",
                    "varmrp": "",
                    "brand": "",
                    "deliveriesarray": "",
                    "daily": "",
                    "dailyDays": "",
                    "weekend": "",
                    "weekendDays": "",
                    "weekday": "",
                    "weekdayDays": "",
                    "custom": "",
                    "customDays": "",
                    "subscriptionType" : subscriptiontype,
                  });
            }
          });
        },
      );
    }


    gradientappbarmobile() {
      return  AppBar(
        brightness: Brightness.dark,
        toolbarHeight: 60.0,

        elevation: (IConstants.isEnterprise)?0:1,
        automaticallyImplyLeading: false,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: ColorCodes.iconColor),
            onPressed: () async {
              // Navigator.of(context).popUntil(ModalRoute.withName(HomeScreen.routeName,));
              Navigation(context, navigatore: NavigatoreTyp.homenav);
              // Navigator.of(context).pop();
              return Future.value(false);
            }
        ),
        titleSpacing: 0,
        title: Text(boxName,
          style: TextStyle(color: ColorCodes.iconColor,fontWeight: FontWeight.bold),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    ColorCodes.appbarColor,
                    ColorCodes.appbarColor2
                  ]
              )
          ),
        ),
      );
    }


    return WillPopScope(
      onWillPop: (){
        Navigation(context, navigatore: NavigatoreTyp.homenav);
        // Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold (
        appBar: ResponsiveLayout.isSmallScreen(context) ?
        gradientappbarmobile() : null,
        backgroundColor:  ColorCodes.whiteColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            Flexible(child: DescriptionBox()),

          ],
        ),
        bottomNavigationBar:(_isWeb && !ResponsiveLayout.isSmallScreen(context))?SizedBox.shrink(): bottomNavigationbar(),
      ),
    );


  }
  DescriptionBox(){
    return Container(
      padding: EdgeInsets.only(left: 15, right: 15, top: 5, bottom:5),
      width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                  imageUrl: itemImage,
                  placeholder: (context, url) {
                    return SliderShimmer().sliderShimmer(context, height: 220);
                  },
                  errorWidget: (context, url, error) => Image.asset(Images.defaultSliderImg),
                  fit: BoxFit.fitWidth),
              SizedBox(height: 10,),
              Text(/*boxName + " " + */S.of(context).description/*"Description"*/, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18,),),
              SizedBox(height: 6,),
              Text(boxDescreiption, style: TextStyle(fontSize: 14,),),
            ],
          ),
        ),
    );
  }
}


