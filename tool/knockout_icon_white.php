<?php

declare(strict_types=1);

/**
 * Tira o canvas branco dos cantos de APP_ICON_CERTO.png (flood a partir das bordas).
 */

$path = dirname(__DIR__).DIRECTORY_SEPARATOR.'assets'.DIRECTORY_SEPARATOR.'branding'.DIRECTORY_SEPARATOR.'APP_ICON_CERTO.png';
$im = imagecreatefrompng($path);
if ($im === false) {
    fwrite(STDERR, "Não abriu {$path}\n");
    exit(1);
}

$w = imagesx($im);
$h = imagesy($im);
imagealphablending($im, false);
imagesavealpha($im, true);

function isCanvasWhite(int $rgb): bool
{
    $r = ($rgb >> 16) & 0xFF;
    $g = ($rgb >> 8) & 0xFF;
    $b = $rgb & 0xFF;

    return $r >= 242 && $g >= 242 && $b >= 242;
}

$clear = imagecolorallocatealpha($im, 0, 0, 0, 127);
$seen = array_fill(0, $w * $h, false);
$queue = [];
$push = static function (int $x, int $y) use (&$queue, &$seen, $w, $h): void {
    if ($x < 0 || $y < 0 || $x >= $w || $y >= $h) {
        return;
    }
    $i = $y * $w + $x;
    if ($seen[$i]) {
        return;
    }
    $seen[$i] = true;
    $queue[] = [$x, $y];
};

for ($x = 0; $x < $w; $x++) {
    $push($x, 0);
    $push($x, $h - 1);
}
for ($y = 0; $y < $h; $y++) {
    $push(0, $y);
    $push($w - 1, $y);
}

$cleared = 0;
while ($queue !== []) {
    [$x, $y] = array_pop($queue);
    if (!isCanvasWhite(imagecolorat($im, $x, $y))) {
        continue;
    }
    imagesetpixel($im, $x, $y, $clear);
    $cleared++;
    $push($x + 1, $y);
    $push($x - 1, $y);
    $push($x, $y + 1);
    $push($x, $y - 1);
}

$fringe = 0;
for ($pass = 0; $pass < 3; $pass++) {
    $kill = [];
    for ($y = 0; $y < $h; $y++) {
        for ($x = 0; $x < $w; $x++) {
            $c = imagecolorat($im, $x, $y);
            if ((($c >> 24) & 0x7F) >= 64) {
                continue;
            }
            $r = ($c >> 16) & 0xFF;
            $g = ($c >> 8) & 0xFF;
            $b = $c & 0xFF;
            $luma = ($r + $g + $b) / 3;
            if ($luma < 100 && ($r < 220 || $g < 220 || $b < 220)) {
                continue;
            }
            $nearClear = false;
            foreach ([[1, 0], [-1, 0], [0, 1], [0, -1]] as [$dx, $dy]) {
                $nx = $x + $dx;
                $ny = $y + $dy;
                if ($nx < 0 || $ny < 0 || $nx >= $w || $ny >= $h) {
                    continue;
                }
                if (((imagecolorat($im, $nx, $ny) >> 24) & 0x7F) >= 64) {
                    $nearClear = true;
                    break;
                }
            }
            if ($nearClear) {
                $kill[] = [$x, $y];
            }
        }
    }
    foreach ($kill as [$x, $y]) {
        imagesetpixel($im, $x, $y, $clear);
        $fringe++;
    }
}

imagepng($im, $path, 9);
imagedestroy($im);
echo "cantos={$cleared} franja={$fringe} {$path}\n";
