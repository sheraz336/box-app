import 'package:box_delivery_app/models/qr_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScannedQrModelView extends StatelessWidget{
  final QrModel model;

  const ScannedQrModelView({super.key, required this.model});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scanned ${model.type.name}", style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xffe25e00),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child:  _detailsView(),),
      ),
    );
  }

  Widget _detailsView(){
    switch(model.type){
      case ObjectType.Location:
        return _locationDetailsView();
      case ObjectType.Box:
        return  _boxDetailsView();
      default:
        return  _itemDetailsView();
    }
  }

  Widget _locationDetailsView(){
    final data = model.location!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDataRow("Location ID",data.locationId),
        SizedBox(height: 20),

        _buildDataRow("Location Name",data.name),
        SizedBox(height: 20),

        _buildDataRow("Location Address",data.address),
        SizedBox(height: 20),

        _buildDataRow("Location Type",data.type ),
        SizedBox(height: 20),

        _buildDataRow("Owner Id",data.ownerId ?? "Unavailable"),
        SizedBox(height: 20),

        _buildDataRow("Description",data.description,maxLines: 4),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _boxDetailsView(){
    final box = model.box!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       _buildDataRow("Box ID",box.id),
        SizedBox(height: 20),

        _buildDataRow("Box Name",box.name),
        SizedBox(height: 20),

        _buildDataRow("Location ID",box.locationId ?? "Unavailable"),
        SizedBox(height: 20),

        _buildDataRow("Owner ID",box.ownerId ?? "Unavailable"),
        SizedBox(height: 20),

        _buildDataRow("Description",box.description,maxLines: 4),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _itemDetailsView(){
    final data = model.item!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDataRow("Item ID",data.id),
        SizedBox(height: 20),

        _buildDataRow("Item Name",data.name),
        SizedBox(height: 20),
        _buildDataRow("Value",data.value.toString()),
        SizedBox(height: 20),
        _buildDataRow("Purchase Date",data.purchaseDate),
        SizedBox(height: 20),
        _buildDataRow("Quantity",data.quantity.toString()),
        SizedBox(height: 20),

        _buildDataRow("Owner Id", data.ownerId ?? "Unavailable"),
        SizedBox(height: 20),

        _buildDataRow("Box Id",data.boxId ?? "Unavailable"),
        SizedBox(height: 20),

        _buildDataRow("Location Id",data.locationId ?? "Unavailable"),
        SizedBox(height: 20),

        _buildDataRow("Description",data.description,maxLines: 4),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDataRow(String title,String detail,{int? maxLines = null}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style:
            TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
        SizedBox(height: 8),
        TextFormField(
          enabled: false,
          initialValue: detail,
          maxLines: maxLines,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}