
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medical_app/src/presentation/common/common_state.dart';
import 'package:medical_app/src/presentation/register/domain/register_service.dart';

final organizationRegister = StateNotifierProvider<RegisterNotifier, CommonState>((ref) => RegisterNotifier(CommonState.empty()));



class RegisterNotifier extends StateNotifier<CommonState>{
  RegisterNotifier(super.state);


  Future<void> organizationRegister({
    required String orgName,
    required int pan,
    required String email,
    required String mobileNo,
    required int natureId,
    required String password

  }) async {
    state = const CommonState.loading();
    final response = await RegisterService().orgRegister(
        orgName: orgName, pan: pan, email: email, mobileNo: mobileNo, natureId: natureId, password: password);
    response.fold((l) {
      state = CommonState.error(l);
    }, (r) {
      state = CommonState.success(r);
    });
  }

}