/// اتجاه الرؤية — يقرّر لونها ورمزها، لا صياغتها.
enum InsightTone { positive, negative, neutral }

/// ملاحظة محسوبة عن عمل المستخدم ودخله.
///
/// تختلف عن تنبيهات `SmartInsightsService`: تلك تنبّه على حالة قائمة الآن
/// (دوام لم يُغلق، إنفاق تجاوز حدّه)، وهذه تقارن فترة بفترة وجهة بجهة.
class PersonalInsight {
  const PersonalInsight({
    required this.message,
    required this.tone,
  });

  /// نصّ عربي جاهز للعرض، يحمل الرقم داخله.
  final String message;

  final InsightTone tone;
}
