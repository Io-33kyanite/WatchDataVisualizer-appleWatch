# WatchDataVisualizer-appleWatch
[ongoing, 30%]Apple Watchでセンシング可能なデータ(主にMotion Data)をiPhoneで受け取り可視化するアプリ。

## Milestones
- [x] Start "iOS App with Watch App" project (2021/12/16)
- [x] Watch Connectivity (2021/12/16)
- [x] Core Motion on Apple Watch (2021/12/16)
- [x] Obtain acceleration values from my Apple Watch SE and display them realtime on my iPhone XR during foreground mode of the watch (2021/12/16)
- [ ] NOW: Under reseaching on Workout Session of HealthKit


## Issue1: Watchの点灯がオフになると加速度センサからのデータ取得が途絶える。(under investigation)
本当は，特定の行動中(歩行中の腕の動きなど)における加速度値をリアルタイムに監視しiPhone上で可視化したいのだが，
Apple Watchは一定時間経過するとバックグラウンドになりデータ取得が中断されてしまう。
「設定」から「70秒オン状態をキープ」に変更はできるのだが，手首を自分から遠ざけるように捻ると強制的にオフになってしまうことは防げない。
(Apple Watch5以降は常時オンできるみたいだが，私はApple Watch SE。)  

どうやらBackgroundでWatchKitを動作させるのは難しい？？ちょっと古い情報源しか見つからなかったが…
さしあたっては実験程度に試してみたかったことなので，(多少バッテリー消費がひどくても)常時オンでうまくいくならそれはそれでよかったが難しそうだ。
- [Can I keep my WatchKit App running in the background on the Apple Watch? | stack overflow, asked in 2015](https://stackoverflow.com/questions/32792260/can-i-keep-my-watchkit-app-running-in-the-background-on-the-apple-watch/32796823#32796823)
- [Share realtime accelerometer data from WatchOS to iOS app through Bluetooth | stack overflow, asked in 2018](https://stackoverflow.com/questions/48925253/share-realtime-accelerometer-data-from-watchos-to-ios-app-through-bluetooth)
- [Collect Sensor data in the background | Apple Developer Forums, asked 2 years ago](https://developer.apple.com/forums/thread/115056)
- [Is there any provision where I can access accelerometer sensor values from apple watch to iPhone when Apple watch-app is in background? | Apple Developer Forums, asked 2 yeas ago](https://developer.apple.com/forums/thread/115300)

これを解決する方法としては，
- ~~新しいApple Watchを買って試す。~~ (学生の財布には厳しい)
- リアルタイムを諦めて，一旦Apple Watchにデータを保持して，後でiPhoneへ送信して可視化する。
- Workout Sessionどうのこうのという情報がみられるが…詳しくないので調べる予定。


