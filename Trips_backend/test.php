<?php

// تكوين المفتاح الخاص
$config = [
    "digest_alg" => "sha256",
    "private_key_bits" => 1024,
    "private_key_type" => OPENSSL_KEYTYPE_RSA,
];

// إنشاء مفتاح خاص جديد
$res = openssl_pkey_new($config);

// التحقق من أن المفتاح تم إنشاؤه بنجاح
if ($res === false) {
    echo "فشل في إنشاء المفتاح";
} else {
    // تصدير المفتاح الخاص إلى ملف
    openssl_pkey_export_to_file($res, 'private_key.pem', null, $config);
    echo "تم تصدير المفتاح الخاص إلى 'private_key.pem'.\n";

    // الحصول على تفاصيل المفتاح للحصول على المفتاح العمومي
    $details = openssl_pkey_get_details($res);
    if ($details === false) {
        echo "فشل في الحصول على تفاصيل المفتاح";
    } else {
        // تخزين المفتاح العام في ملف
        file_put_contents('public_key.pem', $details['key']);
        echo "تم تخزين المفتاح العام في 'public_key.pem'.\n";
    }
}

?>
