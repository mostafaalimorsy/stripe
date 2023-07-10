import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe/controller/cubit/status.dart';

class PaymentCubit extends Cubit<PaymentStates> {
  PaymentCubit() : super(InitialPaymentStates());
}
