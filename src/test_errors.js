
// خطأ 1: نص غير مغلق وانتقل لسطر جديد بدون \ (المثال المذكور في ورقة المشروع)
 var s = 'abc;
 var t = 5;

 var

// خطأ 2: نص بدأ بـ ' وانتهى بـ "
 var errStr = 'mismatched quote";

// خطأ 3: رقم غير صالح ملتصق بأحرف أو بادئة خاطئة
 var errNum1 = 123abc;
 var errNum2 = 0xG;
 var errNum3 = 0o89;
 var errNum4 = 12.34n;
#!/usr/bin/env node
// خطأ 4: محارف غير معروفة في اللغة
 var errChar = 5 @ 10;