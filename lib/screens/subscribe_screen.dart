import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../constants/api.dart';
import '../../constants/features.dart';
import '../../models/VxModels/VxStore.dart';
import '../../models/newmodle/user.dart';
import 'package:velocity_x/velocity_x.dart';
import '../models/newmodle/SubscriptionPromoplan.dart';
import '../models/newmodle/cartModle.dart';
import '../rought_genrator.dart';
import '../widgets/address_info.dart';
import '../widgets/bottom_navigation.dart';

import '../assets/ColorCodes.dart';
import '../assets/images.dart';
import '../constants/IConstants.dart';
import '../generated/l10n.dart';
import '../models/weekmodels.dart';
import '../providers/addressitems.dart';
import '../screens/Payment_SubscriptionScreen.dart';
import '../screens/address_screen.dart';
import '../screens/home_screen.dart';
import '../utils/ResponsiveLayout.dart';
import '../utils/prefUtils.dart';
import '../widgets/footer.dart';
import '../widgets/header.dart';
import '../widgets/simmers/subscription_shimmer.dart';
import '../widgets/weekWidget/weekselectore.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:http/http.dart' as http;


class SubscribeScreen extends StatefulWidget {
  static const routeName = '/subscribe-screen';

  String itemid="";
  String itemname ="";
  String itemimg ="";
  String varname ="";
  String varmrp = "";
  String varprice="";
  String paymentMode="";
  String cronTime="";
  String name="";
  String varid="";
  String brand="";
  String addressid="";
  String useraddtype="";
  String startDate="";
  String endDate="";
  String itemCount="";
  String deliveries="";
  String total="";
  String schedule="";
  String deliveriesarry ="";
  String daily="";
  String dailyDays="";
  String weekend="";
  String weekendDays="";
  String weekday="";
  String weekdayDays="";
  String custom="";
  String alternativeDays="";
  String customDays="";
  String membershipdisplay = "";
  String membershipprice = "";
  String discountdisplay = "";
  String weight = "";
  String varType = "";

  SubscribeScreen(Map<String, String> params){
    this.itemid = params["itemid"]??"" ;
    this.itemname= params["itemname"]??"";
    this.itemimg= params["itemimg"]??"";
    this.varname= params["varname"]??"";
    this.varmrp= params["varmrp"]??"";
    this.varprice= params["varprice"]??"";
    this.paymentMode= params["paymentMode"]??"";
    this.cronTime= params["cronTime"]??"";
    this.name= params["name"]??"";
    this.varid= params["varid"]??"";
    this.brand= params["brand"]??"";
    this.addressid= params["addressid"]??"";
    this.useraddtype= params["useraddtype"]??"";
    this.startDate= params["startDate"]??"";
    this.endDate= params["endDate"]??"";
    this.itemCount= params["itemCount"]??"";
    this.deliveries= params["deliveries"]??"";
    this.total= params["total"]??"";
    this.schedule= params["schedule"]??"";
    this.deliveriesarry= params["deliveriesarray"]??"";
    this.daily= params["daily"]??"";
    this.dailyDays= params["dailyDays"]??"";
    this.weekend= params["weekend"]??"";
    this.weekendDays= params["weekendDays"]??"";
    this.weekday= params["weekday"]??"";
    this.weekdayDays= params["weekdayDays"]??"";
    this.custom= params["custom"]??"";
    this.alternativeDays= params["alternativeDays"]??"";
    this.customDays= params["customDays"]??"";
    this.membershipdisplay = params["membershipdisplay"]??"";
    this.membershipprice = params["membershipprice"]??"";
    this.discountdisplay = params["discountdisplay"]??"";
    this.weight = params["weight"]??"";
    this.varType = params["varType"]??"";
  }
  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> with Navigations {
  DateRangePickerController _datecontroller  = DateRangePickerController();
  late Future<SubscriptionPromoplan> _futureSubscriptionPromoplan = Future.value();
  bool _isWeb =false;
  bool iphonex = false;
  var itemid;
  var itemimg;
  var itemname;
  var brand;
  var varprice;
  var varname;
  var paymentMode;

  List deliveriesBackend = [];


  var cronTime;
  var name ;
  var varid ;
  var varmrp;
  late MediaQueryData queryData;
  late double wid;
  late double maxwid;
  bool _isAddToCart = false;
  var displaydate = "";
  List<Weeks> weeklydisplaydata = [];
  List<int> deliveries = [6,15,30,60];
  final now = new DateTime.now();
  DateTime _selectedDate = DateTime.now().add(Duration(days: 1));
  var _selectedDate1 ;
  var endDate;
  late DateTime initialdate;
  late DateTime finaldate;
  final TextEditingController datecontroller = new TextEditingController();
  final TextEditingController datecontroller1 = new TextEditingController();
  late List<bool> _isChecked;
  bool isCheck=false;
  String address = "";
  String Customername = "";
  List selectedweeklydata = ['mon','tue','wed','thu','fri','sat','sun'];
  String pickSchedule="";
  var _daily = ColorCodes.darkthemeColor;
  var _weekdays = Colors.grey;
  var _weekends = Colors.grey;
  late IconData addressicon;
  var addtype;
  final user_data = (VxState.store as GroceStore).userData;
  bool checkaddress = false;
  int _itemCount = 1;
  bool loading =true;
  // bool loader =true;

  List<DateTime> datelist1 =[];
  List<DateTime> list =[];
  int _selectedIndex = 0;
  int _selectedListIndex = 0;
  // String delivery="6";
  int deliveryNum= 0;

  final List<Weeks> SelectedWeek =[];
  final List SelectedDaily =[];
  late String typeselected;
  int count = 0;
  int i=0;
  late DateTime finalDate;
  late UserData addressdata;
  var finalTime;
  var finalPresentTime;
  var differenceInTime ;

  int SubscriptionPromoplanlength = 0;
  int? selectedIndex = 0;
  String? planName;
  String? days;
  String? isdefault;
  String? discountType;
  double? TotalAmount;
  String? planId;
  String? status;
  String _price = "";
  String _mrp = "";
  bool _checkmembership = false;
  List<CartItem> productBox=[];
  bool _membershipdisplay = false;
  String? membershipprice;
  bool  discountdisplay = false;

  @override
  void initState() {
    typeselected = S .current.daily;
    productBox = (VxState.store as GroceStore).CartItemList;
    Future.delayed(Duration.zero, () async {
      //  productBoxSub = Hive.box<Subscription>(productBoxNameSub);
      try {
        if (Platform.isIOS) {
          setState(() {
            _isWeb = false;
            iphonex = MediaQuery.of(context).size.height >= 812.0;
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
      deliveriesBackend.clear();
      debugPrint("widget.deliveriesarry..."+widget.deliveriesarry.toString());
      if(widget.deliveriesarry.toString() != "") {
        deliveriesBackend.addAll(widget.deliveriesarry.split(","));
        deliveryNum = int.parse(deliveriesBackend[0]);
      }else{
        deliveriesBackend = [];
        deliveryNum = 1000;
      }
      //  deliveryNum = int.parse(deliveriesBackend[0]);
      addressdata =(VxState.store as GroceStore).userData;
      if(addressdata.billingAddress!.length <= 0 ){
        setState(() {
          checkaddress = true;


        });
      }else{
        setState(() {
          address =addressdata.billingAddress![0].address.toString();
          Customername = addressdata.billingAddress![0].fullName.toString();
        });
      }


      if(VxState.store.userData.membership! == "1"){
        _checkmembership = true;
      } else {
        _checkmembership = false;
        for (int i = 0; i < productBox.length; i++) {
          if (productBox[i].mode == "1") {
            _checkmembership = true;
          }
        }
      }

      if(_checkmembership) { //Membered user
        if(_membershipdisplay){ //Eligible to display membership price
          _price = membershipprice!;
          _mrp = varmrp;
        } else if(discountdisplay){ //Eligible to display discounted price
          _price = varprice!;
          _mrp = varmrp;
        } else { //Otherwise display mrp
          _price = varmrp;
        }
      } else { //Non membered user
        if(discountdisplay){ //Eligible to display discounted price
          _price = varprice;
          _mrp = varmrp;
        } else { //Otherwise display mrp
          _price = varmrp;
        }
      }
      SubscriptionApi.getSubscriptionPromoplan(ParamBodyData(branchtype: IConstants.isEnterprise && Features.ismultivendor?IConstants.branchtype.toString():"",
        branch:PrefUtils.prefs!.getString("branch"),
        id: widget.itemid,
        ref: IConstants.refIdForMultiVendor.toString(),
        price: _price,
        total: _price,
      )).then((value) {
        setState(() {
          _futureSubscriptionPromoplan = Future.value(value);
          // loader=false;
        });
        _futureSubscriptionPromoplan.then((value) {
          if( value.status == 200 ){
            loading=false;
            SubscriptionPromoplanlength = value.data!.length;
            TotalAmount = value.data![0].grandtotal!;
            planId = value.data![0].id!;
            deliveryNum = int.parse(value.data![0].days!);
          }

        });
      });

      SelectedDaily.addAll(selectedweeklydata);
      typeselected = S .current.daily;

      final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      cronTime = widget.cronTime;
      if( now.minute < 10){
        finalTime = "0"+now.minute.toString();
        finalPresentTime = now.hour.toString()+":"+finalTime;
      }else{
        finalTime = now.minute.toString();
        finalPresentTime = now.hour.toString()+":"+finalTime;
      }

      if(now.hour > 12){
        finalPresentTime = now.hour.toString()+":"+finalTime+" "+"PM";
      }else{
        finalPresentTime = "0"+now.hour.toString()+":"+finalTime+" "+"AM";
      }
      var croneTimeUpdated;

      if(cronTime.contains("PM")){
        croneTimeUpdated = int.parse(cronTime[0]) + 12;
      }else{
        croneTimeUpdated = cronTime;
        if(croneTimeUpdated.substring(0,2).toString().contains(":")){
          croneTimeUpdated = int.parse(cronTime[0]);
        }else{
          croneTimeUpdated = int.parse(croneTimeUpdated.substring(0,2));
        }
      }
      datecontroller.text =  (((croneTimeUpdated) - int.parse(finalPresentTime.substring(0,2))) <= 0)?
      DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 2))):
      DateFormat("yyyy-MM-dd").format(DateTime.now().add(Duration(days: 1)));

      _selectedDate = (((croneTimeUpdated) - int.parse(finalPresentTime.substring(0,2))) <= 0)?
      DateTime.now().add(Duration(days: 2)):
      DateTime.now().add(Duration(days: 1));


    });

    super.initState();
    _isChecked = List<bool>.filled(weeklydisplaydata.length, false);
  }


  Widget handler(int isSelected) {
    return (isSelected == _selectedIndex)  ?
    Container(
      width: 20.0,
      height: 20.0,
      decoration: BoxDecoration(
        color: ColorCodes.whiteColor,
        border: Border.all(
          color: ColorCodes.greenColor,
        ),
        shape: BoxShape.circle,
      ),
      child: Container(
        margin: EdgeInsets.all(1.5),
        decoration: BoxDecoration(
          color:ColorCodes.whiteColor,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check,
            color: ColorCodes.greenColor,
            size: 15.0),
      ),
    )
        :
    Icon(
        Icons.radio_button_off_outlined,
        color: ColorCodes.lightGreyColor);


  }

  _onSelected(int index, setState) {
    setState(() {
      _selectedIndex = index;
    });
  }


  showMonthly( setState) {

    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setState1) {
                void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
                  list = args.value;
                  if(list.length>5) {
                    _datecontroller.selectedDates = datelist1;
                    Fluttertoast.showToast(
                        msg: S .current.you_cannot_add_more_than_5_dates);
                  }
                  else {
                    _datecontroller.selectedDates = list;
                  }
                  datelist1 = _datecontroller.selectedDates!;
                }
                return Container(
                  // height: 400,
                  child: Padding(

                    padding: EdgeInsets.symmetric(
                        vertical: 5, horizontal: 28),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(S .current.select_delivery_dates,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                            GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Image(
                                  height: 40,
                                  width: 40,
                                  image: AssetImage(
                                      Images.bottomsheetcancelImg),
                                  color: Colors.black,
                                )),
                          ],
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(20.0),
                          child:
                          SfDateRangePicker(
                            onSelectionChanged: _onSelectionChanged,
                            selectionMode: DateRangePickerSelectionMode.multiple,
                            view: DateRangePickerView.month,
                            headerHeight: 0,

                            controller: _datecontroller,
                            initialSelectedDates: _datecontroller.selectedDates,
                            minDate: DateTime(DateTime.now().year,DateTime.now().month,1),
                            maxDate: DateTime(DateTime.now().year,DateTime.now().month,DateTime(DateTime.now().year,DateTime.now().month + 1, 0).day),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5.0),
                            color: Theme.of(context).buttonColor,
                          ),
                          child:
                          Row(
                            children: [
                              SizedBox(width: 20,),
                              Column(
                                children: [
                                  Container(
                                      child: Text(S .current.subscription_starts_date, style: TextStyle(
                                        fontSize: 16,
                                        color: ColorCodes.blackColor,
                                      ),)
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                      child: Text(DateFormat("dd-MM-yyyy").format(_selectedDate), style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: ColorCodes.blackColor,
                                      ),)
                                  ),
                                ],
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: (){
                                  _selectDate(context,setState1);
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: Icon(Icons.calendar_today, color: Colors.grey,),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                            if(list.length<= 0){
                              Fluttertoast.showToast(msg: S .current.select_delivery_dates);
                            }else{
                              setState(() {
                                datecontroller.text= DateFormat("yyyy-MM-dd").format(_selectedDate);
                                Navigator.of(context).pop();
                              });
                            }


                          },
                          child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10.0),
                                color: Theme.of(context).primaryColor,
                              ),
                              height: 40,

                              alignment: Alignment.center,
                              child: Text(S .current.submit, style: TextStyle(
                                  color: ColorCodes.whiteColor
                              ),)
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                );

              }),
            ],
          );
        });
  }
  showRepeat(BuildContext context , setState) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius. only(topLeft: Radius. circular(15.0), topRight: Radius. circular(15.0)),
        ),
        builder: (context) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setState1) {
                void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
                  list = args.value;
                  if(list.length>5) {
                    _datecontroller.selectedDates = datelist1;
                    Fluttertoast.showToast(
                        msg: S .current.you_cannot_add_more_than_5_dates);
                  }
                  else {
                    _datecontroller.selectedDates = list;
                  }
                  datelist1 = _datecontroller.selectedDates!;
                }
                return Container(
                  // height: 400,
                  child: Padding(

                    padding: EdgeInsets.symmetric(
                        vertical: 5, horizontal: 28),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(

                          children: [
                            Flexible(
                              child: Text(S .current.choose_days,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .primaryColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width:40,
                              height: 40,

                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text(/*"M"*/S.of(context).m)),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text(/*"T"*/S.of(context).t)),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text(/*"W"*/S.of(context).w)),
                            ),
                            Container(
                              width:40,
                              height: 40,

                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text(/*"T"*/S.of(context).t)),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text(/*"F"*/S.of(context).f)),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text(/*"S"*/S.of(context).s)),
                            ),
                            Container(
                              width:40,
                              height: 40,
                              decoration: BoxDecoration(
                                  border: Border.all(color: ColorCodes.primaryColor),
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: Text(/*"S"*/S.of(context).s)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width:80,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide( color: _daily,),
                                  bottom: BorderSide( color: _daily,),
                                  left: BorderSide( color: _daily),
                                  right: BorderSide( color: _daily),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: Center(child: Text(S .current.daily)),
                            ),
                            Container(
                              width:80,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCodes.primaryColor),
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: Center(child: Text(S .current.weekdays)),
                            ),
                            Container(
                              width:80,
                              height: 50,

                              decoration: BoxDecoration(
                                border: Border.all(color: ColorCodes.primaryColor),
                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),
                              child: Center(child: Text(S .current.weekends)),
                            ),
                          ],
                        ),

                        SizedBox(height: 20,),
                        GestureDetector(
                          onTap: (){
                            if(list.length<= 0){
                              Fluttertoast.showToast(msg: S .current.please_select_days);
                            }else{
                              setState(() {
                                datecontroller.text= DateFormat("yyyy-MM-dd").format(_selectedDate);
                                Navigator.of(context).pop();
                              });
                            }


                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3.0),
                                color: Theme.of(context).primaryColor,
                              ),
                              height: 40,
                              alignment: Alignment.center,
                              child: Text(S .current.confirm, style: TextStyle(
                                  color: ColorCodes.whiteColor
                              ),)
                          ),
                        ),
                        SizedBox(height: 20,)
                      ],
                    ),
                  ),
                );

              }),
            ],
          );
        });
  }



  showDeliveries( BuildContext context , setState ) {
    showModalBottomSheet<dynamic>(
        isScrollControlled: true,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius. only(topLeft: Radius. circular(15.0), topRight: Radius. circular(15.0)),
        ),
        builder: (context1) {
          return Wrap(
            children: [
              StatefulBuilder(builder: (context, setState1) {
                return Container(

                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          SizedBox(width: 10,),
                          Flexible(
                            child: Text(S .current.chose_delivery,
                                style: TextStyle(
                                  color: ColorCodes.blackColor,
                                  // color: Theme
                                  //     .of(context)
                                  //     .primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                )),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        child: ListView.separated(
                            separatorBuilder: (context, index) => SizedBox(height: 10,),
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            //separatorBuilder: (BuildContext context, int i) => const Divider(),
                            itemCount: deliveriesBackend.length,
                            itemBuilder: (_, i) {
                              return
                                GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: (){
                                    setState((){
                                      _onSelected(i,setState1);
                                    });

                                  },
                                  child: Container(
                                    height: 30,
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 20,),
                                        Text(
                                          deliveriesBackend[i].toString() + " " + S .current.deliveries,
                                          style: TextStyle(color: ColorCodes.blackColor,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Spacer(),
                                        handler(i),
                                        SizedBox(width: 20,),
                                      ],
                                    ),
                                  ),
                                );
                              /*Column(
                                children: [
                                  Container(
                                    color: _selectedIndex != null && _selectedIndex == i
                                        ? ColorCodes.whiteColor
                                        : Colors.white,
                                    child: ListTile(
                                      title: Text(deliveriesBackend[i].toString() + " " + S .current.deliveries),
                                      onTap: () {
                                        setState((){
                                          _onSelected(i,setState1);
                                        });

                                      },
                                      trailing: handler(i),
                                    ),
                                  ),

                                ],
                              );*/
                            }),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          SizedBox(
                            width: 12,
                          ),
                          GestureDetector(
                            onTap: (){
                              setState((){
                                deliveryNum = int.parse(deliveriesBackend[_selectedIndex]);
                              });

                              Navigator.of(context).pop();
                            },
                            child: Container(
                                width: MediaQuery.of(context).size.width-24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3.0),
                                  color: Theme.of(context).primaryColor,
                                ),
                                height: 40,

                                alignment: Alignment.center,
                                child: Text(S .current.select_deliveries, style: TextStyle(
                                    color: ColorCodes.whiteColor
                                ),)
                            ),
                          ),
                          SizedBox(
                            width: 12,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    itemname = /*routeArgs["itemname"]*/widget.itemname;
    itemid = /*routeArgs["itemid"]*/widget.itemid;
    itemimg = /*routeArgs["itemimg"]*/widget.itemimg;
    varname = /*routeArgs["varname"]*/widget.varname;
    varprice = /*routeArgs["varprice"]*/widget.varprice;
    paymentMode = /*routeArgs["paymentMode"]*/widget.paymentMode;
    cronTime= /*routeArgs['cronTime']*/widget.cronTime;
    name = /*routeArgs['name']*/widget.name;
    varid = /*routeArgs['varid']*/widget.varid;
    varmrp = /*routeArgs['varmrp']*/widget.varmrp;
    brand = /*routeArgs['brand']*/widget.brand;
    _membershipdisplay = widget.membershipdisplay == "true"?true:false;
    membershipprice = widget.membershipprice;
    discountdisplay = widget.discountdisplay == "true"? true:false;

    if(VxState.store.userData.membership! == "1"){
      _checkmembership = true;
    } else {
      _checkmembership = false;
      for (int i = 0; i < productBox.length; i++) {
        if (productBox[i].mode == "1") {
          _checkmembership = true;
        }
      }
    }

    if(_checkmembership) { //Membered user
      if(_membershipdisplay){ //Eligible to display membership price
        _price = membershipprice!;
        _mrp = varmrp;
      } else if(discountdisplay){ //Eligible to display discounted price
        _price = varprice!;
        _mrp = varmrp;
      } else { //Otherwise display mrp
        _price = varmrp;
      }
    } else { //Non membered user
      if(discountdisplay){ //Eligible to display discounted price
        _price = varprice;
        _mrp = varmrp;
      } else { //Otherwise display mrp
        _price = varmrp;
      }
    }
    if(Features.iscurrencyformatalign) {
      _price = '${_price} ' + IConstants.currencyFormat;
      if(_mrp != "")
        _mrp = '${_mrp} ' + IConstants.currencyFormat;
    } else {
      _price = IConstants.currencyFormat + '${_price} ';
      if(_mrp != "")
        _mrp =  IConstants.currencyFormat + '${_mrp} ';
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
        title: Text(S .current.subscribe,
          style: TextStyle(color: ColorCodes.iconColor, fontWeight: FontWeight.bold, fontSize: 18),),
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
        title: S .current.subscribe.toUpperCase(),
        total: "0",
        onPressed: (){
          setState(() {

          });
        },
      ):
      BottomNaviagation(
        itemCount: "0",
        title: S .current.subscribe.toUpperCase(),
        total: "0",
        onPressed: (){
          setState(() {
            if(typeselected == S .current.daily){
            }else{
            }

            if(address == ""){
              Fluttertoast.showToast(msg: S .current.please_add_delivery_address);
            }else if(SelectedWeek.length == 0 /*&& typeselected != S .current.daily*/  &&  typeselected != S .current.alternative){
              Fluttertoast.showToast(msg: S .current.please_select_repeat_type);
            }
            else{
              double total= /*((_itemCount * TotalAmount!) * (deliveryNum))*/TotalAmount!;
              List<String> weeks  = [];
              SelectedWeek.map((e) => weeks.add(e.weekname)).toList();

              if (paymentMode.toString() == "0") {
                print("paymentmode........:"+{
                  "addressid":user_data.billingAddress![0].id.toString(),
                  "useraddtype":user_data.billingAddress![0].addressType.toString(),
                  "startDate":datecontroller.text,
                  "endDate": _selectedDate1.toString(),
                  "itemCount": _itemCount.toString(),
                  "deliveries": deliveryNum.toString(),
                  "total": total,
                  "schedule": typeselected,
                  "itemid": /*routeArgs['itemid'].toString()*/widget.itemid,
                  "itemimg": /*routeArgs['itemimg'].toString()*/widget.itemimg,
                  "itemname":itemname.toString(),
                  "varprice":/*routeArgs['varprice'].toString()*/widget.varprice,
                  "varname":/*routeArgs['varname'].toString()*/widget.varname,
                  "address":address.toString(),
                  "paymentMode": paymentMode.toString(),
                  "cronTime": cronTime.toString(),
                  "name": name.toString(),
                  "varid": varid.toString(),
                  "varmrp":/*routeArgs['varmrp'].toString()*/widget.varmrp,
                  "brand" :brand.toString(),
                  "weeklist":(typeselected == S .current.daily)?SelectedDaily.toString():weeks.toString(),
                  "no_of_days":(typeselected == S .current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString(),
                  "varType" : widget.varType
                }.toString());
                Navigation(context, name: Routename.PaymenSubscription, navigatore: NavigatoreTyp.Push,
                    qparms: {
                      "addressid":user_data.billingAddress![0].id.toString(),
                      "useraddtype":user_data.billingAddress![0].addressType.toString(),
                      "startDate":datecontroller.text,
                      "endDate": _selectedDate1.toString(),
                      "itemCount": _itemCount.toString(),
                      "deliveries": deliveryNum.toString(),
                      "total": total,
                      "schedule": typeselected,
                      "itemid": /*routeArgs['itemid'].toString()*/widget.itemid,
                      "itemimg": /*routeArgs['itemimg'].toString()*/widget.itemimg,
                      "itemname":itemname.toString(),
                      "varprice":/*routeArgs['varprice'].toString()*/widget.varprice,
                      "varname":/*routeArgs['varname'].toString()*/widget.varname,
                      "address":address.toString(),
                      "paymentMode": paymentMode.toString(),
                      "cronTime": cronTime.toString(),
                      "name": name.toString(),
                      "varid": varid.toString(),
                      "varmrp":/*routeArgs['varmrp'].toString()*/widget.varmrp,
                      "brand" :brand.toString(),
                      "weeklist":(typeselected == S .current.daily)?SelectedDaily.toString():weeks.toString(),
                      "no_of_days":(typeselected == S .current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString(),
                      "deliveriesarray":widget.deliveriesarry,
                      "daily":widget.daily,
                      "dailyDays":widget.dailyDays,
                      "weekend": widget.weekend,
                      "weekendDays": widget.weekendDays,
                      "weekday": widget.weekday,
                      "weekdayDays":widget.weekdayDays,
                      "custom": widget.custom,
                      "alternativeDays": widget.alternativeDays,
                      "customDays": widget.customDays,
                      "planId": planId,
                      "weight": widget.weight,
                      "varType" : widget.varType
                    });
              }else{
                CreateSubscription();
              }

            }
          });
        },
      );
    }

    Widget _bodyWeb() {
      final addressitemsData = Provider.of<AddressItemsList>(context, listen: false);
      if(addressitemsData.items.length > 0) {
        address = addressitemsData.items[0].useraddress.toString();
        Customername = addressitemsData.items[0].username.toString();
      }

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
      // var finalDa;
      // if(typeselected == S .current.daily){
      //   DateTime weekdayOf(DateTime time, int weekday) => time.add(Duration(days: weekday - time.weekday));
      //   finalDa = now.add(Duration(days: deliveryNum));
      //   _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDa);
      // }
      // else {
      //   initialdate = _selectedDate;
      //   List<int> availableTime = [];
      //   for (int i = 0; i < SelectedWeek.length; i++) {
      //     availableTime.add(SelectedWeek[i].weekname == 'Mon'
      //         ? 1
      //         : SelectedWeek[i].weekname == 'Tue'
      //         ? 2
      //         : SelectedWeek[i].weekname == 'Wed'
      //         ? 3
      //         : SelectedWeek[i].weekname == 'Thu'
      //         ? 4
      //         : SelectedWeek[i].weekname == 'Fri' ? 5
      //         : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);
      //
      //   }
      //
      //   try{
      //     for (int i = 0; i <= deliveryNum; i++) {
      //
      //       availableTime.map((e) {
      //         if (e == initialdate.weekday) {
      //         }
      //       }).toList();
      //       initialdate = initialdate.add(Duration(days: 1));
      //     }
      //   }catch(e){
      //   }
      //
      //   finalDate = initialdate;
      //   _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDate);
      // }
      //
      //
      // if( now.minute < 10){
      //   finalTime = "0"+now.minute.toString();
      //   finalPresentTime = now.hour.toString()+":"+finalTime;
      // }else{
      //   finalTime = now.minute.toString();
      //   finalPresentTime = now.hour.toString()+":"+finalTime;
      // }
      //
      // if(now.hour > 12){
      //   finalPresentTime = now.hour.toString()+":"+finalTime+" "+"PM";
      // }else{
      //   finalPresentTime = "0"+now.hour.toString()+":"+finalTime+" "+"AM";
      // }
      // var croneTimeUpdated;
      // if(cronTime.contains("PM")){
      //   croneTimeUpdated = int.parse(cronTime[0]) + 12;
      // }else{
      //   croneTimeUpdated = cronTime;
      //   if(croneTimeUpdated.substring(0,2).toString().contains(":")){
      //     croneTimeUpdated = int.parse(cronTime[0]);
      //   }else{
      //     croneTimeUpdated = int.parse(croneTimeUpdated.substring(0,2));
      //   }
      // }


      var finalDa;
      if(typeselected == S .current.daily){
        DateTime weekdayOf(DateTime time, int weekday) => time.add(Duration(days: weekday - time.weekday));
        finalDa = now.add(Duration(days: deliveryNum));
        _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDa);
      }
      else {
        initialdate = _selectedDate;
        List<int> availableTime = [];
        for (int i = 0; i < SelectedWeek.length; i++) {
          availableTime.add(SelectedWeek[i].weekname == 'Mon'
              ? 1
              : SelectedWeek[i].weekname == 'Tue'
              ? 2
              : SelectedWeek[i].weekname == 'Wed'
              ? 3
              : SelectedWeek[i].weekname == 'Thu'
              ? 4
              : SelectedWeek[i].weekname == 'Fri' ? 5
              : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);

        }
        try{
          for (int i = 0; i <= deliveryNum; i++) {
            availableTime.map((e) {
              if (e == initialdate.weekday) {
              }
            }).toList();
            initialdate = initialdate.add(Duration(days: 1));
          }
        }catch(e){
        }

        finalDate = initialdate;
        _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDate);
      }
      // var now = new DateTime.now();
      if( now.minute < 10){
        finalTime = "0"+now.minute.toString();
        finalPresentTime = now.hour.toString()+":"+finalTime;
      }else{
        finalTime = now.minute.toString();
        finalPresentTime = now.hour.toString()+":"+finalTime;
      }

      if(now.hour > 12){
        finalPresentTime = now.hour.toString()+":"+finalTime+" "+"PM";
      }else{
        finalPresentTime = "0"+now.hour.toString()+":"+finalTime+" "+"AM";
      }
      var croneTimeUpdated;
      if(cronTime.contains("PM")){
        croneTimeUpdated = int.parse(cronTime[0]) + 12;
      }else{
        croneTimeUpdated = cronTime;
        if(croneTimeUpdated.substring(0,2).toString().contains(":")){
          croneTimeUpdated = int.parse(cronTime[0]);
        }else{
          croneTimeUpdated = int.parse(croneTimeUpdated.substring(0,2));
        }
      }


      queryData = MediaQuery.of(context);
      wid= queryData.size.width;
      maxwid=wid*0.90;
      return loading /*&& loader*/ ?
      SubscriptionShimmer()
          :checkaddress?
      Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                padding:  EdgeInsets.only(left: 20,right: 20, top: 20,bottom: 10),
                color: ColorCodes.whiteColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,

                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20,),
                          Container(
                            // color: ColorCodes.mediumgren,
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundColor: ColorCodes.whiteColor,
                              backgroundImage: AssetImage(Images.defaultProductImg),
                              child: Image.network(itemimg,height: 100,width: 100,fit: BoxFit.fill,),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            brand,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),

                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            itemname,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),

                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            varname,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _price,
                                          /*Features.iscurrencyformatalign?
                                          double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " +  IConstants.currencyFormat:
                                          IConstants.currencyFormat + " " + double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),*/
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(width: 2,),
                                        Text(
                                          _mrp,
                                          /* Features.iscurrencyformatalign?
                                          double.parse(varmrp).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                          IConstants.currencyFormat + " " + double.parse(varmrp).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),*/
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),

                                  ])),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 80,
                      child: Row(
                        children: <Widget>[

                          Text(
                            S .current.quantity_per_day,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),

                          Spacer(),
                          Row(
                            children: [
                              _itemCount!=0?
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  setState(()=>_itemCount==1? _itemCount:_itemCount--);
                                },
                                child: new  Container(
                                  color: ColorCodes.accentColor,
                                  width: 40,
                                  height: 40,
                                  child:Center(
                                    child: Text(
                                      "-",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        //color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  :
                              new Container(),
                              Container(
                                  color: ColorCodes.primaryColor,
                                  width: 40,
                                  height: 40,
                                  child:
                                  Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.whiteColor, fontSize: 14, fontWeight: FontWeight.bold),))
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  setState(()=>_itemCount++);
                                },
                                child: Container(
                                  color: ColorCodes.accentColor,
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "+",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        //color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),

                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder<SubscriptionPromoplan>(
                        future: _futureSubscriptionPromoplan,
                        builder: (BuildContext context,AsyncSnapshot<SubscriptionPromoplan> snapshot){
                          final SubscriptionPromoplan = snapshot.data;
                          if (SubscriptionPromoplan!=null)
                            return  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).pick_subscription_option,//"Pick Subscription option",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 10,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: SubscriptionPromoplan.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                            //TotalAmount = SubscriptionPromoplan.data![selectedIndex!].grandtotal;
                                            TotalAmount = SubscriptionPromoplan.data![selectedIndex!].grandtotal!;
                                            planId = SubscriptionPromoplan.data![selectedIndex!].id!;
                                            if (SubscriptionPromoplan.data![index].isdefault =="1")
                                              deliveryNum = 1000;
                                            else
                                              deliveryNum = int.parse(SubscriptionPromoplan.data![index].days!);
                                          },
                                          child: Column(
                                            children: [

                                              Row(
                                                children: [
                                                  //IConstants.currencyFormat+SubscriptionPromoplan.data![index].discountAmount!
                                                  SubscriptionPromoplan.data![index].isdefault =="1" ?
                                                  Text(SubscriptionPromoplan.data![index].planName!, style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold
                                                  ),):
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(

                                                        child: Text(SubscriptionPromoplan.data![index].planName!+/*" plan for "*/S.of(context).plan_for+SubscriptionPromoplan.data![index].days!+" "+
                                                            /*"days at SPECIAL Price of "*/S.of(context).days_spl+IConstants.currencyFormat+SubscriptionPromoplan.data![index].subscriptionamount!.toStringAsFixed(2)+" "+/*" per pack"*/S.of(context).per_pack,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Text(/*"*Original price "*/S.of(context).original_price+IConstants.currencyFormat+double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+ /*" per pack"*/S.of(context).per_pack,
                                                        style: TextStyle(
                                                            fontSize: 10,

                                                            color: ColorCodes.lightGreyColor
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    children: [
                                                      Text(S.of(context).total,//"Total",

                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorCodes.lightGreyColor
                                                        ),
                                                      ),
                                                      Text(IConstants.currencyFormat+SubscriptionPromoplan.data![index].grandtotal!.toStringAsFixed(2),
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: ColorCodes.lightGreyColor
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 10,),
                                                  handlerSubscribe(index, selectedIndex!),
                                                ],
                                              ),
                                              SizedBox(height: 10,)
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                                SizedBox(height: 10,)
                              ],
                            );
                          else
                            return SizedBox.shrink();

                        },
                      ),
                    ),
                    SubscriptionPromoplanlength > 0? DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0):SizedBox.shrink(),

                    SubscriptionPromoplanlength > 0? SizedBox(height: 10,): SizedBox.shrink(),
                    WeekSelector(onclick: (weeklist,type){
                      SelectedWeek.clear();
                      SelectedWeek.addAll(weeklist.where((element) => element.isselected==true));
                      typeselected = type;
                    },
                      daily: widget.daily,
                      dailyDays: widget.dailyDays,
                      weekday: widget.weekday,
                      weekdayDays: widget.weekdayDays,
                      weekend: widget.weekend,
                      weekendDays: widget.weekendDays,
                      custom: widget.custom,
                      alternativeDays: widget.alternativeDays,
                      customDays: widget.customDays,
                      paymentMode: paymentMode.toString(),
                      selectedDate: _selectedDate,
                    ),
                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),
                    deliveriesBackend.length > 0?
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        showDeliveries(context, setState);
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Text(
                              S .current.recharge_or_topup,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              /*decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCodes.mediumgren
                                ),

                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),*/
                              child: Row(
                                children: [
                                  Text(
                                    deliveryNum.toString() + " " + S .of(context).deliveries,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ): SizedBox.shrink(),
                    deliveriesBackend.length > 0?
                    SizedBox(height: 10,): SizedBox.shrink(),
                    deliveriesBackend.length > 0?
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0): SizedBox.shrink(),
                    deliveriesBackend.length > 0? SizedBox(height: 10,): SizedBox.shrink(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          _selectDate(context,setState);
                        });
                      },
                      child:
                      Container(
                        height: 50,

                        child: Row(
                          children: [
                            Text(
                              S .current.start_dat,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              /*decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCodes.mediumgren
                                ),

                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),*/
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat("dd-MM-yyyy").format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),

                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        PrefUtils.prefs!.setString("addressbook",
                            "SubscriptionScreen");

                        /*   Navigator.of(context).pushReplacementNamed(AddressScreen.routeName,
                            arguments: {
                              'addresstype': "new",
                              'addressid': "",
                              'delieveryLocation': "",
                              'latitude': "",
                              'longitude': "",
                              'branch': "",
                              "itemname": itemname.toString(),
                              "itemid": itemid.toString(),
                              "itemimg":itemimg.toString(),
                              "varname": varname.toString(),
                              "varprice": varprice.toString(),
                              "paymentMode":paymentMode.toString(),
                              "cronTime": *//*routeArgs['cronTime'].toString()*//*widget.cronTime,
                              "name": *//*routeArgs['name'].toString()*//*widget.name,
                              "varmrp":*//*routeArgs['varmrp'].toString()*//*widget.varmrp,
                              "varid": *//*routeArgs['varid'].toString()*//*widget.varid,
                              "brand" :brand.toString()
                            });*/
                        if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                          // _dialogforaddress(context);
                          AddressWeb(context,
                              addresstype: "new",
                              addressid: "",
                              delieveryLocation: "",
                              latitude: "",
                              longitude: "",
                              branch: "",
                              itemname: itemname,
                              itemid: itemid,
                              itemimg: itemimg,
                              varname: varname,
                              varprice: varprice,
                              paymentMode: paymentMode,
                              cronTime: widget.cronTime,
                              name: widget.name,
                              varmrp: widget.varmrp,
                              varid: widget.varid,
                              brand: brand,
                              deliveriesarry: widget.deliveriesarry,
                              daily: widget.daily,
                              dailyDays: widget.dailyDays,
                              weekend: widget.weekend,
                              weekendDays: widget.weekendDays,
                              weekday: widget.weekday,
                              weekdayDays: widget.weekdayDays,
                              custom: widget.custom,
                              alternativeDays: widget.alternativeDays,
                              customDays: widget.customDays,
                              weight: widget.weight
                          );
                        }
                        else {
                          Navigation(context, name: Routename.AddressScreen,
                              navigatore: NavigatoreTyp.Push,
                              qparms: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': "",
                                "itemname": itemname,
                                "itemid": itemid,
                                "itemimg": itemimg,
                                "varname": varname,
                                "varprice": varprice,
                                "paymentMode": paymentMode,
                                "cronTime": widget.cronTime,
                                "name": widget.name,
                                "varmrp": widget.varmrp,
                                "varid": widget.varid,
                                "brand": brand,
                                "deliveriesarray": widget.deliveriesarry,
                                "daily": widget.daily,
                                "dailyDays": widget.dailyDays,
                                "weekend": widget.weekend,
                                "weekendDays": widget.weekendDays,
                                "weekday": widget.weekday,
                                "weekdayDays": widget.weekdayDays,
                                "custom": widget.custom,
                                "alternativeDays" : widget.alternativeDays,
                                "customDays": widget.customDays,
                                "weight": widget.weight
                              });
                        }
                      },
                      child: Column(
                        children: [
                          Row(

                            children: [
                              Container(
                                  child: Text(S .current.address, style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),)
                              ),
                              Spacer(),
                              Container(
                                width: 100,
                                height: 40,
                                decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(3.0),
                                    border: Border(
                                      top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                      bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                      left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                      right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                                    )),
                                child: Center(child:
                                Text(S .current.add_address,style: TextStyle(color: ColorCodes.whiteColor),
                                  textAlign: TextAlign.center,)),
                              ),
                            ],
                          ),
                          SizedBox(height: 30,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              if (_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),

            ],
          ),
        ),
      )

          :Expanded(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                padding:  EdgeInsets.only(left: 20,right: 20, top: 20,bottom: 10),
                //height: MediaQuery.of(context).size.height,
                color: ColorCodes.whiteColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,

                      child: Row(
                        children: <Widget>[
                          SizedBox(width: 20,),
                          Container(
                            color: ColorCodes.whiteColor,
                            height: 100,
                            width: 100,
                            child: CircleAvatar(
                              backgroundColor: ColorCodes.whiteColor,
                              backgroundImage: AssetImage(Images.defaultProductImg),
                              child: Image.network(itemimg,height: 100,width: 100,fit: BoxFit.fill,),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            brand,
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.black),
                                          ),

                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            itemname,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),

                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            varname,
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.green),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          _price,
                                          /*Features.iscurrencyformatalign?
                                          double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " +  IConstants.currencyFormat:
                                          IConstants.currencyFormat + " " + double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),*/
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black),
                                        ),
                                        SizedBox(width: 2,),
                                        Text(
                                          _mrp,
                                          /*Features.iscurrencyformatalign?
                                          double.parse(varmrp.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " +  IConstants.currencyFormat:
                                          IConstants.currencyFormat + " " + double.parse(varmrp.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),*/
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              decoration: TextDecoration.lineThrough,
                                              color: Colors.grey),
                                        )
                                      ],
                                    ),

                                  ])),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Container(
                      height: 80,
                      child: Row(
                        children: <Widget>[

                          Text(
                            S .current.quantity_per_day,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),

                          Spacer(),
                          Row(
                            children: [
                              _itemCount!=0?
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  setState(()=>_itemCount==1? _itemCount:_itemCount--);
                                },
                                child: new  Container(
                                  color: ColorCodes.accentColor,
                                  width: 40,
                                  height: 40,
                                  child:Center(
                                    child: Text(
                                      "-",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16
                                        //color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                                  :
                              new Container(),
                              Container(
                                  color: ColorCodes.primaryColor,
                                  width: 40,
                                  height: 40,
                                  child:
                                  Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.whiteColor, fontSize: 14, fontWeight: FontWeight.bold),))
                              ),
                              GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: (){
                                  setState(()=>_itemCount++);
                                },
                                child: Container(
                                  color: ColorCodes.accentColor,
                                  width: 40,
                                  height: 40,
                                  child: Center(
                                    child: Text(
                                      "+",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: ColorCodes.whiteColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold
                                        //color: Theme.of(context).buttonColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                    ),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),

                    SizedBox(height: 10,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: FutureBuilder<SubscriptionPromoplan>(
                        future: _futureSubscriptionPromoplan,
                        builder: (BuildContext context,AsyncSnapshot<SubscriptionPromoplan> snapshot){
                          final SubscriptionPromoplan = snapshot.data;
                          if (SubscriptionPromoplan!=null)
                            return  Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  S.of(context).pick_subscription_option,//"Pick Subscription option",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                SizedBox(height: 10,),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: SubscriptionPromoplan.data!.length,
                                      itemBuilder: (BuildContext context, int index) {
                                        return GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              selectedIndex = index;
                                            });
                                            //  TotalAmount = SubscriptionPromoplan.data![selectedIndex!].grandtotal!;
                                            TotalAmount = SubscriptionPromoplan.data![selectedIndex!].grandtotal!;
                                            planId = SubscriptionPromoplan.data![selectedIndex!].id!;
                                            if (SubscriptionPromoplan.data![index].isdefault =="1")
                                              deliveryNum = 1000;
                                            else
                                              deliveryNum = int.parse(SubscriptionPromoplan.data![index].days!);
                                          },
                                          child:Column(
                                            children: [

                                              Row(
                                                children: [
                                                  //IConstants.currencyFormat+SubscriptionPromoplan.data![index].discountAmount!
                                                  SubscriptionPromoplan.data![index].isdefault =="1" ?
                                                  Text(SubscriptionPromoplan.data![index].planName!, style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold
                                                  ),):
                                                  Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(

                                                        child: Text(SubscriptionPromoplan.data![index].planName!+/*" plan for "*/S.of(context).plan_for+SubscriptionPromoplan.data![index].days!+" "+
                                                            S.of(context).days_spl /*"days at SPECIAL Price of "*/+IConstants.currencyFormat+SubscriptionPromoplan.data![index].subscriptionamount!.toStringAsFixed(2)+" "+/*" per pack"*/S.of(context).per_pack,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight: FontWeight.bold
                                                          ),
                                                          maxLines: 3,
                                                          overflow: TextOverflow.ellipsis,
                                                        ),
                                                      ),
                                                      Text(/*"*Original price "*/S.of(context).original_price+IConstants.currencyFormat+double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+/* " per pack"*/S.of(context).per_pack,
                                                        style: TextStyle(
                                                            fontSize: 10,

                                                            color: ColorCodes.lightGreyColor
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  Column(
                                                    children: [
                                                      Text(S.of(context).total,//"Total",

                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight: FontWeight.bold,
                                                            color: ColorCodes.lightGreyColor
                                                        ),
                                                      ),
                                                      Text(IConstants.currencyFormat+SubscriptionPromoplan.data![index].grandtotal!.toStringAsFixed(2),
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: ColorCodes.lightGreyColor
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width: 10,),
                                                  handlerSubscribe(index, selectedIndex!),
                                                ],
                                              ),
                                              SizedBox(height: 10,)
                                            ],
                                          ),
                                        );
                                      }),
                                ),
                                SizedBox(height: 10,)
                              ],
                            );
                          else
                            return SizedBox.shrink();

                        },
                      ),
                    ),
                    SubscriptionPromoplanlength > 0? DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0):SizedBox.shrink(),

                    SubscriptionPromoplanlength > 0? SizedBox(height: 10,): SizedBox.shrink(),
                    WeekSelector(onclick: (weeklist,type){
                      SelectedWeek.clear();
                      SelectedWeek.addAll(weeklist.where((element) => element.isselected==true));
                      typeselected = type;
                    },
                      daily: widget.daily,
                      dailyDays: widget.dailyDays,
                      weekday: widget.weekday,
                      weekdayDays: widget.weekdayDays,
                      weekend: widget.weekend,
                      weekendDays: widget.weekendDays,
                      custom: widget.custom,
                      alternativeDays: widget.alternativeDays,
                      customDays: widget.customDays,
                      paymentMode: paymentMode.toString(),
                      selectedDate: _selectedDate,
                    ),
                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),
                    deliveriesBackend.length > 0?
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        showDeliveries(context, setState);
                      },
                      child: Container(
                        height: 50,
                        child: Row(
                          children: [
                            Text(
                              S .current.recharge_or_topup,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              /* decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCodes.mediumgren
                                ),

                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),*/
                              child: Row(
                                children: [
                                  Text(
                                    deliveryNum.toString() + " " + S .of(context).deliveries,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ):SizedBox.shrink(),
                    deliveriesBackend.length > 0?
                    SizedBox(height: 10,):SizedBox.shrink(),
                    deliveriesBackend.length > 0?
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0):SizedBox.shrink(),
                    deliveriesBackend.length > 0?SizedBox(height: 10,):SizedBox.shrink(),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        setState(() {
                          _selectDate(context,setState);
                        });
                      },
                      child:
                      Container(
                        height: 50,

                        child: Row(
                          children: [
                            Text(
                              S .current.start_dat,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(10),
                              /* decoration: BoxDecoration(
                                border: Border.all(
                                    color: ColorCodes.mediumgren
                                ),

                                borderRadius: BorderRadius.all(Radius.circular(3)),
                              ),*/
                              child: Row(
                                children: [
                                  Text(
                                    DateFormat("dd-MM-yyyy").format(_selectedDate),
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.green,size: 16,),
                                ],
                              ),
                            ),

                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10,),
                    DottedLine(
                        dashColor: ColorCodes.lightgrey,
                        lineThickness: 1.0,
                        dashLength: 2.0,
                        dashRadius: 0.0,
                        dashGapLength: 1.0),
                    SizedBox(height: 10,),
                    GestureDetector(
                      onTap: (){
                        setState(() {
                          PrefUtils.prefs!.setString("addressbook",
                              "SubscriptionScreen");

                          /*  Navigator.of(context).pushReplacementNamed(AddressScreen.routeName,
                              arguments: {
                                'addresstype': "new",
                                'addressid': "",
                                'delieveryLocation': "",
                                'latitude': "",
                                'longitude': "",
                                'branch': "",
                                "itemname": itemname.toString(),
                                "itemid": itemid.toString(),
                                "itemimg":itemimg.toString(),
                                "varname": varname.toString(),
                                "varprice": varprice.toString(),
                                "paymentMode":paymentMode.toString(),
                                "cronTime": *//*routeArgs['cronTime'].toString()*//*widget.cronTime,
                                "name": *//*routeArgs['name'].toString()*//*widget.name,
                                "varmrp":*//*routeArgs['varmrp'].toString()*//*widget.varmrp,
                                "varid": *//*routeArgs['varid'].toString()*//*widget.varid,
                                "brand" :brand.toString()
                              });*/
                          if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                            // _dialogforaddress(context);
                            AddressWeb(context,
                                addresstype: "new",
                                addressid: "",
                                delieveryLocation: "",
                                latitude: "",
                                longitude: "",
                                branch: "",
                                itemname: itemname,
                                itemid: itemid,
                                itemimg: itemimg,
                                varname: varname,
                                varprice: varprice,
                                paymentMode: paymentMode,
                                cronTime: widget.cronTime,
                                name: widget.name,
                                varmrp: widget.varmrp,
                                varid: widget.varid,
                                brand: brand,
                                deliveriesarry: widget.deliveriesarry,
                                daily: widget.daily,
                                dailyDays: widget.dailyDays,
                                weekend: widget.weekend,
                                weekendDays: widget.weekendDays,
                                weekday: widget.weekday,
                                weekdayDays: widget.weekdayDays,
                                custom: widget.custom,
                                customDays: widget.customDays,
                                weight: widget.weight
                            );
                          }
                          else {
                            Navigation(context, name: Routename.AddressScreen,
                                navigatore: NavigatoreTyp.Push,
                                qparms: {
                                  'addresstype': "new",
                                  'addressid': "",
                                  'delieveryLocation': "",
                                  'latitude': "",
                                  'longitude': "",
                                  'branch': "",
                                  "itemname": itemname,
                                  "itemid": itemid,
                                  "itemimg": itemimg,
                                  "varname": varname,
                                  "varprice": varprice,
                                  "paymentMode": paymentMode,
                                  "cronTime": widget.cronTime,
                                  "name": widget.name,
                                  "varmrp": widget.varmrp,
                                  "varid": widget.varid,
                                  "brand": brand,
                                  "deliveriesarray": widget.deliveriesarry,
                                  "daily": widget.daily,
                                  "dailyDays": widget.dailyDays,
                                  "weekend": widget.weekend,
                                  "weekendDays": widget.weekendDays,
                                  "weekday": widget.weekday,
                                  "weekdayDays": widget.weekdayDays,
                                  "custom": widget.custom,
                                  "alternativeDays" : widget.alternativeDays,
                                  "customDays": widget.customDays,
                                  "weight": widget.weight
                                });
                          }
                        });
                      },
                      child: Column(

                        children: [
                          Row(
                            children: [
                              Container(
                                  child: Text(S .current.address, style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),)
                              ),


                            ],
                          ),
                          SizedBox(height: 10,),
                          Column(
                            children: [

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(
                                    Customername,
                                    style: TextStyle(
                                      color: ColorCodes.blackColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  Spacer(),
                                  Container(

                                    child: Text(
                                      S .of(context).edit,//"CHANGE",
                                      style: TextStyle(
                                          color: ColorCodes.greenColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13.0),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            children: [
                              Flexible(

                                child: Text(
                                  address,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 60.0,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                  ],
                ),
              ),
              GestureDetector(
                onTap: (){
                  setState(() {
                    if(typeselected == S .current.daily){
                    }else{
                    }

                    if(address == ""){
                      Fluttertoast.showToast(msg: S .current.please_add_delivery_address);
                    }else if(SelectedWeek.length == 0 /*&& typeselected != S .current.daily*/){
                      Fluttertoast.showToast(msg: S .current.please_select_repeat_type);
                    }
                    else{
                      double total= /*((_itemCount * TotalAmount!) * (deliveryNum))*/TotalAmount!;
                      List<String> weeks  = [];
                      SelectedWeek.map((e) => weeks.add(e.weekname)).toList();

                      if (paymentMode.toString() == "0") {
                        print("paymentmode........:"+{
                          "addressid":user_data.billingAddress![0].id.toString(),
                          "useraddtype":user_data.billingAddress![0].addressType.toString(),
                          "startDate":datecontroller.text,
                          "endDate": _selectedDate1.toString(),
                          "itemCount": _itemCount.toString(),
                          "deliveries": deliveryNum.toString(),
                          "total": total,
                          "schedule": typeselected,
                          "itemid": /*routeArgs['itemid'].toString()*/widget.itemid,
                          "itemimg": /*routeArgs['itemimg'].toString()*/widget.itemimg,
                          "itemname":itemname.toString(),
                          "varprice":/*routeArgs['varprice'].toString()*/widget.varprice,
                          "varname":/*routeArgs['varname'].toString()*/widget.varname,
                          "address":address.toString(),
                          "paymentMode": paymentMode.toString(),
                          "cronTime": cronTime.toString(),
                          "name": name.toString(),
                          "varid": varid.toString(),
                          "varmrp":/*routeArgs['varmrp'].toString()*/widget.varmrp,
                          "brand" :brand.toString(),
                          "weeklist":(typeselected == S .current.daily)?SelectedDaily.toString():weeks.toString(),
                          "no_of_days":(typeselected == S .current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString()
                        }.toString());
                        Navigation(context, name: Routename.PaymenSubscription, navigatore: NavigatoreTyp.Push,
                            qparms: {
                              "addressid":user_data.billingAddress![0].id.toString(),
                              "useraddtype":user_data.billingAddress![0].addressType.toString(),
                              "startDate":datecontroller.text,
                              "endDate": _selectedDate1.toString(),
                              "itemCount": _itemCount.toString(),
                              "deliveries": deliveryNum.toString(),
                              "total": total,
                              "schedule": typeselected,
                              "itemid": /*routeArgs['itemid'].toString()*/widget.itemid,
                              "itemimg": /*routeArgs['itemimg'].toString()*/widget.itemimg,
                              "itemname":itemname.toString(),
                              "varprice":/*routeArgs['varprice'].toString()*/widget.varprice,
                              "varname":/*routeArgs['varname'].toString()*/widget.varname,
                              "address":address.toString(),
                              "paymentMode": paymentMode.toString(),
                              "cronTime": cronTime.toString(),
                              "name": name.toString(),
                              "varid": varid.toString(),
                              "varmrp":/*routeArgs['varmrp'].toString()*/widget.varmrp,
                              "brand" :brand.toString(),
                              "weeklist":(typeselected == S .current.daily)?SelectedDaily.toString():weeks.toString(),
                              "no_of_days":(typeselected == S .current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString(),
                              "deliveriesarray":widget.deliveriesarry,
                              "daily":widget.daily,
                              "dailyDays":widget.dailyDays,
                              "weekend": widget.weekend,
                              "weekendDays": widget.weekendDays,
                              "weekday": widget.weekday,
                              "weekdayDays":widget.weekdayDays,
                              "custom": widget.custom,
                              "alternativeDays": widget.alternativeDays,
                              "customDays": widget.customDays,
                              "planId": planId,
                              "weight": widget.weight
                            });
                      }else{
                        CreateSubscription();
                      }

                    }
                  });
                },
                child: Container(
                  height: 50,
                  width: (_isWeb && !ResponsiveLayout.isSmallScreen(context))?MediaQuery.of(context).size.width*0.50:MediaQuery.of(context).size.width,

                  decoration: BoxDecoration(
                    color: ColorCodes.primaryColor,
                    border: Border.all(color: ColorCodes.primaryColor),
                    borderRadius: BorderRadius.all(Radius.circular(3)),
                  ),
                  child: Center(
                      child: Text(S .of(context).subscribe,textAlign: TextAlign.center,style: TextStyle(
                          color: ColorCodes.whiteColor, fontSize: 20, fontWeight: FontWeight.bold
                      ),)
                  ),
                ),
              ),
              if (_isWeb) Footer(address: PrefUtils.prefs!.getString("restaurant_address")!),

            ],
          ),
        ),
      );

    }

    Widget _bodyMobile() {
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


      var finalDa;
      if(typeselected == S .current.daily){
        DateTime weekdayOf(DateTime time, int weekday) => time.add(Duration(days: weekday - time.weekday));
        finalDa = now.add(Duration(days: deliveryNum));
        _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDa);
      }
      else {
        initialdate = _selectedDate;
        List<int> availableTime = [];
        for (int i = 0; i < SelectedWeek.length; i++) {
          availableTime.add(SelectedWeek[i].weekname == 'Mon'
              ? 1
              : SelectedWeek[i].weekname == 'Tue'
              ? 2
              : SelectedWeek[i].weekname == 'Wed'
              ? 3
              : SelectedWeek[i].weekname == 'Thu'
              ? 4
              : SelectedWeek[i].weekname == 'Fri' ? 5
              : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);

        }
        try{
          for (int i = 0; i <= deliveryNum; i++) {
            availableTime.map((e) {
              if (e == initialdate.weekday) {
              }
            }).toList();
            initialdate = initialdate.add(Duration(days: 1));
          }
        }catch(e){
        }

        finalDate = initialdate;
        _selectedDate1=DateFormat("yyyy-MM-dd").format(finalDate);
      }
      // var now = new DateTime.now();
      if( now.minute < 10){
        finalTime = "0"+now.minute.toString();
        finalPresentTime = now.hour.toString()+":"+finalTime;
      }else{
        finalTime = now.minute.toString();
        finalPresentTime = now.hour.toString()+":"+finalTime;
      }

      if(now.hour > 12){
        finalPresentTime = now.hour.toString()+":"+finalTime+" "+"PM";
      }else{
        finalPresentTime = "0"+now.hour.toString()+":"+finalTime+" "+"AM";
      }
      var croneTimeUpdated;
      if(cronTime.contains("PM")){
        croneTimeUpdated = int.parse(cronTime[0]) + 12;
      }else{
        croneTimeUpdated = cronTime;
        if(croneTimeUpdated.substring(0,2).toString().contains(":")){
          croneTimeUpdated = int.parse(cronTime[0]);
        }else{
          croneTimeUpdated = int.parse(croneTimeUpdated.substring(0,2));
        }
      }


      return loading /*&& loader*/ ?
      SubscriptionShimmer()
          :checkaddress?
      Container(
        margin:  EdgeInsets.only(left: 20,right: 20, top: 20,bottom: 10),
        color: ColorCodes.whiteColor,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 130,

                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                    Center(
                      child: Container(
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: itemimg,
                          placeholder: (context, url) => Image.asset(
                            Images.defaultProductImg,
                            // width: 100,
                            // height: 100,
                            width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            height: ResponsiveLayout.isSmallScreen(context) ? 100 : ResponsiveLayout.isMediumScreen(context) ? 100 : 100,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            Images.defaultProductImg,
                            // width: 100,
                            // height: 100,
                            width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            height: ResponsiveLayout.isSmallScreen(context) ? 100 : ResponsiveLayout.isMediumScreen(context) ? 100 : 100,
                          ),
                          // width: 100,
                          // height: 100,
                          // fit: BoxFit.cover,
                          width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                          height: ResponsiveLayout.isSmallScreen(context) ? 100 : ResponsiveLayout.isMediumScreen(context) ? 100 : 100,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      brand,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      itemname,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),

                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      varname,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    _price,
                                    /*Features.iscurrencyformatalign?
                                    double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat:
                                    IConstants.currencyFormat + " " + double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),*/
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(width: 2,),
                                  Text(
                                    _mrp,
                                    /* Features.iscurrencyformatalign?
                                    double.parse(varmrp).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat:
                                    IConstants.currencyFormat + " " + double.parse(varmrp).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),*/
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough,
                                        color: Colors.grey),
                                  )
                                ],
                              ),

                            ])),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 80,
                child: Row(
                  children: <Widget>[

                    Text(
                      S .current.quantity_per_day,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),

                    Spacer(),
                    Row(
                      children: [
                        _itemCount!=0?
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(()=>_itemCount==1? _itemCount:_itemCount--);
                          },
                          child: new  Container(
                            decoration: BoxDecoration(
                              color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome,
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                bottom: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                left: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                              ),
                            ),
                            width: 40,
                            height: 40,
                            child:Center(
                              child: Text(
                                "-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorCodes.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  //color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                          ),
                        )
                            :
                        new Container(),
                        Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                bottom: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                left: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                                right: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                              ),
                            ),
                            width: 40,
                            height: 40,
                            child:
                            Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.primaryColor, fontSize: 14, fontWeight: FontWeight.bold),))
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(()=>_itemCount++);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome,
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                bottom: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                right: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                              ),
                            ),
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Text(
                                "+",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorCodes.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  //color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              ),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),

              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<SubscriptionPromoplan>(
                  future: _futureSubscriptionPromoplan,
                  builder: (BuildContext context,AsyncSnapshot<SubscriptionPromoplan> snapshot){
                    final SubscriptionPromoplan = snapshot.data;
                    if (SubscriptionPromoplan!=null)
                      return  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).pick_subscription_option,//"Pick Subscription option",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 10,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: SubscriptionPromoplan.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                      TotalAmount = SubscriptionPromoplan.data![selectedIndex!].grandtotal!;
                                      // TotalAmount = SubscriptionPromoplan.data![selectedIndex!].grandtotal!;
                                      planId = SubscriptionPromoplan.data![selectedIndex!].id!;
                                      if (SubscriptionPromoplan.data![index].isdefault =="1")
                                        deliveryNum = 1000;
                                      else
                                        deliveryNum = int.parse(SubscriptionPromoplan.data![index].days!);
                                    },
                                    child: Column(
                                      children: [

                                        Row(
                                          children: [
                                            //IConstants.currencyFormat+SubscriptionPromoplan.data![index].discountAmount!
                                            SubscriptionPromoplan.data![index].isdefault =="1" ?
                                            Text(SubscriptionPromoplan.data![index].planName!, style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold
                                            ),):
                                            Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Container(

                                                  child: Text(SubscriptionPromoplan.data![index].planName!+/*" plan for "*/S.of(context).plan_for+SubscriptionPromoplan.data![index].days!+" "+
                                                      S.of(context).days_spl/*"days at SPECIAL Price of "*/+IConstants.currencyFormat+SubscriptionPromoplan.data![index].subscriptionamount!.toStringAsFixed(2)+" "+/*" per pack"*/S.of(context).per_pack,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                    maxLines: 3,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Text(/*"*Original price "*/S.of(context).original_price+IConstants.currencyFormat+double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+ /*" per pack"*/S.of(context).per_pack,
                                                  style: TextStyle(
                                                      fontSize: 10,

                                                      color: ColorCodes.lightGreyColor
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                Text(S.of(context).total,//"Total",

                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorCodes.lightGreyColor
                                                  ),
                                                ),
                                                Text(IConstants.currencyFormat+SubscriptionPromoplan.data![index].grandtotal!.toStringAsFixed(2),
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: ColorCodes.lightGreyColor
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10,),
                                            handlerSubscribe(index, selectedIndex!),
                                          ],
                                        ),
                                        SizedBox(height: 10,)
                                      ],
                                    ),
                                  );
                                }),
                          ),
                          SizedBox(height: 10,)
                        ],
                      );
                    else
                      return SizedBox.shrink();

                  },
                ),
              ),
              SubscriptionPromoplanlength > 0? DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0):SizedBox.shrink(),

              SubscriptionPromoplanlength > 0? SizedBox(height: 10,): SizedBox.shrink(),
              WeekSelector(onclick: (weeklist,type){
                SelectedWeek.clear();
                SelectedWeek.addAll(weeklist.where((element) => element.isselected==true));
                typeselected = type;
              },
                  daily: widget.daily,
                  dailyDays: widget.dailyDays,
                  weekday: widget.weekday,
                  weekdayDays: widget.weekdayDays,
                  weekend: widget.weekend,
                  weekendDays: widget.weekendDays,
                  custom: widget.custom,
                  alternativeDays: widget.alternativeDays,
                  customDays: widget.customDays,
                  paymentMode: paymentMode.toString(),
                  selectedDate: _selectedDate
              ),
              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),

              SizedBox(height: 10,),
              deliveriesBackend.length > 0?
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  showDeliveries(context, setState);
                },
                child: Container(

                  child: Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S .current.recharge_or_topup,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        height: 50,
                        padding: EdgeInsets.all(10),
                        /*  decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorCodes.mediumgren
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),*/
                        child: Row(
                          children: [
                            Text(
                              deliveryNum.toString() + " " + S .of(context).deliveries,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.primaryColor),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, color: ColorCodes.primaryColor,size: 16,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ):SizedBox.shrink(),
              deliveriesBackend.length > 0?SizedBox(height: 10,):SizedBox.shrink(),
              deliveriesBackend.length > 0?DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0):SizedBox.shrink(),
              deliveriesBackend.length > 0?SizedBox(height: 10,):SizedBox.shrink(),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  setState(() {
                    _selectDate(context,setState);
                  });
                },
                child:
                Container(
                  height: 50,

                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        S .current.start_dat,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        /* decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorCodes.mediumgren
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),*/
                        child: Row(
                          children: [
                            Text(
                              DateFormat("dd-MM-yyyy").format(_selectedDate),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.primaryColor),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, color: ColorCodes.primaryColor,size: 16,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),

              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  PrefUtils.prefs!.setString("addressbook",
                      "SubscriptionScreen");

                  /* Navigator.of(context).pushReplacementNamed(AddressScreen.routeName,
                      arguments: {
                        'addresstype': "new",
                        'addressid': "",
                        'delieveryLocation': "",
                        'latitude': "",
                        'longitude': "",
                        'branch': "",
                        "itemname": itemname.toString(),
                        "itemid": itemid.toString(),
                        "itemimg":itemimg.toString(),
                        "varname": varname.toString(),
                        "varprice": varprice.toString(),
                        "paymentMode":paymentMode.toString(),
                        "cronTime": *//*routeArgs['cronTime'].toString()*//*widget.cronTime,
                        "name": *//*routeArgs['name'].toString()*//*widget.name,
                        "varmrp":*//*routeArgs['varmrp'].toString()*//*widget.varmrp,
                        "varid": *//*routeArgs['varid'].toString()*//*widget.varid,
                        "brand" :brand.toString()
                      });*/
                  if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                    // _dialogforaddress(context);
                    AddressWeb(context,
                        addresstype: "new",
                        addressid: "",
                        delieveryLocation: "",
                        latitude: "",
                        longitude: "",
                        branch: "",
                        itemname: itemname,
                        itemid: itemid,
                        itemimg: itemimg,
                        varname: varname,
                        varprice: varprice,
                        paymentMode: paymentMode,
                        cronTime: widget.cronTime,
                        name: widget.name,
                        varmrp: widget.varmrp,
                        varid: widget.varid,
                        brand: brand,
                        deliveriesarry: widget.deliveriesarry,
                        daily: widget.daily,
                        dailyDays: widget.dailyDays,
                        weekend: widget.weekend,
                        weekendDays: widget.weekendDays,
                        weekday: widget.weekday,
                        weekdayDays: widget.weekdayDays,
                        custom: widget.custom,
                        customDays: widget.customDays,
                        weight: widget.weight
                    );
                  }
                  else {
                    Navigation(context, name: Routename.AddressScreen,
                        navigatore: NavigatoreTyp.Push,
                        qparms: {
                          'addresstype': "new",
                          'addressid': "",
                          'delieveryLocation': "",
                          'latitude': "",
                          'longitude': "",
                          'branch': "",
                          "itemname": itemname,
                          "itemid": itemid,
                          "itemimg": itemimg,
                          "varname": varname,
                          "varprice": varprice,
                          "paymentMode": paymentMode,
                          "cronTime": widget.cronTime,
                          "name": widget.name,
                          "varmrp": widget.varmrp,
                          "varid": widget.varid,
                          "brand": brand,
                          "deliveriesarray": widget.deliveriesarry,
                          "daily": widget.daily,
                          "dailyDays": widget.dailyDays,
                          "weekend": widget.weekend,
                          "weekendDays": widget.weekendDays,
                          "weekday": widget.weekday,
                          "weekdayDays": widget.weekdayDays,
                          "custom": widget.custom,
                          "alternativeDays" : widget.alternativeDays,
                          "customDays": widget.customDays,
                          "weight": widget.weight
                        });
                  }
                },
                child: Column(
                  children: [
                    Row(

                      children: [
                        Container(
                            child: Text(S .current.address, style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),)
                        ),
                        Spacer(),
                        Container(
                          width: 100,
                          height: 40,
                          decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(3.0),
                              border: Border(
                                top: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                bottom: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                left: BorderSide(width: 1.0, color: Theme.of(context).primaryColor),
                                right: BorderSide(width: 1.0, color: Theme.of(context).primaryColor,),
                              )),
                          child: Center(child:
                          Text(S .current.add_address,style: TextStyle(color: ColorCodes.whiteColor),
                            textAlign: TextAlign.center,)),
                        ),
                      ],
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
          :Container(
        margin:  EdgeInsets.only(left: 20,right: 20, top: 20,bottom: 10),
        height: MediaQuery.of(context).size.height,
        color: ColorCodes.whiteColor,
        child: SingleChildScrollView(

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(

                height: 130,

                child: Row(
                  children: <Widget>[
                    SizedBox(width: 20,),
                    Center(
                      child: Container(
                        width: 100,
                        child: CachedNetworkImage(
                          imageUrl: itemimg,
                          placeholder: (context, url) => Image.asset(
                            Images.defaultProductImg,
                            // width: 100,
                            // height: 100,
                            width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            height: ResponsiveLayout.isSmallScreen(context) ? 100 : ResponsiveLayout.isMediumScreen(context) ? 100 : 100,
                          ),
                          errorWidget: (context, url, error) => Image.asset(
                            Images.defaultProductImg,
                            // width: 100,
                            // height: 100,
                            width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                            height: ResponsiveLayout.isSmallScreen(context) ? 100 : ResponsiveLayout.isMediumScreen(context) ? 100 : 100,
                          ),
                          // width: 100,
                          // height: 100,
                          width: ResponsiveLayout.isSmallScreen(context) ? 106 : ResponsiveLayout.isMediumScreen(context) ? 90 : 100,
                          height: ResponsiveLayout.isSmallScreen(context) ? 100 : ResponsiveLayout.isMediumScreen(context) ? 100 : 100,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      brand,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 5,),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      itemname,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      varname,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: ColorCodes.primaryColor/*Colors.green*/),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  Text(
                                    _price,
                                    /* Features.iscurrencyformatalign?
                                    double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit) + " " + IConstants.currencyFormat:
                                    IConstants.currencyFormat + " " + double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),*/
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  SizedBox(width: 2,),
                                  Text(
                                    _mrp,
                                    /*Features.iscurrencyformatalign?
                                    double.parse(varmrp.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)  + " " + IConstants.currencyFormat:
                                    IConstants.currencyFormat + " " + double.parse(varmrp.toString()).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit),*/
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        decoration: TextDecoration.lineThrough,
                                        color: ColorCodes.emailColor),
                                  )
                                ],
                              ),

                            ])),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Container(
                height: 80,
                child: Row(
                  children: <Widget>[

                    Text(
                      S .current.quantity_per_day,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),

                    Spacer(),
                    Row(
                      children: [
                        _itemCount!=0?
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(()=>_itemCount==1? _itemCount:_itemCount--);
                          },
                          child: new  Container(
                            decoration: BoxDecoration(
                              color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome,
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                bottom: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                left: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                              ),
                            ),
                            width: 40,
                            height: 40,
                            child:Center(
                              child: Text(
                                "-",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorCodes.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16
                                  //color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                          ),
                        )
                            :
                        new Container(),
                        Container(
                            decoration: BoxDecoration(
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                bottom: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                left: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                                right: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome),
                              ),
                            ),
                            width: 40,
                            height: 40,
                            child:
                            Center(child: new Text(_itemCount.toString(),style: TextStyle(color: ColorCodes.primaryColor, fontSize: 14, fontWeight: FontWeight.bold),))
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: (){
                            setState(()=>_itemCount++);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: IConstants.isEnterprise?ColorCodes.whiteColor:ColorCodes.maphome,
                              border: Border(
                                top: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                bottom: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                                right: BorderSide(
                                    width: 1.0, color: IConstants.isEnterprise?ColorCodes.varcolor:ColorCodes.maphome),
                              ),
                            ),
                            width: 40,
                            height: 40,
                            child: Center(
                              child: Text(
                                "+",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: ColorCodes.primaryColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                  //color: Theme.of(context).buttonColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

              ),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),

              SizedBox(height: 10,),
              Container(
                width: MediaQuery.of(context).size.width,
                child: FutureBuilder<SubscriptionPromoplan>(
                  future: _futureSubscriptionPromoplan,
                  builder: (BuildContext context,AsyncSnapshot<SubscriptionPromoplan> snapshot){
                    final SubscriptionPromoplan = snapshot.data;
                    if (SubscriptionPromoplan!=null)
                      return  Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            S.of(context).pick_subscription_option,//"Pick Subscription option",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          SizedBox(height: 20,),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: SubscriptionPromoplan.data!.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        selectedIndex = index;
                                      });
                                      TotalAmount = SubscriptionPromoplan.data![selectedIndex!].grandtotal!;
                                      planId = SubscriptionPromoplan.data![selectedIndex!].id!;
                                      if (SubscriptionPromoplan.data![index].isdefault =="1")
                                        deliveryNum = 1000;
                                      else
                                        deliveryNum = int.parse(SubscriptionPromoplan.data![index].days!);
                                    },
                                    child: Column(
                                      children: [

                                        Row(
                                          children: [
                                            //IConstants.currencyFormat+SubscriptionPromoplan.data![index].discountAmount!
                                            SubscriptionPromoplan.data![index].isdefault =="1" ?
                                            Text(/*"Regular Subscription"*/S.of(context).regular_subscription, style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold
                                            ),):
                                            Container(
                                              width:MediaQuery.of(context).size.width/1.5,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(

                                                    child: Text(SubscriptionPromoplan.data![index].planName!+/*" plan for "*/S.of(context).plan_for+SubscriptionPromoplan.data![index].days! +" "+
                                                        S.of(context).days_spl/*"days at SPECIAL Price of "*/+IConstants.currencyFormat+SubscriptionPromoplan.data![index].subscriptionamount!.toStringAsFixed(2)+" "+
                                                        /*" per pack"*/S.of(context).per_pack,
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight: FontWeight.bold
                                                      ),
                                                      maxLines: 4,
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(/*"*Original price "*/S.of(context).original_price+IConstants.currencyFormat+double.parse(varprice).toStringAsFixed(IConstants.numberFormat == "1"?0:IConstants.decimaldigit)+ /*" per pack"*/S.of(context).per_pack,
                                                    style: TextStyle(
                                                        fontSize: 10,

                                                        color: ColorCodes.lightGreyColor
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Column(
                                              children: [
                                                Text(S.of(context).total,//"Total",

                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.bold,
                                                      color: ColorCodes.blackColor
                                                  ),
                                                ),
                                                Text(IConstants.currencyFormat+SubscriptionPromoplan.data![index].grandtotal!.toStringAsFixed(2),
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: ColorCodes.blackColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(width: 10,),
                                            handlerSubscribe(index, selectedIndex!),
                                          ],
                                        ),
                                        SizedBox(height: 10,)
                                      ],
                                    ),
                                  );
                                }),
                          ),

                        ],
                      );
                    else
                      return SizedBox.shrink();

                  },
                ),
              ),
              SubscriptionPromoplanlength > 0? DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0):SizedBox.shrink(),

              SubscriptionPromoplanlength > 0? SizedBox(height: 10,): SizedBox.shrink(),
              WeekSelector(onclick: (weeklist,type){
                SelectedWeek.clear();
                SelectedWeek.addAll(weeklist.where((element) => element.isselected==true));
                typeselected = type;
              },
                daily: widget.daily,
                dailyDays: widget.dailyDays,
                weekday: widget.weekday,
                weekdayDays: widget.weekdayDays,
                weekend: widget.weekend,
                weekendDays: widget.weekendDays,
                custom: widget.custom,
                alternativeDays: widget.alternativeDays,
                customDays: widget.customDays,
                paymentMode: paymentMode.toString(),
                selectedDate: _selectedDate,
              ),
              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),
              deliveriesBackend.length > 0? GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  showDeliveries(context, setState);
                },
                child: Container(
                  height: 50,
                  child: Row(
                    children: [
                      Text(
                        S .current.recharge_or_topup,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        /* decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorCodes.mediumgren
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),*/
                        child: Row(
                          children: [
                            Text(
                              deliveryNum.toString() + " " + S .of(context).deliveries,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.primaryColor),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, color: ColorCodes.primaryColor,size: 16,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ):SizedBox.shrink(),
              deliveriesBackend.length > 0?SizedBox(height: 10,):SizedBox.shrink(),
              deliveriesBackend.length > 0?DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0):SizedBox.shrink(),
              deliveriesBackend.length > 0? SizedBox(height: 10,):SizedBox.shrink(),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  setState(() {
                    _selectDate(context,setState);
                  });
                },
                child:
                Container(
                  height: 50,

                  child: Row(
                    children: [
                      Text(
                        S .current.start_dat,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.all(10),
                        /* decoration: BoxDecoration(
                          border: Border.all(
                              color: ColorCodes.mediumgren
                          ),

                          borderRadius: BorderRadius.all(Radius.circular(3)),
                        ),*/
                        child: Row(
                          children: [
                            Text(
                              DateFormat("dd-MM-yyyy").format(_selectedDate),
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: ColorCodes.primaryColor),
                            ),
                            SizedBox(width: 5,),
                            Icon(Icons.arrow_forward_ios, color: ColorCodes.primaryColor,size: 16,),
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
              ),
              SizedBox(height: 10,),
              DottedLine(
                  dashColor: ColorCodes.lightgrey,
                  lineThickness: 1.0,
                  dashLength: 2.0,
                  dashRadius: 0.0,
                  dashGapLength: 1.0),
              SizedBox(height: 10,),
              GestureDetector(
                onTap: (){
                  setState(() {
                    PrefUtils.prefs!.setString("addressbook",
                        "SubscriptionScreen");

                    /* Navigator.of(context).pushReplacementNamed(AddressScreen.routeName,
                       arguments: {
                         'addresstype': "new",
                         'addressid': "",
                         'delieveryLocation': "",
                         'latitude': "",
                         'longitude': "",
                         'branch': "",
                         "itemname": itemname.toString(),
                         "itemid": itemid.toString(),
                         "itemimg":itemimg.toString(),
                         "varname": varname.toString(),
                         "varprice": varprice.toString(),
                         "paymentMode":paymentMode.toString(),
                         "cronTime": *//*routeArgs['cronTime'].toString()*//*widget.cronTime,
                         "name": *//*routeArgs['name'].toString()*//*widget.name,
                         "varmrp":*//*routeArgs['varmrp'].toString()*//*widget.varmrp,
                         "varid": *//*routeArgs['varid'].toString()*//*widget.varid,
                         "brand" :brand.toString()
                       });*/
                    if(Vx.isWeb && !ResponsiveLayout.isSmallScreen(context)){
                      // _dialogforaddress(context);
                      AddressWeb(context,
                          addresstype: "new",
                          addressid: "",
                          delieveryLocation: "",
                          latitude: "",
                          longitude: "",
                          branch: "",
                          itemname: itemname,
                          itemid: itemid,
                          itemimg: itemimg,
                          varname: varname,
                          varprice: varprice,
                          paymentMode: paymentMode,
                          cronTime: widget.cronTime,
                          name: widget.name,
                          varmrp: widget.varmrp,
                          varid: widget.varid,
                          brand: brand,
                          deliveriesarry: widget.deliveriesarry,
                          daily: widget.daily,
                          dailyDays: widget.dailyDays,
                          weekend: widget.weekend,
                          weekendDays: widget.weekendDays,
                          weekday: widget.weekday,
                          weekdayDays: widget.weekdayDays,
                          custom: widget.custom,
                          customDays: widget.customDays,
                          weight: widget.weight
                      );
                    }
                    else {
                      Navigation(context, name: Routename.AddressScreen,
                          navigatore: NavigatoreTyp.Push,
                          qparms: {
                            'addresstype': "new",
                            'addressid': "",
                            'delieveryLocation': "",
                            'latitude': "",
                            'longitude': "",
                            'branch': "",
                            "itemname": itemname,
                            "itemid": itemid,
                            "itemimg": itemimg,
                            "varname": varname,
                            "varprice": varprice,
                            "paymentMode": paymentMode,
                            "cronTime": widget.cronTime,
                            "name": widget.name,
                            "varmrp": widget.varmrp,
                            "varid": widget.varid,
                            "brand": brand,
                            "deliveriesarray": widget.deliveriesarry,
                            "daily": widget.daily,
                            "dailyDays": widget.dailyDays,
                            "weekend": widget.weekend,
                            "weekendDays": widget.weekendDays,
                            "weekday": widget.weekday,
                            "weekdayDays": widget.weekdayDays,
                            "custom": widget.custom,
                            "alternativeDays" : widget.alternativeDays,
                            "customDays": widget.customDays,
                            "weight": widget.weight
                          });
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.only(top: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            Customername,
                            style: TextStyle(
                              color: ColorCodes.blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          Spacer(),
                          Container(

                            child: Text(
                              S .of(context).edit,//"CHANGE",
                              style: TextStyle(
                                  color: ColorCodes.greenColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13.0),
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [

                          Flexible(

                            child: Text(
                              address,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 60.0,
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),

            ],
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
        backgroundColor: ColorCodes.whiteColor,
        // backgroundColor: Theme
        //     .of(context)
        //     .backgroundColor,
        body: Column(
          children: <Widget>[
            if(_isWeb && !ResponsiveLayout.isSmallScreen(context))
              Header(false),
            (_isWeb && !ResponsiveLayout.isSmallScreen(context))? _bodyWeb():Flexible(child: _bodyMobile()),

          ],
        ),
        bottomNavigationBar:(_isWeb && !ResponsiveLayout.isSmallScreen(context))?SizedBox.shrink(): bottomNavigationbar(),
      ),
    );
  }


  Widget handlerSubscribe(int i, int selectedIndex) {
    return (selectedIndex == i) ?
    Icon(
        Icons.radio_button_checked_outlined,
        color: ColorCodes.greenColor)
        :
    Icon(
        Icons.radio_button_off_outlined,
        color: ColorCodes.greenColor);

  }

  Future<void> _selectDate( BuildContext context, setState ) async {

    var now = new DateTime.now();
    if( now.minute < 10){
      finalTime = "0"+now.minute.toString();
      finalPresentTime = now.hour.toString()+":"+finalTime;
    }else{
      finalTime = now.minute.toString();
      finalPresentTime = now.hour.toString()+":"+finalTime;
    }

    if(now.hour >= 12){
      finalPresentTime = now.hour.toString()+":"+finalTime+" "+"PM";
    }else{
      if(now.hour.numberOfDigits == 2){
        finalPresentTime = now.hour.toString()+":"+finalTime+" "+"AM";
      }else {
        finalPresentTime = "0" + now.hour.toString() + ":" + finalTime + " " + "AM";
      }
    }
    var croneTimeUpdated;
    if(cronTime.contains("PM")){
      croneTimeUpdated = int.parse(cronTime[0]) + 12;
    }else{
      croneTimeUpdated = cronTime;
      if(croneTimeUpdated.substring(0,2).toString().contains(":")){
        croneTimeUpdated = int.parse(cronTime[0]);
      }else{
        croneTimeUpdated = int.parse(croneTimeUpdated.substring(0,2));
      }
    }

    if(((croneTimeUpdated) - int.parse(finalPresentTime.substring(0,2))) <= 0){
      differenceInTime = (croneTimeUpdated) - int.parse(finalPresentTime.substring(0,2));
    }else{
      differenceInTime = (croneTimeUpdated) - int.parse(finalPresentTime.substring(0,2));
    }

    var trimmedString = cronTime.substring(0, cronTime.lastIndexOf(' '));

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (((croneTimeUpdated) - int.parse(finalPresentTime.substring(0,2))) <= 0)? DateTime.now().add(Duration(days: 2)):_selectedDate != null ? _selectedDate : DateTime.now(), // Refer step 1
      firstDate: (((croneTimeUpdated) - int.parse(finalPresentTime.substring(0,2))) <= 0)? DateTime.now().add(Duration(days: 2)):DateTime.now().add(Duration(days: 1)),
      lastDate: new DateTime(now.year, now.month + 10, now.day),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).primaryColor, // <-- SEE HERE
              onPrimary: Colors.white, // <-- SEE HERE
              onSurface: Colors.black, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  primary: Colors.white,
                  backgroundColor: Theme.of(context).primaryColor// button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate)
      setState(() {

        _selectedDate = picked;
        datecontroller
          ..text = DateFormat("yyyy-MM-dd").format(_selectedDate)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: datecontroller.text.length,
              affinity: TextAffinity.upstream));
      });
  }

  bool _dateAvailable(DateTime day) {
    List<int> weeks = [1, 2, 3, 4, 5, 6, 7];
    List<int> availableTime = [];

    for (int i = 0; i < SelectedWeek.length; i++) {
      availableTime.add(SelectedWeek[i].weekname == 'Mon'
          ? 1
          : SelectedWeek[i].weekname == 'Tue'
          ? 2
          : SelectedWeek[i].weekname == 'Wed'
          ? 3
          : SelectedWeek[i].weekname == 'Thu'
          ? 4
          : SelectedWeek[i].weekname == 'Fri' ? 5
          : SelectedWeek[i].weekname == 'Sat' ? 6 : 7);

    }
    List<int> difference = weeks.toSet().difference(availableTime.toSet()).toList();

    for (int i = 0; i < difference.length; i++) {
      if (day.weekday == difference[i]) {
        return false;
      }
    }
    return true;
  }

  Future<void> _selectDate1( BuildContext context, setState ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      initialDate: DateTime.now().add(Duration(days: 1)),
      lastDate: DateTime(2021, 11, 30),
      selectableDayPredicate: _dateAvailable,

    );
    /*   if (picked != null && picked != _selectedDate1)
      setState(() {
        _selectedDate1 = picked;
        datecontroller1
          ..text = DateFormat("dd-MM-yyyy").format(_selectedDate1)
          ..selection = TextSelection.fromPosition(TextPosition(
              offset: datecontroller1.text.length,
              affinity: TextAffinity.upstream));
      });*/

  }
  Future<void> CreateSubscription() async {
    final routeArgs = ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    // DateFormat("dd-MM-yyyy").format(_selectedDate)
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
    // try {
    // double total= ((_itemCount * double.parse(varprice)) * (deliveryNum));
    List<String> weeks  = [];
    SelectedWeek.map((e) => weeks.add(e.weekname)).toList();
    List items = [];
    String text = weeks.toString().replaceAll('[', "").replaceAll(']', '').replaceAll(' ', '');
    String text1 = SelectedDaily.toString().replaceAll('[', "").replaceAll(']', '').replaceAll(' ', '');
    items.clear();
    items.add({
      "itemId": widget.itemid,
      "varId": varid.toString(),
      "type":  widget.varType,
      "mrp": varmrp,
      "price": varprice,
      "weight": widget.weight,
      "quantity":_itemCount.toString(),
    });
    var resBody = {};
    resBody["user_id"] = PrefUtils.prefs!.getString('apikey');
    resBody["delivery"] = deliveryNum.toString();
    resBody["start_date"] =datecontroller.text;
    resBody["address"] = address.toString();
    resBody["address_type"] = user_data.billingAddress![0].addressType.toString();
    resBody["address_id"] = user_data.billingAddress![0].id.toString();
    resBody["amount"] = TotalAmount.toString();
    resBody["branch"] =PrefUtils.prefs!.getString('branch')??"999";
    resBody["slot"] = typeselected; //name.toString();
    resBody["payment_type"] = (user_data.prepaidModule == "1")? "credits" :"wallet";
    resBody["cron_time"] = cronTime.toString();
    resBody["channel"] = channel;
    resBody["var_id"] = widget.varid;
    resBody["type"] = typeselected;
    resBody["mrp"] = varmrp;
    resBody["price"] = varprice;
    resBody["quantity"] = _itemCount.toString();
    resBody["days"] = (typeselected == S .current.daily) ? text1:text;
    resBody["no_of_days"] = (typeselected == S .current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString();
    resBody["subscriptionType"] = (user_data.prepaidModule == "1")? "2" :widget.paymentMode;
    resBody["planId"] = planId;
    resBody["paymentMode"] = paymentMode.toString();

    for(int i= 0; i< items.length;i++){
      resBody["variation[" + i.toString() + "][itemId]"] = items[i]["itemId"];
      resBody["variation[" + i.toString() + "][varId]"] = items[i]["varId"];
      resBody["variation[" + i.toString() + "][type]"] = items[i]["type"];
      resBody["variation[" + i.toString() + "][mrp]"] = items[i]["mrp"];
      resBody["variation[" + i.toString() + "][price]"] = items[i]["price"];
      resBody["variation[" + i.toString() + "][weight]"] = items[i]["weight"];
      resBody["variation[" + i.toString() + "][quantity]"] = items[i]["quantity"];

    }
    debugPrint(resBody.toString());
    // debugPrint("body...sub..."+{
    //   "user_id":PrefUtils.prefs!.getString('apikey'),
    //   "delivery":deliveryNum.toString(),
    //   "start_date":datecontroller.text,
    //   "address":address.toString(),
    //   "address_type":user_data.billingAddress![0].addressType.toString(),
    //   "address_id":user_data.billingAddress![0].id.toString(),
    //   "amount":TotalAmount.toString(),
    //   "branch":PrefUtils.prefs!.getString('branch')??"999",
    //   "slot":name.toString(),
    //   "payment_type":(user_data.prepaidModule == "1")? "credits" :"wallet",
    //   "cron_time":cronTime.toString(),
    //   "channel":channel,
    //   "var_id": widget.varid,
    //   "type": typeselected,
    //   "mrp":varmrp,
    //   "price":varprice,
    //   "quantity":_itemCount.toString(),
    //   'variation': items.toString(),
    //   "days":(typeselected == S .current.daily) ? text1:text,
    //   "no_of_days":(typeselected == S .current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString(),
    //   "subscriptionType":(user_data.prepaidModule == "1")? "2" :widget.paymentMode,
    //   "planId": planId,
    //   "paymentMode": paymentMode.toString()
    // }.toString());
    final response = await http.post(Api.subscriptionCreate, /*headers: {
      "Content-Type": "application/json",
    },*/ body: resBody
      // {
      //   "user_id":PrefUtils.prefs!.getString('apikey'),
      //   "delivery":deliveryNum.toString(),
      //   "start_date":datecontroller.text,
      //   "address":address.toString(),
      //   "address_type":user_data.billingAddress![0].addressType.toString(),
      //   "address_id":/*user_data.id.toString()*/user_data.billingAddress![0].id.toString(),
      //   "amount":TotalAmount.toString(),
      //   "branch":PrefUtils.prefs!.getString('branch')??"999",
      //   "slot":name.toString(),
      //   "payment_type":(user_data.prepaidModule == "1")? "credits" :"wallet",
      //   "cron_time":cronTime.toString(),
      //   "channel":channel,
      //   "var_id": widget.varid,
      //   "type": typeselected,
      //   "mrp":varmrp,
      //   "price":varprice,
      //   "quantity":_itemCount.toString(),
      //   'variation': items.toString(),
      //   "days":(typeselected == S .current.daily) ? text1:text,
      //   "no_of_days":(typeselected == S .current.daily)?SelectedDaily.length.toString():SelectedWeek.length.toString(),
      //   "subscriptionType":(user_data.prepaidModule == "1")? "2" :widget.paymentMode,
      //   "planId": planId,
      //   "paymentMode": paymentMode.toString()
      // }
    );

    final responseJson = json.decode(response.body);
    debugPrint("response....sub"+responseJson.toString());
    if (responseJson['status'] == 200) {
      // double orderAmount = double.parse(responseJson['amount'].toString());
      var orderId = responseJson['id'];
      debugPrint("orderId..."+orderId.toString());
      PrefUtils.prefs!.setString("subscriptionorderId", responseJson['id'].toString());
      PrefUtils.prefs!.setString("startDate", /*routeArgs['startDate'].toString()*/datecontroller.text);


      Navigation(context, name: Routename.SubscriptionConfirm, navigatore: NavigatoreTyp.Push,
          parms: {
            'orderstatus' : "success",
            'sorderId': PrefUtils.prefs!.getString("subscriptionorderId").toString()
          });




    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
          msg: responseJson['data'].toString(),
          fontSize: MediaQuery.of(context).textScaleFactor *13,
          backgroundColor: Colors.black87,
          textColor: Colors.white);
    }
    // } catch (error) {
    //   throw error;
    // }
  }


}
