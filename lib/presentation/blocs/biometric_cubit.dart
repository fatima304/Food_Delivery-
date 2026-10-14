import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:food_delivery/data/datasources/biometric_datasource.dart';

import 'biometric_state.dart';

// Cubit for managing biometric authentication state
class BiometricCubit extends Cubit<BiometricState> {
  final BiometricDataSource _dataSource;

  BiometricCubit(this._dataSource) : super(const BiometricState());

  // Integration with local_auth package through data source
  // Prevents duplicate authentication attempts by checking current state
  Future<void> authenticate() async {
    if (state.status == BiometricStatus.loading) return;

    emit(const BiometricState(status: BiometricStatus.loading));

    try {
      final isAuthenticated = await _dataSource.authenticate();

      if (isAuthenticated) {
        emit(const BiometricState(status: BiometricStatus.success));
      } else {
        emit(
          const BiometricState(
            status: BiometricStatus.failure,
            errorMessage: 'biometricFailed',
          ),
        );
      }
    } catch (e) {
      emit(
        const BiometricState(
          status: BiometricStatus.failure,
          errorMessage: 'authenticate',
        ),
      );
    }
  }
}
