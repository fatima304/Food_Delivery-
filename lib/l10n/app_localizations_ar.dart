// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get welcomeBack => 'مرحبًا بعودتك';

  @override
  String get signInSubtitle => 'سجّل الدخول للمتابعة إلى حسابك';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get signUpSubtitle => 'انضم إلينا وابدأ بطلب وجباتك المفضلة';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get haveAccount => 'لديك حساب بالفعل؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get emailAddress => 'البريد الإلكتروني';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get password => 'كلمة المرور';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get resetNotConnected => 'استعادة كلمة المرور غير متاحة حاليًا';

  @override
  String get signingIn => 'جارٍ تسجيل الدخول...';

  @override
  String get creatingAccount => 'جارٍ إنشاء الحساب...';

  @override
  String get termsAgreement => 'أوافق على شروط الخدمة وسياسة الخصوصية';

  @override
  String get acceptTerms => 'يرجى الموافقة على الشروط أولًا';

  @override
  String get orContinueWith => 'أو تابع باستخدام';

  @override
  String get onboardingTitle => 'طعام شهي\nيصلك حتى';

  @override
  String get onboardingAccent => 'باب منزلك';

  @override
  String get onboardingDescription =>
      'اكتشف أفضل المطاعم القريبة منك واستمتع بوجباتك المفضلة في المنزل.';

  @override
  String get getStarted => 'ابدأ الآن  ←';

  @override
  String get onboardingSignIn => 'لديك حساب بالفعل؟ سجّل الدخول';

  @override
  String get signedIn => 'تم تسجيل دخولك بنجاح!';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get dismiss => 'إغلاق';

  @override
  String get sessionError =>
      'تعذر التحقق من جلسة الدخول. يرجى إعادة تشغيل التطبيق.';

  @override
  String get fullNameRequired => 'الاسم الكامل مطلوب';

  @override
  String get firstLetterCapital => 'يجب أن يبدأ الاسم بحرف إنجليزي كبير';

  @override
  String get emailRequired => 'البريد الإلكتروني مطلوب';

  @override
  String get invalidEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';

  @override
  String get passwordRequired => 'كلمة المرور مطلوبة';

  @override
  String get passwordMin => 'يجب ألا تقل كلمة المرور عن 6 أحرف';

  @override
  String get confirmRequired => 'تأكيد كلمة المرور مطلوب';

  @override
  String get passwordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get noUser => 'لا يوجد حساب بهذا البريد الإلكتروني.';

  @override
  String get wrongPassword => 'كلمة المرور غير صحيحة.';

  @override
  String get emailInUse => 'يوجد حساب مسجل بهذا البريد الإلكتروني.';

  @override
  String get firebaseInvalidEmail => 'البريد الإلكتروني غير صحيح.';

  @override
  String get weakPassword => 'كلمة المرور ضعيفة جدًا.';

  @override
  String get userDisabled => 'تم تعطيل هذا الحساب.';

  @override
  String get tooManyAttempts => 'محاولات كثيرة جدًا. حاول مرة أخرى لاحقًا.';

  @override
  String get incorrectCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحين. حاول مجددًا.';

  @override
  String get noInternet =>
      'لا يوجد اتصال بالإنترنت. تحقق من الاتصال وحاول مجددًا.';

  @override
  String get emailUnavailable =>
      'تسجيل الدخول بالبريد غير متاح حاليًا. تواصل مع الدعم.';

  @override
  String get unableRequest => 'تعذر إكمال طلبك. حاول مرة أخرى.';

  @override
  String get networkError => 'خطأ في الشبكة. تحقق من اتصالك بالإنترنت.';

  @override
  String get unexpectedError => 'حدث خطأ غير متوقع. حاول مرة أخرى.';
}
