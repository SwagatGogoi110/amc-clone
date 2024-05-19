import 'package:amcdemo/widgets/invoice/model/Company.dart';
import 'package:amcdemo/widgets/invoice/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  //final Supplier supplier;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    //required this.supplier,
    required this.items,
  });
}

class InvoiceItem {
  final String description;
  final String additionalDesc;
  final String date;
  final String under;
  final double unitPrice;
  //final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.additionalDesc,
    required this.date,
    required this.under,
    required this.unitPrice,
    //required this.unitPrice,
  });
}

class InvoiceInfo {
  final String? number;
  final String date;
  final String chassisNum;
  final String vMake;
  final String vModel;
  final String kmDrive;
  final String? workshop;


  const InvoiceInfo({
    required this.number,
    required this.date,
    required this.chassisNum,
    required this.vMake,
    required this.vModel,
    required this.kmDrive,
    required this.workshop,
  });
}
