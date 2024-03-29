import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meroupachar/src/data/model/country_model.dart';
import 'package:meroupachar/src/data/services/country_services.dart';


final getAddressList = FutureProvider.family((ref,String token) => AddressList().getAddress(token));


class AddressList {
  Map<int, List<String>> combinedData = {};

  Future<List<String>> getAddress(String token) async {
    List<DistrictModel> districts = await CountryService().getAllDistrict(token: token);

    List<MunicipalityModel> municipalities = await CountryService().getAllMunicipality(token: token);

    // Combine data into one map based on districtId
    districts.forEach((district) {
      int districtId = district.districtId; // Use the actual property names from DistrictModel
      String districtName = district.districtName;
      List<String> municipalityNames = municipalities
          .where((municipality) => municipality.districtId == districtId)
          .map((municipality) => '${municipality.municipalityName}($districtName)')
          .toList();

      combinedData[districtId] = municipalityNames;
    });

    // Flatten the combined data into a list of strings
    List<String> combinedList = combinedData.values.expand((data) => data).toList();

    return combinedList;

    //Print the combined list
    combinedList.forEach((item) {
      print(item);
    });
  }
}
