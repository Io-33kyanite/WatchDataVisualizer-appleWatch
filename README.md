# WatchDataVisualizer-appleWatch
Apple Watchでセンシング可能なデータ(まずは加速度データ)をiPhoneで受け取り可視化するアプリ。

## Milestones
- [x] Start "iOS App with Watch App" project (2021/12/16)
- [x] Watch Connectivity (2021/12/16)
- [x] Core Motion on Apple Watch (2021/12/16)
- [x] Obtain acceleration values from my Apple Watch SE and display them realtime on my iPhone XR during foreground mode of the watch (2021/12/16)
- [x] Sample of a line chart for visualization of acceleration values (2021/12/26) 
- [x] Visualization of xyz-acceleration values my watch obtains on a line chart (2021/12/27)
- [ ] ~~Reseaching on Workout Session of HealthKit to solve Issue1.~~
- [x] Keep the app running even in inactive mode through extended runtime sessions. (2022/4/26)
- [ ] Making acceleration values stable such as through low-pass filter.
- [ ] Obtain other sorts of mobile sensor data.

## Demo
- A line chart shows us changes of acceleration values an Apple Watch SE gets. (2021/12/27)
![IMG_67E9DD21B0B2-1](https://user-images.githubusercontent.com/57740535/147449267-1c67a734-1082-4b9e-a8bd-85f3d7dcf3e1.png)  

- Right after you touch a start monitoring button, your watch starts to fetch motion data and transmits them to your iPhone in realtime.

![IMG_5850](https://user-images.githubusercontent.com/57740535/165278931-2f3202b3-4b8f-49a1-b44c-09537e903b3e.PNG)


## Issue1: Watchの点灯がオフになると加速度センサからのデータ取得が途絶える。(solved)  
__2022/04/26__
Extended Runtime Sessions [(参考:Apple Developer Documents)](https://developer.apple.com/documentation/watchkit/using_extended_runtime_sessions) を利用することでWatchの点灯がオフ(Inactive)になってもアプリを動作させることができた。

---
本当は，特定の行動中(歩行中の腕の動きなど)における加速度値をリアルタイムに監視しiPhone上で可視化したいのだが，
Apple Watchは一定時間経過するとバックグラウンドになりデータ取得が中断されてしまう。
「設定」から「70秒オン状態をキープ」に変更はできるのだが，手首を自分から遠ざけるように捻ると強制的にオフになってしまうことは防げない。
(Apple Watch5以降は常時オンできるみたいだが，私はApple Watch SE。)  

どうやらBackgroundでWatchKitを動作させるのは難しい？？ちょっと古い情報源しか見つからなかったが…  
- [Can I keep my WatchKit App running in the background on the Apple Watch? | stack overflow, asked in 2015](https://stackoverflow.com/questions/32792260/can-i-keep-my-watchkit-app-running-in-the-background-on-the-apple-watch/32796823#32796823)
- [Share realtime accelerometer data from WatchOS to iOS app through Bluetooth | stack overflow, asked in 2018](https://stackoverflow.com/questions/48925253/share-realtime-accelerometer-data-from-watchos-to-ios-app-through-bluetooth)
- [Collect Sensor data in the background | Apple Developer Forums, asked 2 years ago](https://developer.apple.com/forums/thread/115056)
- [Is there any provision where I can access accelerometer sensor values from apple watch to iPhone when Apple watch-app is in background? | Apple Developer Forums, asked 2 yeas ago](https://developer.apple.com/forums/thread/115300)

これを解決する方法としては，
- Apple Watch Series5以降に実装されている「常にオン」なら可能？？  
  - Ans. できなかった。画面は点灯したままだが，動作は停止している。
- リアルタイムを諦めて，一旦Apple Watchにデータを保持して，後でiPhoneへ送信して可視化する。
- Workout Sessionどうのこうのという情報がみられるが…詳しくないので調べる予定。  
  - Ans. HealthKitで扱えるデータの中に加速度データはない。


## Reference
- [Charts | GitHub](https://github.com/danielgindi/Charts)
- [Creating a Line Chart in Swift and iOS | by Osian Smith | Medium](https://medium.com/@OsianSmith/creating-a-line-chart-in-swift-3-and-ios-10-2f647c95392e)
- [iphoneアプリで加速度センサーの値をリアルタイムにグラフ表示する - ITエンジニアへの転身](https://non-it-engineer.com/iphone%E3%82%A2%E3%83%97%E3%83%AA%E3%81%A7%E5%8A%A0%E9%80%9F%E5%BA%A6%E3%82%BB%E3%83%B3%E3%82%B5%E3%83%BC%E3%81%AE%E5%80%A4%E3%82%92%E3%83%AA%E3%82%A2%E3%83%AB%E3%82%BF%E3%82%A4%E3%83%A0%E3%81%AB/)


## Others
This software includes the work that is distributed in the Apache License 2.0.
