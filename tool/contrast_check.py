"""يتحقق من نسب تباين WCAG للوحة الألوان في الوضعين الفاتح والداكن."""
import sys

def srgb(c):
    c = c / 255
    return c / 12.92 if c <= 0.04045 else ((c + 0.055) / 1.055) ** 2.4

def luminance(hexv):
    hexv = hexv.lstrip('#')
    r, g, b = (int(hexv[i:i+2], 16) for i in (0, 2, 4))
    return 0.2126*srgb(r) + 0.7152*srgb(g) + 0.0722*srgb(b)

def ratio(fg, bg):
    l1, l2 = luminance(fg), luminance(bg)
    hi, lo = max(l1, l2), min(l1, l2)
    return (hi + 0.05) / (lo + 0.05)

LIGHT = {
    'background': '#F4F6FB', 'surface': '#FFFFFF', 'surfaceAlt': '#EBEFF7',
    'primary': '#16255C', 'onPrimary': '#FFFFFF',
    'accent': '#8A5A0B', 'onAccent': '#FFFFFF', 'accentOnBrand': '#F2C766',
    'onSurface': '#0B1120', 'onSurfaceVariant': '#4F5B75',
    'outline': '#D3DBEA',
    'positive': '#047857', 'negative': '#C81E1E',
    'warning': '#B45309', 'info': '#1D4ED8',
    'brandDeep': '#16255C', 'white': '#FFFFFF',
}
DARK = {
    'background': '#0A0F1E', 'surface': '#141B2E', 'surfaceAlt': '#0E1526',
    'primary': '#8FB4FF', 'onPrimary': '#0A0F1E',
    'accent': '#E9B44C', 'onAccent': '#1A1204', 'accentOnBrand': '#F2C766',
    'onSurface': '#E9EDF7', 'onSurfaceVariant': '#9AA8C2',
    'outline': '#2A3550',
    'positive': '#34D399', 'negative': '#F87171',
    'warning': '#FBBF24', 'info': '#8FB4FF',
    'brandDeep': '#16255C', 'white': '#FFFFFF',
}

# (foreground, background, minimum, label)
def cases(p):
    return [
        ('onSurface',        'surface',    4.5, 'نص أساسي على البطاقة'),
        ('onSurface',        'background', 4.5, 'نص أساسي على الخلفية'),
        ('onSurfaceVariant', 'surface',    4.5, 'نص ثانوي على البطاقة'),
        ('onSurfaceVariant', 'background', 4.5, 'نص ثانوي على الخلفية'),
        ('primary',          'surface',    4.5, 'لون العلامة كنص/أيقونة'),
        ('primary',          'background', 4.5, 'لون العلامة على الخلفية'),
        ('onPrimary',        'primary',    4.5, 'نص داخل زر ممتلئ'),
        ('accent',           'surface',    4.5, 'لون التمييز كنص/رقم'),
        ('accent',           'background', 4.5, 'لون التمييز على الخلفية'),
        ('onAccent',         'accent',     4.5, 'نص فوق لون التمييز'),
        ('accentOnBrand',    'brandDeep',  4.5, 'التمييز فوق تدرّج العلامة'),
        ('white',            'brandDeep',  4.5, 'نص أبيض فوق تدرّج العلامة'),
        ('positive',         'surface',    4.5, 'قيمة موجبة'),
        ('negative',         'surface',    4.5, 'قيمة سالبة'),
        ('warning',          'surface',    4.5, 'تحذير'),
        ('info',             'surface',    4.5, 'معلومة'),
        ('positive',         'surfaceAlt', 3.0, 'موجب على سطح بديل (كبير)'),
        ('negative',         'surfaceAlt', 3.0, 'سالب على سطح بديل (كبير)'),
        ('outline',          'surface',    1.3, 'حد فاصل مرئي'),
        ('outline',          'background', 1.2, 'حد على الخلفية'),
    ]

failures = 0
for name, p in (('LIGHT', LIGHT), ('DARK', DARK)):
    print(f'\n=== {name} ===')
    for fg, bg, minimum, label in cases(p):
        r = ratio(p[fg], p[bg])
        ok = r >= minimum
        if not ok:
            failures += 1
        print(f'  {"PASS" if ok else "FAIL"}  {r:5.2f}:1  (>= {minimum})  {label}  [{fg} on {bg}]')

print(f'\n{"ALL PASS" if failures == 0 else str(failures) + " FAILURES"}')
sys.exit(1 if failures else 0)
