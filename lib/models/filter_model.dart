class FilterModel{
  String name;
  String id;
  bool? isApplied;
  int? selectedItem;
  FilterModel({required this.name,required this.id, this.selectedItem=-1,this.isApplied=false});

}