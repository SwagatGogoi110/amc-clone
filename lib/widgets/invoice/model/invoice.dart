import 'package:amcdemo/widgets/invoice/model/Company.dart';
import 'package:amcdemo/widgets/invoice/model/supplier.dart';

class Invoice {
  final InvoiceInfo info;
  final Supplier supplier;
  //final Company company;
  final List<InvoiceItem> items;

  const Invoice({
    required this.info,
    required this.supplier,
    //required this.company,
    required this.items,
  });
}

class InvoiceItem {
  final String description;
  final DateTime date;
  final int quantity;
  final double vat;
  final double unitPrice;

  const InvoiceItem({
    required this.description,
    required this.date,
    required this.quantity,
    required this.vat,
    required this.unitPrice,
  });
}

class InvoiceInfo {
  final String description;
  final String number;
  final DateTime date;
  final DateTime dueDate;

  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
  });
}
