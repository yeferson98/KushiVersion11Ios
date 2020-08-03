import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:kushi/bussiness/model/business.model.dart';
import 'package:kushi/bussiness/model/time.attention.model.dart';
import 'package:kushi/bussiness/repository/business.respository.dart';
import 'package:kushi/configs/intercept.App.dart';
import 'package:kushi/configs/ioc.dart';
import 'package:kushi/shops/bloc/shop.bloc.dart';
import 'package:kushi/shops/model/product.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/CreditCard_model.dart';
import 'package:kushi/shops/ui/payment/pages/model/mediopago.model.dart';
import 'package:kushi/shops/ui/payment/pages/model/quntityPayment.dart';
import 'package:kushi/shops/ui/payment/pages/payment.message.finish.dart';
import 'package:kushi/shops/ui/payment/widgets/time.delivery.dart';
import 'package:kushi/shops/ui/screens/cartShop.dart';
import 'package:kushi/user/model/user.model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CreditCardsWidget extends StatefulWidget {
  CardInfo cardInfo;
  UserModel userModel;
  Business business;
  PaymetProductDetail payment;
  MedioPago methodpayment;
  CreditCardsWidget(
      {Key key,
      @required this.cardInfo,
      @required this.userModel,
      @required this.payment,
      @required this.business,
      @required this.methodpayment})
      : super(key: key);

  @override
  _CreditCardsWidgetState createState() => _CreditCardsWidgetState();
}

class _CreditCardsWidgetState extends State<CreditCardsWidget> {
  String cardNumber = "**** **** **** ****";
  String expiryDate = "00/00";
  String cardHolderName;
  String cvvCode = "000";
  bool isCvvFocused = false;
  bool isTimeDelivery = false;
  bool butonPayment = false;
  Color themeColor;
  ShopBloc shopBloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _formKeyDelivery = GlobalKey<FormState>();
  CreditCardModel creditCardModel;
  Future<List<TimeAttentionBusiness>> timeBusiness;
  final MaskedTextController _cardNumberController =
      MaskedTextController(mask: '0000 0000 0000 0000');
  final TextEditingController _expiryDateController =
      MaskedTextController(mask: '00/00');
  final TextEditingController _cardHolderNameController =
      TextEditingController();
  final TextEditingController _emailUserController = TextEditingController();
  final TextEditingController _cvvCodeController =
      MaskedTextController(mask: '000');
  final TextEditingController _fechaDeliveryController =
      new TextEditingController();
  final TextEditingController _horaDeliveryController =
      new TextEditingController();
  final formatDateU = DateFormat("yyyy-MM-dd");
  final formatTime = DateFormat("HH:mm");
  FocusNode cvvFocusNode = FocusNode();
  BusinessRepository _serviceKushiAPI;
  TimedateEnd dateresultDelivery;
  @override
  void initState() {
    _serviceKushiAPI = Ioc.get<BusinessRepository>();
    getTimeBusiness();
    super.initState();
    creditCardModel = CreditCardModel();
  }

  @override
  Widget build(BuildContext context) {
    shopBloc = BlocProvider.of(context);
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Container(
              width: 259,
              height: 165,
              decoration: BoxDecoration(
                color: widget.cardInfo.leftColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 12),
              width: 275,
              height: 177,
              decoration: BoxDecoration(
                color: widget.cardInfo.leftColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 25),
              width: 300,
              height: 195,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    widget.cardInfo.leftColor,
                    widget.cardInfo.rightColor,
                  ],
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 21),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    imageCard(),
                    /* Image.asset(
                      'img/visa.png',
                      height: 22,
                      width: 70,
                    ),*/
                    SizedBox(height: 20),
                    Text(
                      'NUMERO DE TARGETA',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .merge(TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 5),
                    Text(
                      cardNumber,
                      style: Theme.of(context).textTheme.bodyText2.merge(
                          TextStyle(letterSpacing: 1.4, color: Colors.white)),
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'VENCE FIN DE',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .merge(TextStyle(color: Colors.white)),
                        ),
                        Text(
                          'CVV',
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .merge(TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          expiryDate,
                          style: Theme.of(context).textTheme.bodyText2.merge(
                              TextStyle(
                                  letterSpacing: 1.4, color: Colors.white)),
                        ),
                        Text(
                          cvvCode,
                          style: Theme.of(context).textTheme.bodyText2.merge(
                              TextStyle(
                                  letterSpacing: 1.4, color: Colors.white)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        FutureBuilder<List<TimeAttentionBusiness>>(
            future: timeBusiness,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data == null) {
                  return Center(
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Text('Revisa tu conección a internet'),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              IconButton(
                                  icon: Icon(Icons.refresh),
                                  onPressed: () {
                                    getTimeBusiness();
                                  }),
                              Text('Reintentar')
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                } else {
                  if (snapshot.data.length == 0) {
                    butonPayment = false;
                    return Text('empresa sin horario');
                  } else {
                    butonPayment = true;
                    return TimeDelivery(
                      business: widget.business,
                      listHours: snapshot.data,
                      formKey: _formKeyDelivery,
                      onChangedHoursDelivery: (value) {
                        dateresultDelivery = value;
                      },
                    );
                  }
                }
              } else {
                return Text('Prosesando');
              }
            }),
        Theme(
          data: ThemeData(
            primaryColor: Theme.of(context).primaryColorDark,
            primaryColorDark: Theme.of(context).primaryColorDark,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                  child: TextFormField(
                    controller: _cardHolderNameController,
                    cursorColor: Theme.of(context).primaryColorDark,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.people),
                      border: OutlineInputBorder(),
                      labelText: 'Titular de la targeta',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => creditCardModel.cardHolderName = value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 16, top: 16, right: 16),
                  child: TextFormField(
                    controller: _cardNumberController,
                    cursorColor: Theme.of(context).primaryColorDark,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(),
                      labelText: 'Número de Trageta',
                      hintText: 'xxxx xxxx xxxx xxxx',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => creditCardModel.cardNumber = value,
                    onChanged: (String text) {
                      if (text.length < 20) {
                        setState(() {
                          cardNumber = text;
                        });
                      } else {
                        setState(() {
                          cardNumber = cardNumber;
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                  child: TextFormField(
                    controller: _expiryDateController,
                    cursorColor: Theme.of(context).primaryColorDark,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    decoration: InputDecoration(
                        icon: Icon(Icons.date_range),
                        border: OutlineInputBorder(),
                        labelText: 'Fecha de Vencimiento',
                        hintText: 'MM/YY'),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => creditCardModel.expiryDate = value,
                    onChanged: (String text) {
                      if (text.length < 6) {
                        setState(() {
                          expiryDate = text;
                        });
                      } else {
                        setState(() {
                          expiryDate = expiryDate;
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                  child: TextFormField(
                    focusNode: cvvFocusNode,
                    controller: _cvvCodeController,
                    cursorColor: Theme.of(context).primaryColorDark,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.credit_card),
                      border: OutlineInputBorder(),
                      labelText: 'CVV',
                      hintText: 'XXX',
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    onSaved: (value) => creditCardModel.cvvCode = value,
                    onChanged: (String text) {
                      if (text.length < 4) {
                        setState(() {
                          cvvCode = text;
                        });
                      } else {
                        setState(() {
                          cvvCode = cvvCode;
                        });
                      }
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  margin: const EdgeInsets.only(left: 16, top: 8, right: 16),
                  child: TextFormField(
                    controller: _emailUserController,
                    cursorColor: Theme.of(context).primaryColorDark,
                    style: TextStyle(
                      color: Theme.of(context).primaryColorDark,
                    ),
                    decoration: InputDecoration(
                      icon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelText: 'Correo Electrónico',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onSaved: (value) => creditCardModel.email = value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo requerido';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'Costo del producto:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Costo del envio:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Descuento:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'Total:',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          'S/.${widget.payment.costoProd.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'S/.${widget.payment.costoEnv.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'S/.${widget.payment.descuento.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          'S/.${widget.payment.total.toStringAsFixed(2)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(height: 10),
                Stack(
                  fit: StackFit.loose,
                  alignment: AlignmentDirectional.centerEnd,
                  children: <Widget>[
                    SizedBox(
                      width: 320,
                      child: FlatButton(
                        onPressed: () {
                          if (butonPayment == true) {
                            getStcok();
                          } else {
                            _showAlertDialogMessage(
                                'Error empresa sin horario de delivery.');
                          }
                        },
                        padding: EdgeInsets.symmetric(vertical: 14),
                        color: Theme.of(context).accentColor,
                        shape: StadiumBorder(),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Confirmar Pago',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'S/.${widget.payment.total.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headline4.merge(
                            TextStyle(color: Theme.of(context).primaryColor)),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  void getTimeBusiness() {
    timeBusiness = _serviceKushiAPI
        .fetchTimeBusinesRepository(widget.business.uid.toString());
  }

  Widget imageCard() {
    if (widget.cardInfo.cardCompany == "visa") {
      return Container(
        color: Colors.white,
        child: SvgPicture.asset(
          widget.cardInfo.cardCategory,
          height: 22,
          width: 70,
        ),
      );
    } else {
      return SvgPicture.asset(
        widget.cardInfo.cardCategory,
        height: 22,
        width: 70,
      );
    }
  }

  void getStcok() {
    List<ProductModel> getproduListInCart = new List<ProductModel>();
    getproduListInCart = Provider.of<InterceptApp>(context).lista();
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      shopBloc.getStockExistBloc(getproduListInCart).then(
        (value) {
          if (value == null) {
            errorinternet();
          } else {
            if (value.length > 0) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    Future<void>.delayed(const Duration(seconds: 2))
                      ..then<void>((_) {
                        Navigator.of(context).pop();
                        Provider.of<InterceptApp>(context)
                            .removeProductStockSop(value)
                            .then((value) {
                          if (value == true) {
                            suceessRemoveProductCart();
                          }
                        });
                      });
                    return Center(
                      child: Container(
                        width: 250.0,
                        height: 220.0,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          children: <Widget>[
                            Image.asset(
                              "assets/img/gifproducts.gif",
                              height: 100,
                              width: 100,
                            ),
                            Text(
                              "Removiendo algunos productos del carrito, ya que  el stock se agoto",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.black,
                                  fontSize: 15),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else {
              //grabar producto
              getproduListInCart = Provider.of<InterceptApp>(context).lista();
              shopBloc
                  .saveShopProductBloc(
                      widget.methodpayment.cod.toString(),
                      '2',
                      '1',
                      widget.cardInfo.id.toString(),
                      widget.business,
                      dateresultDelivery,
                      widget.userModel,
                      widget.payment,
                      getproduListInCart)
                  .then(
                    (value) => {
                      if (value.status == null)
                        {errorSaveProduct()}
                      else
                        {
                          if (value.status == 401 ||
                              value.status == 002 ||
                              value.status == 500 ||
                              value.status == 422 ||
                              value.status == 403)
                            {errorSaveProduct()}
                          else if (value.error == false)
                            {saveProductShop()}
                          else if (value.error == true)
                            {errorSaveProduct()}
                        }
                    },
                  );
            }
          }
        },
      );
    }
  }

  void suceessRemoveProductCart() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future<void>.delayed(const Duration(seconds: 2))
          ..then<void>((_) {
            Navigator.of(context).pop();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CartWidget(
                  supermarkets: widget.business,
                  userData: widget.userModel,
                ),
              ),
            );
          });
        return Center(
          child: Container(
            width: 250.0,
            height: 230.0,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/img/giflStock.gif",
                  height: 150,
                  width: 150,
                ),
                Text(
                  "Termidado. redireccionando al carrito...",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 15),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void saveProductShop() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) {
        Future<void>.delayed(const Duration(seconds: 2))
          ..then<void>((_) {
            Provider.of<InterceptApp>(context).removeAllProductCart();
            removeNotePreference();
            Navigator.of(context).pop();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext contex) => BlocProvider(
                  child: PaymentSuccessfulWidget(
                      business: widget.business,
                      payment: widget.payment,
                      userModel: widget.userModel,
                      dateresultDelivery: dateresultDelivery),
                  bloc: ShopBloc(),
                ),
              ),
            );
          });
        return Center(
          child: Container(
            width: 250.0,
            height: 210.0,
            decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: <Widget>[
                Image.asset(
                  "assets/img/gifproducts.gif",
                  height: 100,
                  width: 100,
                ),
                Text(
                  'Compra realizada con éxito. \n ' + 'redireccionando...',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      decoration: TextDecoration.none,
                      color: Colors.black,
                      fontSize: 15),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void errorSaveProduct() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            'Error al Procesar Compra',
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void errorinternet() {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            'Sin acceso a internet, revice su conexión',
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('Aceptar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAlertDialogMessage(String message) {
    showDialog(
      context: context,
      builder: (buildcontext) {
        return CupertinoAlertDialog(
          title: Text(
            message,
            style: TextStyle(fontSize: 12),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                'Aceptar',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void removeNotePreference() async {
    SharedPreferences _preferences = await SharedPreferences.getInstance();
    _preferences.remove('notePaymentUser');
  }
}
