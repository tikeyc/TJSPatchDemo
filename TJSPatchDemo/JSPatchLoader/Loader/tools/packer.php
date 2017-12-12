<?php 

const PRIVATE_KEY = <<<EOD
-----BEGIN RSA PRIVATE KEY-----
MIICXQIBAAKBgQC/+7Bq4i8Xf86Vv1MwnH9CcvRehsG0Bndtzir8TdmDy5ihW0Zu
yAie5IIb8uLP2SlnHVfFd6B/fGibcUtvOt0x/cZjXFQ5j3eHxSUn1aQvJnCIhisR
gC5dtE1xAI/GndP/68B6MSfLaSWKdIxmE+b4en6nhcFutuLZtSjg0zFX2wIDAQAB
AoGBAIYEN5nVPNRlppuITJVRmdCUGJxn6441OWeQlRc9bQsAtBJnehpZTxNEJsNF
4SkAylMt+5hgMszr1sYz51nFOKS4oQV6WAfQtwahQ5Ypbc8jv/qNYeYkysXIBR/h
9RpRhe6obrC8e0AoFdf/TOSd2YsBV025NKy+9MH4ZaKhYhChAkEA33a/2+ta+g3l
i94AvLdSqzl8pJIg7cUDfT081QfZuBnWQ++rjKp4P3T06dx90ZEUejfFfq1uMgJs
Vi/1T6GS6wJBANvvjD/MWv1jXr+hdc0v2bPjXDqFxuWA2IMpEmTFHQXeJ1CA0hJf
leENJJuFD6HcE9naz9PRnrI6N5ElY6YjstECQATMKNxQ1jguGjKBhqSGjwjMCCgE
Vx6jryp+KRMtwvfX3ijBOX6gnkpGeYeXyz+3jKf/EIdis83xDWBgUTTvdBcCQBWe
ZGDZC5Cgte2MR3IV5AZksOonwDdLBP1PijlRjtrGzYKCRyP7NVZb3l9TIwg8A8+E
TK17i2flhRTFYhgwpiECQQCvkZgx4dakkSnhNbLaZGX7Nd4RdQqv8f2FkbRT7CD7
4FjGQ8ML38rYwX6DbXTBjIEJ8PyiIJbW3jCx4PZl2+Lk
-----END RSA PRIVATE KEY-----
EOD;

$files = "";
$zipFile = "script.zip";
$finalFile = "v1";
for ($i = 1; $i < count($argv); $i ++) {
    if ($argv[$i] == '-o') {
        $finalFile = $argv[$i + 1];
        break;
    }
    $files .= $argv[$i] . " ";
}

if (!empty($files)) {

    //compress files
    echo system("zip $zipFile $files"); 

    //get and encrypt zip file's md5
    $zipFileMD5 = md5_file($zipFile);
    $private_key = openssl_pkey_get_private(PRIVATE_KEY);
    $ret = openssl_private_encrypt($zipFileMD5, $encrypted, $private_key);

    if (!$ret || empty($encrypted)) {
        unlink($zipFile);
        echo "fail to encrypt file md5";
    }

    $md5File = "key";
    file_put_contents($md5File, $encrypted);

    //pack script zip file and md5 file to final zip file
    echo system("zip $finalFile $zipFile $md5File"); 

    unlink($md5File);
    unlink($zipFile);
}
