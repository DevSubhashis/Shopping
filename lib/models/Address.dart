class Address {
  int address_id;
  String address_name;
  String person_name;
  String contact_number;
  String street_address;
  int country_id;
  String country_name;
  int state_id;
  String state_name;
  int city_id;
  String city_name;
  int sub_city_id;
  String sub_city_name;
  String union;
  String municipal;
  String zip_code;
  bool is_primary;
  String village;
  String upojila;

  Address(
    this.address_id,
    this.address_name,
    this.person_name,
    this.contact_number,
    this.street_address,
    this.country_id,
    this.country_name,
    this.state_id,
    this.state_name,
    this.city_id,
    this.city_name,
    this.sub_city_id,
    this.sub_city_name,
    this.union,
    this.municipal,
    this.zip_code,
    this.is_primary,
    this.village,
    this.upojila,
  );

  factory Address.fromJson(dynamic json) {
    return Address(
      json['address_id'] as int,
      json['address_name'] as String,
      json['person_name'] as String,
      json['contact_number'] as String,
      json['street_address'] as String,
      json['country_id'] as int,
      json['country_name'] as String,
      json['state_id'] as int,
      json['state_name'] as String,
      json['city_id'] as int,
      json['city_name'] as String,
      json['sub_city_id'] as int,
      json['sub_city_name'] as String,
      json['union'] as String,
      json['municipal'] as String,
      json['zip_code'] as String,
      json['is_primary'] as bool,
      json['village'] as String,
      json['upojila'] as String,
    );
  }

  // static List<Address> getAddresss() {
  //   return <Address>[
  //     Address(
  //       contactNo: '+918017221280',
  //       postCode: '700084',
  //       address: '73, Raupur, Garia, Kolkata-700084',
  //       country: 'India',
  //       city: 'Kolkata',
  //       zilla: 'Kolkata',
  //       upzilla: 'Kolkata',
  //       municipality: 'Garia',
  //       village: '',
  //     ),
  //     Address(
  //       contactNo: '+918017221280',
  //       postCode: '700084',
  //       address: '54, BT Road, Gn Block',
  //       country: 'India',
  //       city: 'Delhi',
  //       zilla: 'Kolkata',
  //       upzilla: 'Kolkata',
  //       municipality: 'Garia',
  //       village: '',
  //     ),
  //     Address(
  //       contactNo: '+918017221280',
  //       postCode: '700084',
  //       address: '7B/8 AB Colony',
  //       country: 'India',
  //       city: 'Mumbai',
  //       zilla: 'Kolkata',
  //       upzilla: 'Kolkata',
  //       municipality: 'Garia',
  //       village: '',
  //     ),
  //   ];
  // }
}
