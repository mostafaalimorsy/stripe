abstract class PaymentStates {}

class InitialPaymentStates extends PaymentStates {}

class MakePaymentStateLoading extends PaymentStates {}

class MakePaymentStateSuccess extends PaymentStates {}

class MakePaymentStateError extends PaymentStates {}

class CreatePaymentStateLoading extends PaymentStates {}

class CreatePaymentStateSuccess extends PaymentStates {}

class CreatePaymentStateError extends PaymentStates {}

class DisplayPaymentStateLoading extends PaymentStates {}

class DisplayPaymentStateSuccess extends PaymentStates {}

class DisplayPaymentStateError extends PaymentStates {}
