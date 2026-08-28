<?php

declare(strict_types=1);

/**
 * Gera o ícone e as marcas do splash MindVibe (ondas concêntricas = mente + vibe).
 */

$out = dirname(__DIR__).DIRECTORY_SEPARATOR.'assets'.DIRECTORY_SEPARATOR.'branding';
if (!is_dir($out) && !mkdir($out, 0777, true) && !is_dir($out)) {
    fwrite(STDERR, "Não foi possível criar {$out}\n");
    exit(1);
}

const TEAL = [0x2F, 0x5D, 0x56];
const CREAM = [0xF8, 0xF4, 0xEE];
const SCALE = 2;

function canvas(int $size, ?array $background): GdImage
{
    $img = imagecreatetruecolor($size, $size);
    imagesavealpha($img, true);
    imagealphablending($img, false);
    if ($background === null) {
        $fill = imagecolorallocatealpha($img, 0, 0, 0, 127);
    } else {
        $fill = imagecolorallocate($img, $background[0], $background[1], $background[2]);
    }
    imagefilledrectangle($img, 0, 0, $size - 1, $size - 1, $fill);
    imagealphablending($img, true);

    return $img;
}

function rgb(GdImage $img, array $c): int
{
    return imagecolorallocate($img, $c[0], $c[1], $c[2]);
}

function downscale(GdImage $src, int $size): GdImage
{
    $dst = canvas($size, null);
    imagealphablending($dst, false);
    imagecopyresampled($dst, $src, 0, 0, 0, 0, $size, $size, imagesx($src), imagesy($src));
    imagealphablending($dst, true);

    return $dst;
}

function save(GdImage $img, string $path): void
{
    imagepng($img, $path, 9);
    echo $path.' ('.imagesx($img).'x'.imagesy($img).")\n";
}

function fillCircle(GdImage $img, float $cx, float $cy, float $radius, int $color): void
{
    $d = (int) round($radius * 2);
    imagefilledellipse($img, (int) round($cx), (int) round($cy), $d, $d, $color);
}

function blitRing(GdImage $dst, float $cx, float $cy, float $outer, float $inner, int $color): void
{
    $w = imagesx($dst);
    $h = imagesy($dst);
    $tmp = imagecreatetruecolor($w, $h);
    imagealphablending($tmp, false);
    imagesavealpha($tmp, true);
    $clear = imagecolorallocatealpha($tmp, 0, 0, 0, 127);
    imagefilledrectangle($tmp, 0, 0, $w - 1, $h - 1, $clear);
    imagealphablending($tmp, true);
    fillCircle($tmp, $cx, $cy, $outer, $color);
    imagealphablending($tmp, false);
    fillCircle($tmp, $cx, $cy, $inner, $clear);
    imagealphablending($dst, true);
    imagecopy($dst, $tmp, 0, 0, 0, 0, $w, $h);
    imagedestroy($tmp);
}

function drawRipples(GdImage $img, array $ink, ?array $knockout = null): void
{
    $size = imagesx($img);
    $cx = $size / 2;
    $cy = $size / 2;
    $maxR = $size * 0.30;
    $stroke = $maxR * 0.11;
    $gap = $maxR * 0.15;
    $centerR = $maxR * 0.18;
    $fg = rgb($img, $ink);
    $radii = [];
    $r = $centerR + $gap;
    for ($i = 0; $i < 3; $i++) {
        $radii[] = $r;
        $r += $stroke + $gap;
    }

    if ($knockout !== null) {
        $bg = rgb($img, $knockout);
        for ($i = count($radii) - 1; $i >= 0; $i--) {
            fillCircle($img, $cx, $cy, $radii[$i] + $stroke, $fg);
            fillCircle($img, $cx, $cy, $radii[$i], $bg);
        }
        fillCircle($img, $cx, $cy, $centerR, $fg);

        return;
    }

    for ($i = count($radii) - 1; $i >= 0; $i--) {
        blitRing($img, $cx, $cy, $radii[$i] + $stroke, $radii[$i], $fg);
    }
    fillCircle($img, $cx, $cy, $centerR, $fg);
}

function makeOpaqueIcon(int $size, array $background, array $ink): GdImage
{
    $hi = canvas($size * SCALE, $background);
    drawRipples($hi, $ink, $background);
    $out = downscale($hi, $size);
    imagedestroy($hi);

    return $out;
}

function makeTransparentMark(int $size, array $ink): GdImage
{
    $hi = canvas($size * SCALE, null);
    drawRipples($hi, $ink);
    $out = downscale($hi, $size);
    imagedestroy($hi);

    return $out;
}

function roundImageCorners(GdImage $img, float $radius): void
{
    $w = imagesx($img);
    $h = imagesy($img);
    $r = (int) round($radius);
    $r2 = $r * $r;
    imagealphablending($img, false);
    $clear = imagecolorallocatealpha($img, 0, 0, 0, 127);
    for ($y = 0; $y < $r; $y++) {
        for ($x = 0; $x < $r; $x++) {
            $dx = $r - $x;
            $dy = $r - $y;
            if (($dx * $dx) + ($dy * $dy) > $r2) {
                imagesetpixel($img, $x, $y, $clear);
                imagesetpixel($img, $w - 1 - $x, $y, $clear);
                imagesetpixel($img, $x, $h - 1 - $y, $clear);
                imagesetpixel($img, $w - 1 - $x, $h - 1 - $y, $clear);
            }
        }
    }
    imagealphablending($img, true);
}

function makeSplashTile(int $canvasSize, int $tileSize): GdImage
{
    $hiTile = $tileSize * SCALE;
    $tile = canvas($hiTile, TEAL);
    drawRipples($tile, CREAM, TEAL);
    roundImageCorners($tile, $hiTile * 0.2237);

    $hiCanvas = $canvasSize * SCALE;
    $img = canvas($hiCanvas, null);
    $x = (int) (($hiCanvas - $hiTile) / 2);
    imagecopy($img, $tile, $x, $x, 0, 0, $hiTile, $hiTile);
    imagedestroy($tile);

    $out = downscale($img, $canvasSize);
    imagedestroy($img);

    return $out;
}

$icon = makeOpaqueIcon(1024, TEAL, CREAM);
save($icon, $out.DIRECTORY_SEPARATOR.'app_icon.png');
imagedestroy($icon);

$foreground = makeTransparentMark(1024, CREAM);
save($foreground, $out.DIRECTORY_SEPARATOR.'app_icon_foreground.png');
imagedestroy($foreground);

$splashIcon = makeSplashTile(1152, 640);
save($splashIcon, $out.DIRECTORY_SEPARATOR.'splash_icon.png');
imagedestroy($splashIcon);

$splashMark = makeTransparentMark(1152, TEAL);
save($splashMark, $out.DIRECTORY_SEPARATOR.'splash_mark.png');
imagedestroy($splashMark);

$splashMarkDark = makeTransparentMark(1152, CREAM);
save($splashMarkDark, $out.DIRECTORY_SEPARATOR.'splash_mark_dark.png');
imagedestroy($splashMarkDark);
