# ルートディレクトリ

$TARGET_DIR="C:\Users\takamatsu.y-gs\Documents\test"

 

# ffmpegの実行ファイル

$FFMPEG="C:\ffmpeg\bin\ffmpeg.exe"

 

# エンコードオプション（ビデオ回り）

$FFMPEG_OPT_VIDEO="-vcodec libx264 -b:v 3M -s 1280x720"

 

# エンコードオプション（音声回り）

$FFMPEG_OPT_AUDIO="-acodec libfdk_aac -b:a 128k"

 

# スレッド数。CPUのコア数と同じにすればいいと思います。

$FFMPEG_OPT_THREADS="4"

 

# ファンクション定義 第一引数＝入力ファイルパス　第二引数＝出力ファイルパス

function h264enc {

    if ($args.count -ge 2) {

        $arg="-i '$args[0]' -movflags faststart $FFMPEG_OPT_VIDEO $FFMPEG_OPT_AUDIO -threads $FFMPEG_OPT_THREADS '$args[1]'"

        powershell -Command "$FFMPEG $arg"

    } else {

        "エンコード対象のファイルを指定してください。 第一引数＝入力ファイルパス　第二引数＝出力ファイルパス"

    }

}

 

cd $TARGET_DIR

# Get-ChildItem | ForEach-Object { h264enc $_.Basename }

$currenttime = Get-Date -Format "yyyy-MM-dd-hh-mm-ss"



$list = Get-ChildItem -Recurse -Path $TARGET_DIR -Directory -Filter *DC-GH5* | Get-ChildItem -Directory -Filter *video* | Get-ChildItem -Filter *.mp4

$list | ForEach-Object {

    $proxyfilename = $_.Directoryname + '\proxy\' + $_.Basename + 'mp4'

    if(Test-Path $proxyfilename) {

        echo("already exsist--> " + $proxyfilename)

    } else {

        echo("convert---------> " + $_.Fullname)

        h264enc $_.Fullname $proxyfilenmae

    }

} > .\log\$currenttime.txt
